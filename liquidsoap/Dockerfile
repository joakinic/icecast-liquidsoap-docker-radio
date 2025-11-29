FROM savonet/liquidsoap:v2.2.5

# Cambiar a usuario root para instalaciones
USER root

# Instalar ffmpeg usando apt (Debian-based)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Copiar scripts
COPY radio.liq /etc/liquidsoap/radio.liq
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Crear directorio de logs
RUN mkdir -p /var/log/liquidsoap && \
    chown -R liquidsoap:liquidsoap /var/log/liquidsoap

# Volver a usuario liquidsoap
USER liquidsoap

# Exponer puerto telnet para control remoto
EXPOSE 1234

ENTRYPOINT ["/entrypoint.sh"]
