#!/bin/bash

read -rp "📺 Enter YouTube URL: " url

# Exit if empty
[ -z "$url" ] && { echo "No URL entered. Exiting."; exit 1; }

# Download directory
outdir="/mnt/hdd/downloads/youtube"

# Ensure folder exists
mkdir -p "$outdir"

echo "⬇️  Downloading to $outdir ..."
yt-dlp --remote-components ejs:github \
  -f bestvideo+bestaudio \
  --merge-output-format mp4 \
  -o "$outdir/%(title)s.%(ext)s" \
  "$url"

if [ $? -eq 0 ]; then
    echo "✅ Download complete!"
else
    echo "❌ Download failed."
fi
