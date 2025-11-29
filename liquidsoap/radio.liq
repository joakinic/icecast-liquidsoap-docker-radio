#!/usr/bin/liquidsoap

# =============================================================================
# LOGGING CONFIGURATION
# =============================================================================

log.file.path := "/var/log/liquidsoap/radio.log"
log.level := 3

# =============================================================================
# CONFIGURATION (Placeholders replaced by entrypoint.sh)
# =============================================================================

icecast_host = "%%ICECAST_HOST%%"
icecast_port = %%ICECAST_PORT%%
source_password = "%%SOURCE_PASSWORD%%"
mount_point = "%%MOUNT_POINT%%"
stream_name = "%%STREAM_NAME%%"
stream_description = "%%STREAM_DESCRIPTION%%"
stream_genre = "%%STREAM_GENRE%%"
stream_url = "%%STREAM_URL%%"
bitrate = %%BITRATE%%
samplerate = %%SAMPLERATE%%
anti_repeat_tracks = %%ANTI_REPEAT_TRACKS%%
anti_repeat_artists = %%ANTI_REPEAT_ARTISTS%%

# =============================================================================
# PLAYLIST
# =============================================================================

# Music source from /music folder
music = playlist(
    id="music_playlist",
    mode="randomize",
    reload_mode="watch",
    "/music"
)

# =============================================================================
# AUDIO PROCESSING
# =============================================================================

# Normalize audio levels
music = normalize(music)

# Crossfade between tracks (handles fades automatically)
music = crossfade(duration=5.0, music)

# =============================================================================
# FALLBACK
# =============================================================================

# Blank audio fallback when no music is available
emergency = blank()

# Use music, fall back to emergency if playlist is empty
radio = fallback(
    track_sensitive=false,
    [music, emergency]
)

# =============================================================================
# METADATA HANDLING
# =============================================================================

# Function to extract and format metadata
def apply_metadata(m) =
    artist = m["artist"]
    title = m["title"]
    
    # If no metadata, use filename
    if title == "" then
        filename = m["filename"]
        base = path.basename(filename)
        [("title", base), ("artist", "Unknown Artist")]
    else
        [("artist", artist), ("title", title)]
    end
end

radio = map_metadata(apply_metadata, radio)

# =============================================================================
# TELNET SERVER (for remote control)
# =============================================================================

# Enable telnet server on port 1234
server.telnet(port=1234)

# =============================================================================
# OUTPUT TO ICECAST
# =============================================================================

# Encode and send to Icecast server
output.icecast(
    %mp3(bitrate=bitrate, samplerate=samplerate),
    host=icecast_host,
    port=icecast_port,
    password=source_password,
    mount=mount_point,
    name=stream_name,
    description=stream_description,
    genre=stream_genre,
    url=stream_url,
    public=false,
    radio
)

# Log startup
log("Radio automation started!")
log("Streaming to icecast://#{icecast_host}:#{icecast_port}#{mount_point}")
log("Stream: #{stream_name} - #{stream_description}")
log("Bitrate: #{bitrate}kbps, Sample rate: #{samplerate}Hz")
log("Anti-repeat: tracks=#{anti_repeat_tracks}, artists=#{anti_repeat_artists}")
