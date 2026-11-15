# Personal scripts

Utilities for my Arch Linux / i3 desktop. Scripts are kept at the repository root; install the ones you need into `~/.local/bin` and make them executable.

| Scripts | Purpose / dependencies |
| --- | --- |
| `rename_files.py` | Interactive file renaming (Python 3). |
| `cleanup-system` | Preview package/cache cleanup; `--apply` prompts for each stage. Arch Linux, optional pacman-contrib and Flatpak. |
| `i3-session` | Save, list, choose and restore i3 workspace snapshots; Python i3ipc and i3-resurrect, rofi for choosing. |
| `i3-mouse-smooth` | Continuous keyboard pointer motion; Python i3ipc and python-xlib, i3 mouse mode bindings, xdotool. |
| `i3-mouse-slot`, `click.sh`, `mousepos.sh` | Save, jump to or click mouse slots 1–9; xdotool and notify-send. Wrappers expect the helper in `~/.local/bin`. |
| `i3-keybindings` | Show shortcuts with rofi; reads bindings.conf, movements.conf, workspaces.conf, mouse.conf and session.conf in `~/.config/i3`. |
| `monitor_resolution.sh` | Choose external monitor placement and resolution; xrandr, dmenu and notify-send. |
| `dual.sh`, `regscreen.sh`, `tv.sh`, `wilatv.sh` | Machine-specific monitor presets; check output names and modes before use. |
| `sleepmode.sh` | Suspend after a chosen number of minutes; systemctl, notify-send and optional dmenu. |
| `yt-stream.sh`, `ytdl.sh` | Stream with VLC or download with yt-dlp; downloads currently go to `/mnt/hdd/downloads/youtube`. |
| `nmclic.sh`, `nordvpnc.sh` | NetworkManager Wi-Fi / NordVPN menus using dmenu. |
| `mountexthdd.sh`, `veracryptext.sh`, `veracrypthdd.sh`, `veracryptmount.sh` | Mount helpers with machine-specific device/container paths. |
| `xevkey.sh` | Inspect keyboard events with xev. |
| `roblox.sh` | Periodically focus the Sober window and send space; i3-msg and xdotool. |

`i3-session` and `i3-mouse-smooth` retain the installed interpreter path `/home/wes/.local/share/i3-session/venv/bin/python`. On another machine, adjust that shebang to an interpreter with the required modules. The mouse helper expects the existing i3 `mousepos` / `mouseposClick` modes and `nop pointer-button-*` bindings; desktop configuration is maintained separately.

The scripts added from `~/.local/bin` passed shell/Python syntax checks. Desktop actions, mounting, downloading and cleanup were not executed during import. Existing repository scripts were preserved.
