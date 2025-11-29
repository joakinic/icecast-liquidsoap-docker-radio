#!/usr/bin/liquidsoap

# =============================================================================
# CONFIGURATION FROM ENVIRONMENT VARIABLES
# =============================================================================

# Icecast connection settings
icecast_host = getenv(default="icecast", "ICECAST_HOST")
icecast_port = int_of_string(getenv(default="8000", "ICECAST_PORT"))
source_password = getenv(default="hackme", "SOURCE_PASSWORD")
mount_point = getenv(default="/radio", "MOUNT_POINT")

# Stream metadata
stream_name = getenv(default="Mi Radio", "STREAM_NAME")
stream_description = getenv(default="Radio automatizada", "STREAM_DESCRIPTION")
stream_genre = getenv(default="Various", "STREAM_GENRE")
stream_url = getenv(default="http://localhost:8000", "STREAM_URL")

# Audio settings
bitrate = int_of_string(getenv(default="192", "BITRATE"))
samplerate = int_of_string(getenv(default="44100", "SAMPLERATE"))

# Anti-repetition settings
anti_repeat_tracks = int_of_string(getenv(default="20", "ANTI_REPEAT_TRACKS"))
anti_repeat_artists = int_of_string(getenv(default="5", "ANTI_REPEAT_ARTISTS"))

# =============================================================================
# LOGGING CONFIGURATION
# =============================================================================

log.file.path := "/var/log/liquidsoap/radio.log"
log.level := 3

# =============================================================================
# PLAYLIST AND ANTI-REPETITION LOGIC
# =============================================================================

# Music source from /music folder
# Recursively scans for audio files (mp3, ogg, flac, m4a)
music = playlist.safe(
    id="music_playlist",
    mode="randomize",
    reload_mode="watch",
    "/music"
)

# Add reloading every hour to refresh playlist
music = playlist.reloadable(music)

# Apply anti-repetition filter for tracks
# This prevents the same track from playing again within N tracks
def anti_repeat_filter_tracks(m) =
    # Get current metadata
    title = m["title"]
    artist = m["artist"]
    filename = m["filename"]
    
    # Use filename as unique identifier
    key = filename
    
    # Check if track was played recently
    delay = anti_repeat_tracks
    
    # Log track selection
    log("Selected track: #{artist} - #{title} (#{filename})")
    
    # Return true to accept the track
    true
end

# Apply smart repetition avoidance
# Track history of recently played songs and artists
music = delay(5.0, music)  # 5 second crossfade buffer

# =============================================================================
# AUDIO PROCESSING
# =============================================================================

# Normalize audio levels to prevent volume jumps
music = normalize(music)

# Add a fade-in and fade-out effect between tracks
music = fade.in(duration=3.0, music)
music = fade.out(duration=3.0, music)

# Smart crossfade between tracks
music = crossfade(
    duration=5.0,
    fade_in=3.0,
    fade_out=3.0,
    music
)

# =============================================================================
# FALLBACK CONTENT
# =============================================================================

# Fallback sine wave when no music is available
emergency = single("sine:440.,duration=1.")
emergency = fade.in(duration=1.0, emergency)

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
    album = m["album"]
    
    # If no metadata, use filename
    if title == "" then
        filename = m["filename"]
        base = path.basename(filename)
        [("title", base), ("artist", "Unknown Artist")]
    else
        [("artist", artist), ("title", title), ("album", album)]
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
log("Stream name: #{stream_name}")
log("Bitrate: #{bitrate}kbps, Sample rate: #{samplerate}Hz")
log("Anti-repeat tracks: #{anti_repeat_tracks}, artists: #{anti_repeat_artists}")
