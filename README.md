# 📻 Radio Streaming con Docker

Radio por Internet automatizada usando **Icecast** (servidor de streaming) y **Liquidsoap** (automatización y reproducción). Todo corre en contenedores Docker.

## 🎯 ¿Qué hace?

- Reproduce música aleatoriamente desde una carpeta
- Transmite el stream por HTTP (puerto 8000)
- Detecta automáticamente nuevos archivos agregados
- Normaliza volumen y aplica crossfade entre canciones
- Configurable mediante variables de entorno

## 🚀 Instalación Rápida

### 1. Clonar o descargar

```bash
git clone https://github.com/joakinic/icecast-liquidsoap-docker-radio.git
cd icecast-liquidsoap-docker-radio
```

### 2. Configurar

```bash
# Copiar archivo de configuración
cp .env.example .env

# Editar .env (opcional - ya viene configurado con valores por defecto)
nano .env
```

**Variables principales:**
- `MUSIC_FOLDER_PATH=./music` - Carpeta con archivos MP3/FLAC/OGG
- `ADMIN_PASSWORD` - Contraseña del panel admin de Icecast
- `SOURCE_PASSWORD` - Contraseña de streaming
- `STREAM_NAME` - Nombre de tu radio

### 3. Agregar música

Copia tus archivos de audio a la carpeta `music/`:

```bash
# Ejemplo
cp /ruta/a/tus/canciones/*.mp3 music/
```

### 4. Iniciar

```bash
docker compose up -d
```

## 🎵 Uso

### Escuchar la radio

**Stream:** http://localhost:8000/radio

Abre en VLC, navegador, o cualquier reproductor de radio por Internet.

### Panel de administración

**URL:** http://localhost:8000/admin/  
**Usuario:** `admin`  
**Contraseña:** (la configurada en `ADMIN_PASSWORD`)

### Control remoto (Telnet)

```bash
# Conectarse al servidor de control
docker exec -it radio-liquidsoap telnet localhost 1234

# Comandos útiles:
help                    # Ver todos los comandos
music_playlist.skip     # Saltar canción actual
music_playlist.next     # Ver próximas canciones
music_playlist.reload   # Recargar lista
quit                    # Salir
```

## ⚙️ Configuración

### Variables de entorno (.env)

| Variable | Descripción | Por defecto |
|----------|-------------|-------------|
| `MUSIC_FOLDER_PATH` | Carpeta de música (absoluta o relativa) | `./music` |
| `ADMIN_PASSWORD` | Contraseña admin Icecast | `adminpassword123` |
| `SOURCE_PASSWORD` | Contraseña streaming | `sourcepassword123` |
| `ICECAST_PORT` | Puerto de Icecast | `8000` |
| `STREAM_NAME` | Nombre de la radio | `Mi Radio` |
| `BITRATE` | Bitrate en kbps | `192` |
| `SAMPLERATE` | Frecuencia de muestreo | `44100` |

### Aplicar cambios

Después de modificar `.env`:

```bash
docker compose restart
```

## 📂 Estructura del Proyecto

```
.
├── docker-compose.yml      # Orquestación de servicios
├── .env                    # Configuración (no versionado)
├── .env.example           # Plantilla de configuración
├── config/
│   └── icecast.xml        # Configuración de Icecast
├── liquidsoap/
│   ├── Dockerfile         # Imagen de Liquidsoap
│   ├── entrypoint.sh      # Script de inicio
│   └── radio.liq          # Script de automatización
└── music/                 # Tu carpeta de música
```

## 🔧 Comandos Útiles

```bash
# Ver logs en tiempo real
docker compose logs -f

# Ver solo logs de Liquidsoap
docker compose logs -f liquidsoap

# Reiniciar servicios
docker compose restart

# Detener radio
docker compose down

# Ver estado
docker compose ps
```

## 🎼 Formatos de Audio Soportados

- MP3
- FLAC
- OGG
- M4A/AAC

## 🌐 Exponer a Internet

Para que tu radio sea accesible desde Internet:

1. Configurar **port forwarding** en tu router (puerto 8000)
2. O usar un **reverse proxy** con SSL (Nginx, Traefik, Cloudflare Tunnel)
3. Actualizar variables en `.env`:
   ```env
   ICECAST_HOSTNAME=tu-dominio.com
   STREAM_URL=https://tu-dominio.com
   ```

## 📝 Licencia

MIT - Usa, modifica y distribuye libremente.

## 🤝 Contribuciones

Issues y pull requests son bienvenidos en [GitHub](https://github.com/joakinic/icecast-liquidsoap-docker-radio).
