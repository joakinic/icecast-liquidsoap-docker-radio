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

# Create temporary file with substitutions
cp /etc/liquidsoap/radio.liq /tmp/radio.liq

# Replace placeholders with environment variables
sed -i "s|%%ICECAST_HOST%%|${ICECAST_HOST}|g" /tmp/radio.liq
sed -i "s|%%ICECAST_PORT%%|${ICECAST_PORT}|g" /tmp/radio.liq
sed -i "s|%%SOURCE_PASSWORD%%|${SOURCE_PASSWORD}|g" /tmp/radio.liq
sed -i "s|%%MOUNT_POINT%%|${MOUNT_POINT}|g" /tmp/radio.liq
sed -i "s|%%STREAM_NAME%%|${STREAM_NAME}|g" /tmp/radio.liq
sed -i "s|%%STREAM_DESCRIPTION%%|${STREAM_DESCRIPTION}|g" /tmp/radio.liq
sed -i "s|%%STREAM_GENRE%%|${STREAM_GENRE}|g" /tmp/radio.liq
sed -i "s|%%STREAM_URL%%|${STREAM_URL}|g" /tmp/radio.liq
sed -i "s|%%BITRATE%%|${BITRATE}|g" /tmp/radio.liq
sed -i "s|%%SAMPLERATE%%|${SAMPLERATE}|g" /tmp/radio.liq
sed -i "s|%%ANTI_REPEAT_TRACKS%%|${ANTI_REPEAT_TRACKS}|g" /tmp/radio.liq
sed -i "s|%%ANTI_REPEAT_ARTISTS%%|${ANTI_REPEAT_ARTISTS}|g" /tmp/radio.liq

# Start Liquidsoap with processed configuration
exec liquidsoap /tmp/radio.liq
