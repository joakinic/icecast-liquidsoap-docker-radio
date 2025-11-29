#!/usr/bin/liquidsoap

# =============================================================================
# LOGGING CONFIGURATION
# =============================================================================

log.file.path := "/var/log/liquidsoap/radio.log"
log.level := 3

# =============================================================================
# CONFIGURATION
# =============================================================================

# Hardcoded configuration - will be replaced by environment variables via Docker
icecast_host = "icecast"
icecast_port = 8000
source_password = "sourcepassword123"
mount_point = "/radio"
stream_name = "Mi Radio"
stream_description = "Radio automatizada con Docker"
stream_genre = "Various"
stream_url = "http://localhost:8000"
bitrate = 192
samplerate = 44100

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

# Crossfade between tracks
music = crossfade(
    duration=5.0,
    music
)

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
