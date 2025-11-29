#!/bin/bash

echo "Starting Liquidsoap Radio Automation..."
echo "Icecast Host: ${ICECAST_HOST}"
echo "Mount Point: ${MOUNT_POINT}"
echo "Stream Name: ${STREAM_NAME}"
echo "Music Folder: /music"

# Check if music folder has files
MUSIC_COUNT=$(find /music -type f \( -iname "*.mp3" -o -iname "*.ogg" -o -iname "*.flac" -o -iname "*.m4a" \) 2>/dev/null | wc -l)
echo "Found ${MUSIC_COUNT} music files"

if [ "$MUSIC_COUNT" -eq 0 ]; then
    echo "WARNING: No music files found in /music folder!"
    echo "Please ensure the MUSIC_FOLDER_PATH in .env points to a directory with audio files."
fi

# Start Liquidsoap
exec liquidsoap /etc/liquidsoap/radio.liq
