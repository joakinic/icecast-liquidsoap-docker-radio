FROM savonet/liquidsoap:v2.2.3

# Install additional tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /etc/liquidsoap /var/log/liquidsoap /music

# Copy configuration
COPY radio.liq /etc/liquidsoap/radio.liq
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working directory
WORKDIR /etc/liquidsoap

# Expose telnet port for remote control (optional)
EXPOSE 1234

ENTRYPOINT ["/entrypoint.sh"]
