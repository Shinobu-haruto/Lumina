#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RECOVERY="$BASE_DIR/tools/recovery.sh"

# Detectar idioma
USER_LANG="${LANG%%.*}"

# Mensajes por idioma
if [ "${USER_LANG#es}" != "$USER_LANG" ]; then
    # Español
    M_TITLE="Lumina UI – Protección del sistema visual"
    M_TEXT="Se detectaron modificaciones en archivos de la interfaz del sistema.

Esto significa que uno o más archivos no coinciden con la versión original de esta build.

Posibles causas:
 • Personalización manual
 • Actualización incompleta
 • Corrupción de archivos

Acciones recomendadas:
 • Restaurar los archivos ahora
 • Ignorar este aviso si el cambio fue intencional"

    M_RESTORE="Restaurar ahora"
    M_IGNORE="Ignorar cambios"
    M_INFO_RESTORED="Los archivos del tema han sido restaurados correctamente."
    M_INFO_IGNORED="Los cambios detectados se han ignorado. El sistema puede estar degradado."
    M_INFO_ERROR="No se encontró el script de restauración."
else
    # Inglés
    M_TITLE="Lumina UI – Visual System Protection"
    M_TEXT="Modifications were detected in the system interface files.

This means one or more files do not match the original build version.

Possible causes:
 • Manual customization
 • Incomplete update
 • File corruption

Recommended actions:
 • Restore the files now
 • Ignore this notice if the change was intentional"

    M_RESTORE="Restore now"
    M_IGNORE="Ignore changes"
    M_INFO_RESTORED="Theme files have been successfully restored."
    M_INFO_IGNORED="Detected changes have been ignored. System may be degraded."
    M_INFO_ERROR="Recovery script not found."
fi

# Si no hay zenity, solo mostrar por terminal
if ! command -v zenity >/dev/null 2>&1; then
    echo ""
    echo "---------------------------------------------"
    echo "$M_TITLE"
    echo "---------------------------------------------"
    echo "$M_TEXT"
    exit 0
fi

# Mostrar diálogo interactivo
zenity --question \
    --title="$M_TITLE" \
    --width=400 \
    --height=250 \
    --ok-label="$M_RESTORE" \
    --cancel-label="$M_IGNORE" \
    --text="$M_TEXT"

if [ $? -eq 0 ]; then
    # Restaurar ahora
    if [ -f "$RECOVERY" ]; then
        "$RECOVERY"
        zenity --info --title="$M_TITLE" --text="$M_INFO_RESTORED"
    else
        zenity --warning --title="$M_TITLE" --text="$M_INFO_ERROR"
    fi
else
    zenity --info --title="$M_TITLE" --text="$M_INFO_IGNORED"
fi
