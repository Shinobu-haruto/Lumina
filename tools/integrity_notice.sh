#!/bin/sh

# Ruta base del tema
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Si no hay zenity, mostramos aviso por consola
if ! command -v zenity >/dev/null 2>&1; then
    echo ""
    echo "---------------------------------------------"
    echo " Lumina UI – Protección del sistema visual"
    echo "---------------------------------------------"
    echo "Se detectaron modificaciones en archivos de la interfaz del sistema."
    echo "Ejecute tools/recovery.sh para restaurar si desea revertir los cambios."
    echo "---------------------------------------------"
    exit 0
fi

# Ventana interactiva estilo XP
ACTION=$(zenity --question \
    --title="Lumina UI – Protección del sistema visual" \
    --width=400 \
    --height=250 \
    --ok-label="Restaurar ahora" \
    --cancel-label="Ignorar cambios" \
    --text="Se detectaron modificaciones en archivos de la interfaz del sistema.\n\n\
Esto significa que uno o más archivos no coinciden con la versión original de esta build.\n\n\
Posibles causas:\n • Personalización manual\n • Actualización incompleta\n • Corrupción de archivos\n\n\
Acciones recomendadas:\n • Restaurar los archivos ahora\n • Ignorar este aviso si el cambio fue intencional")

# Comprobar elección del usuario
if [ $? -eq 0 ]; then
    # OK (Restaurar ahora)
    "$BASE_DIR/tools/recovery.sh"
    zenity --info \
        --title="Lumina UI – Restauración completada" \
        --text="Los archivos del tema han sido restaurados correctamente."
else
    # Cancel (Ignorar cambios)
    zenity --info \
        --title="Lumina UI – Aviso ignorado" \
        --text="Los cambios detectados se han ignorado. El sistema puede estar degradado."
fi

