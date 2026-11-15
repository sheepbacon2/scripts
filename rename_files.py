#!/usr/bin/env python3
"""Rename or organize any regular files. Preview by default; --apply makes changes."""
import argparse
from dataclasses import dataclass
import fnmatch
import os
from pathlib import Path
import re

EPISODE = re.compile(r'(?i)(?<![a-z0-9])(?:s(\d{1,2})e(\d{1,3})|(\d{1,2})x(\d{1,3}))(?!\d)')


@dataclass
class Move:
    source: Path
    target: Path
    identity: tuple


def identity(path):
    st = path.lstat()
    return st.st_dev, st.st_ino, st.st_size, st.st_mtime_ns


def valid_name(value):
    if value in {'', '.', '..'} or not value.strip() or any(c in value for c in '/\\\0\n\r'):
        raise ValueError(f'Invalid filename or folder name: {value!r}')
    return value


def parser():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='Templates name the file stem; the original extension is appended automatically.\n'
               'Fields: {name}, {original}, {n:03d}, {parent}; with --show: {show}, {season:02d}, {episode:02d}.\n'
               'Example: rename_files.py ~/Pictures --match "*.jpg" --template "Holiday - {n:03d}"\n'
               'Moves require a filesystem with hard-link support, and cannot cross filesystems.')
    p.add_argument('source', type=Path, help='File or directory to process')
    p.add_argument('--match', action='append', help='Filename glob; repeat to include multiple patterns (quote wildcards)')
    p.add_argument('--recursive', action='store_true', help='Include subdirectories; never follow symlinks')
    p.add_argument('--include-hidden', action='store_true', help='Include hidden files and directories')
    p.add_argument('--replace', nargs=2, action='append', default=[], metavar=('OLD', 'NEW'), help='Literal stem replacement; repeatable')
    p.add_argument('--regex', nargs=2, metavar=('PATTERN', 'REPLACEMENT'), help='Python regex replacement on the stem')
    p.add_argument('--case', choices=['lower', 'upper', 'title'])
    p.add_argument('--prefix', default='')
    p.add_argument('--suffix', default='', help='Text before the extension')
    p.add_argument('--template', help='Stem format, e.g. "Document - {n:03d}"')
    p.add_argument('--start', type=int, default=1, help='Starting number (default: 1)')
    p.add_argument('--output', type=Path, help='Destination directory; preserves relative subdirectories')
    p.add_argument('--group-by', choices=['extension'], help='Put files into extension folders (pdf, jpg, no-extension)')
    p.add_argument('--show', help='TV mode: uniform show name and show/season folders; preserves episode numbers')
    p.add_argument('--apply', action='store_true', help='Perform changes instead of previewing')
    return p


def files(source, args, output):
    if source.is_file():
        candidates = [source]
    else:
        candidates = []
        for root, dirs, names in os.walk(source, followlinks=False):
            base = Path(root)
            dirs[:] = sorted(d for d in dirs if not (base / d).is_symlink()
                             and (args.include_hidden or not d.startswith('.'))
                             and not (output != source and base / d == output))
            candidates.extend(base / name for name in names)
            if not args.recursive:
                break
    return sorted((f for f in candidates if f.is_file() and not f.is_symlink()
                   and (args.include_hidden or not f.name.startswith('.'))
                   and (not args.match or any(fnmatch.fnmatchcase(f.name, pattern) for pattern in args.match))),
                  key=lambda f: str(f))


def build_plan(args):
    raw = args.source.expanduser().absolute()
    if raw.is_symlink():
        raise ValueError('Source must not be a symlink.')
    source = raw.resolve(strict=True)
    if not source.is_file() and not source.is_dir():
        raise ValueError('Source must be a regular file or directory.')
    base = source if source.is_dir() else source.parent
    output = args.output.expanduser().resolve() if args.output else (base.parent if args.show else base)
    if args.show:
        valid_name(args.show)
    pattern = re.compile(args.regex[0]) if args.regex else None
    moves, targets = [], set()
    number = args.start
    for src in files(source, args, output):
        name = src.stem
        fields = dict(original=name, parent=src.parent.name, n=number)
        folder = output / src.parent.relative_to(base)
        if args.show:
            matches = list(EPISODE.finditer(name))
            if len(matches) != 1 or re.match(r'(?i)(?:[ ._-]*e\d|[ ._-]*-\s*\d)', name[matches[0].end():]):
                print(f'SKIP (episode unclear or multiple episodes): {src.name!r}')
                continue
            m = matches[0]
            season, episode = int(m[1] or m[3]), int(m[2] or m[4])
            fields.update(show=args.show, season=season, episode=episode)
            name = f'{args.show} - S{season:02d}E{episode:02d}'
            folder = output / args.show / f'Season {season:02d}'
        for old, new in args.replace:
            if not old:
                raise ValueError('--replace OLD must not be empty.')
            name = name.replace(old, new)
        if pattern:
            name = pattern.sub(args.regex[1], name)
        if args.case:
            name = getattr(name, args.case)()
        fields['name'] = name
        if args.template:
            name = args.template.format(**fields)
        name = valid_name(args.prefix + name + args.suffix + src.suffix)
        if args.group_by:
            folder /= valid_name(src.suffix[1:].lower() or 'no-extension')
        target = folder / name
        if target != target.resolve():
            raise ValueError(f'Destination contains a symlink: {target}')
        if target != src:
            if target in targets or os.path.lexists(target):
                raise ValueError(f'Destination conflict: {target}; no files moved.')
            parent = target.parent
            while not parent.exists():
                parent = parent.parent
            if not parent.is_dir():
                raise ValueError(f'Destination parent is not a directory: {parent}')
            if parent.stat().st_dev != src.stat().st_dev:
                raise ValueError(f'Cannot move across filesystems: {src} -> {target}')
            targets.add(target)
            moves.append(Move(src, target, identity(src)))
        number += 1
    return moves


def apply(moves):
    # Check the entire batch before changing any filenames.
    for move in moves:
        if identity(move.source) != move.identity or move.source.is_symlink():
            raise ValueError(f'Source changed since planning: {move.source}')
        if os.path.lexists(move.target):
            raise ValueError(f'Destination now exists: {move.target}')
    for move in moves:
        move.target.parent.mkdir(parents=True, exist_ok=True)
        # link() atomically refuses an existing destination, unlike rename().
        os.link(move.source, move.target, follow_symlinks=False)
        move.source.unlink()
        print(f'MOVED {str(move.source)!r} -> {str(move.target)!r}')


def main(argv=None):
    p = parser()
    args = p.parse_args(argv)
    try:
        moves = build_plan(args)
        for move in moves:
            print(f'{str(move.source)!r}\n  -> {str(move.target)!r}')
        if args.apply:
            apply(moves)
            print(f'Moved {len(moves)} files.')
        else:
            print(f'Preview: {len(moves)} files. Add --apply to make changes.')
    except (OSError, ValueError, KeyError, IndexError, re.error) as exc:
        p.exit(1, f'Error: {exc}\n' + ('If execution started, earlier MOVED entries remain applied.\n' if args.apply else ''))


if __name__ == '__main__':
    main()
