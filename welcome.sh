#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_FILE="$BASE_DIR/LUMINA_BUILD"
STATE_FILE="$BASE_DIR/.lumina-state"
LANG_CODE=$(echo "$LANG" | cut -d_ -f1)

# -------------------------
# Función de idioma
# -------------------------
get_text() {
    case "$LANG_CODE" in
        es)
            case "$1" in
                welcome_title) echo "¡Bienvenido a Lumina!";;
                system_ok) echo "Tu sistema está listo para Lumina";;
                system_degraded) echo "Algunos archivos han sido modificados, pero puedes continuar";;
                restore_prompt) echo "Restaurar archivos";;
                start_prompt) echo "Iniciar Lumina";;
                changelog_prompt) echo "Ver changelog";;
                restoring) echo "Restaurando archivos...";;
                restored) echo "Archivos restaurados correctamente.";;
            esac
            ;;
        *)
            case "$1" in
                welcome_title) echo "Welcome to Lumina!";;
                system_ok) echo "Your system is ready for Lumina";;
                system_degraded) echo "Some files were modified, but you can continue";;
                restore_prompt) echo "Restore files";;
                start_prompt) echo "Start Lumina";;
                changelog_prompt) echo "View changelog";;
                restoring) echo "Restoring files...";;
                restored) echo "Files restored successfully.";;
            esac
            ;;
    esac
}

# -------------------------
# Leer build
# -------------------------
BUILD_INFO=$( [ -f "$BUILD_FILE" ] && cat "$BUILD_FILE" || echo "Build unknown" )

# -------------------------
# Leer estado del sistema
# -------------------------
SYSTEM_STATE=$( [ -f "$STATE_FILE" ] && cat "$STATE_FILE" || echo "UNKNOWN" )

# -------------------------
# Mensaje base
# -------------------------
MESSAGE="Lumina UI\nVersión: $BUILD_INFO\n\nLumina es un entorno ligero y personalizable.\nGracias por formar parte del proceso."

# -------------------------
# Función de restauración silenciosa
# -------------------------
restore_files() {
    "$BASE_DIR/tools/recovery.sh" > /dev/null 2>&1
    echo "OK" > "$STATE_FILE"
}

# -------------------------
# Ventana principal con bienvenida cálida
# -------------------------
if [ "$SYSTEM_STATE" = "DEGRADED" ]; then
    MESSAGE="$MESSAGE\n\n$(get_text system_degraded)"
fi

ACTION=$(zenity --width=480 --height=320 --list \
    --title="$(get_text welcome_title)" \
    --text="$MESSAGE" \
    --column="Acción" \
    "$(get_text start_prompt)" \
    "$(get_text restore_prompt)" \
    "$(get_text changelog_prompt)" \
    --hide-header \
    --window-icon="$BASE_DIR/icons/lumina.png")

case "$ACTION" in
    "$(get_text start_prompt)")
        echo "Iniciando Lumina..."
        # Aquí va tu comando real para iniciar Lumina
        ;;
    "$(get_text restore_prompt)")
        restore_files
        zenity --info --text="$(get_text restored)"
        ;;
    "$(get_text changelog_prompt)")
        xdg-open "https://github.com/Shinobu-haruto/Lumina/blob/main/CHANGELOG.MD"
        ;;
    *)
        ;;
esac
