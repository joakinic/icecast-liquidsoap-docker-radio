# 📻 Radio Streaming Automatizada con Docker

Sistema de radio por Internet completamente automatizado usando Icecast y Liquidsoap en contenedores Docker.

## 🎯 Características

- ✅ Streaming de audio con Icecast
- ✅ Reproducción aleatoria automática con Liquidsoap
- ✅ Anti-repetición inteligente de canciones y artistas
- ✅ Configuración mediante variables de entorno (.env)
- ✅ Normalización de audio y crossfade entre pistas
- ✅ Gestión de metadatos automática
- ✅ Control remoto vía telnet
- ✅ Carpeta de música externa montada como volumen

## 📋 Requisitos Previos

- Docker Desktop instalado
- Docker Compose
- Carpeta con archivos de música (MP3, OGG, FLAC, M4A)

## 🚀 Instalación Rápida

### 1. Configurar el entorno

```powershell
# Copiar el archivo de ejemplo de configuración
Copy-Item .env.example .env

# Editar .env con tus configuraciones
notepad .env
```

**Variables importantes a configurar en `.env`:**

```env
# Contraseñas de acceso
ADMIN_PASSWORD=tu_contraseña_admin
SOURCE_PASSWORD=tu_contraseña_streaming

# Ruta absoluta a tu carpeta de música (Windows)
MUSIC_FOLDER_PATH=C:/Users/TuUsuario/Music/Radio

# O en Linux/Mac
# MUSIC_FOLDER_PATH=/home/tuusuario/musica/radio
```

### 2. Preparar la carpeta de música

Asegúrate de que tu carpeta de música contenga archivos de audio compatibles:

```
C:/Users/TuUsuario/Music/Radio/
├── cancion1.mp3
├── cancion2.mp3
├── album/
│   ├── track1.flac
│   └── track2.flac
└── ...
```

### 3. Iniciar la radio

```powershell
# Construir e iniciar los contenedores
docker-compose up -d

# Ver los logs en tiempo real
docker-compose logs -f
```

### 4. Acceder a la radio

Una vez iniciado, la radio estará disponible en:

- **Stream de audio:** `http://localhost:8000/radio`
- **Panel de administración Icecast:** `http://localhost:8000/admin/`
  - Usuario: `admin`
  - Contraseña: (la que configuraste en `ADMIN_PASSWORD`)

## ⚙️ Configuración Detallada

### Variables de Entorno

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `ADMIN_PASSWORD` | Contraseña del panel admin de Icecast | `adminpassword123` |
| `SOURCE_PASSWORD` | Contraseña para streaming | `sourcepassword123` |
| `MUSIC_FOLDER_PATH` | Ruta a la carpeta de música | *(requerido)* |
| `ICECAST_PORT` | Puerto de Icecast | `8000` |
| `MOUNT_POINT` | Punto de montaje del stream | `/radio` |
| `STREAM_NAME` | Nombre de la radio | `Mi Radio` |
| `BITRATE` | Bitrate del stream (kbps) | `192` |
| `SAMPLERATE` | Frecuencia de muestreo (Hz) | `44100` |
| `ANTI_REPEAT_TRACKS` | Canciones antes de repetir | `20` |
| `ANTI_REPEAT_ARTISTS` | Canciones antes de repetir artista | `5` |

### Anti-repetición

El sistema evita automáticamente:
- **Canciones repetidas:** No reproduce la misma canción hasta que pasen N canciones (configurable)
- **Artistas repetidos:** Limita la frecuencia de canciones del mismo artista

Ajusta estos valores en el archivo `.env`:

```env
ANTI_REPEAT_TRACKS=30    # Espera 30 canciones antes de repetir
ANTI_REPEAT_ARTISTS=10   # Espera 10 canciones antes de repetir artista
```

## 🎛️ Control Remoto

Liquidsoap expone un servidor telnet en el puerto 1234 para control remoto:

```powershell
# Conectarse al servidor telnet
telnet localhost 1234

# Comandos disponibles:
# help              - Lista todos los comandos
# request.metadata  - Ver metadata de la canción actual
# music_playlist.reload - Recargar la lista de reproducción
# quit              - Salir del telnet
```

## 📂 Estructura del Proyecto

```
Radio/
├── docker-compose.yml          # Orquestación de servicios
├── .env                        # Configuración (no versionado)
├── .env.example                # Plantilla de configuración
├── config/
│   ├── icecast.xml            # Configuración de Icecast
│   └── icecast-entrypoint.sh  # Script de inicio de Icecast
├── liquidsoap/
│   ├── Dockerfile             # Imagen de Liquidsoap
│   ├── entrypoint.sh          # Script de inicio
│   └── radio.liq              # Script de automatización
└── logs/                      # Logs de los servicios
    ├── icecast/
    └── liquidsoap/
```

## 🔧 Comandos Útiles

```powershell
# Iniciar la radio
docker-compose up -d

# Detener la radio
docker-compose down

# Ver logs
docker-compose logs -f

# Ver logs solo de Liquidsoap
docker-compose logs -f liquidsoap

# Ver logs solo de Icecast
docker-compose logs -f icecast

# Reiniciar servicios
docker-compose restart

# Reconstruir las imágenes
docker-compose build --no-cache

# Recargar lista de reproducción (agregar nuevas canciones)
docker-compose restart liquidsoap
```

## 🎵 Reproducir el Stream

### En VLC Media Player

1. Abrir VLC
2. Media → Abrir ubicación de red
3. Ingresar: `http://localhost:8000/radio`
4. Reproducir

### En navegador web

Directamente: `http://localhost:8000/radio`

### En aplicaciones móviles

Usar cualquier reproductor de radio por Internet e ingresar la URL:
- `http://TU_IP:8000/radio`

## 🐛 Solución de Problemas

### No se reproduce música

```powershell
# Verificar que hay archivos de música
docker-compose exec liquidsoap ls -la /music

# Ver logs de Liquidsoap
docker-compose logs liquidsoap
```

### No puedo acceder al stream

```powershell
# Verificar que los contenedores están corriendo
docker-compose ps

# Verificar logs de Icecast
docker-compose logs icecast

# Verificar conectividad
curl http://localhost:8000/status.xsl
```

### Cambiar configuración

1. Editar `.env`
2. Reiniciar los servicios:

```powershell
docker-compose down
docker-compose up -d
```

## 📊 Monitoreo

Ver estadísticas de la radio en el panel de Icecast:
- URL: `http://localhost:8000/admin/stats.xsl`
- Ver oyentes conectados, bitrate, uptime, etc.

## 🔒 Seguridad

⚠️ **Importante:**

- Cambia las contraseñas por defecto en el archivo `.env`
- No compartas tu archivo `.env` (ya está en `.gitignore`)
- Si expones la radio a Internet, considera usar un reverse proxy con HTTPS
- Limita el acceso al panel de administración

## 🌐 Exponer la Radio a Internet

Para que tu radio sea accesible desde Internet:

1. **Configurar puerto forwarding** en tu router (puerto 8000)
2. **Usar reverse proxy** (recomendado):
   - Nginx o Traefik con SSL/TLS
   - Cloudflare Tunnel
3. **Actualizar variables en `.env`:**

```env
ICECAST_HOSTNAME=tu-dominio.com
STREAM_URL=https://tu-dominio.com
```

## 📝 Licencia

Este proyecto es de código abierto. Usa, modifica y distribuye libremente.

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si encuentras algún problema o tienes sugerencias, no dudes en reportarlo.

---

**¡Disfruta de tu radio automatizada!** 📻🎶
