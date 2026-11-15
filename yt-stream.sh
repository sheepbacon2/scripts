#!/bin/bash

read -rp "📺 Enter YouTube URL: " url

[ -z "$url" ] && { echo "No URL entered."; exit 1; }

vlc "$(yt-dlp --remote-components ejs:github -f b -g "$url")"

