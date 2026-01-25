#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detectar ubicación del tema
if [ -d "$HOME/.local/share/themes/Lumina" ]; then
    THEME_DIR="$HOME/.local/share/themes/Lumina"
elif [ -d "$HOME/.themes/Lumina" ]; then
    THEME_DIR="$HOME/.themes/Lumina"
else
    echo "✖ No se encontró la carpeta del tema Lumina"
    exit 1
fi

# Detectar idioma
USER_LANG="${LANG%%.*}"

# Mensajes según idioma
case "$USER_LANG" in
  es* )
    MSG_TITLE="Lumina UI – Modo Reset"
    MSG_CLEANING="→ Limpiando"
    MSG_REMOVED="✖ Eliminado"
    MSG_COMPLETED="Reset completado. El tema volvió a estado base"
    MSG_NOT_FOUND="✖ No se encontró la carpeta del tema Lumina"
    ;;
  en* )
    MSG_TITLE="Lumina UI – Reset Mode"
    MSG_CLEANING="→ Cleaning"
    MSG_REMOVED="✖ Removed"
    MSG_COMPLETED="Reset completed. Theme returned to base state"
    MSG_NOT_FOUND="✖ Lumina theme folder not found"
    ;;
  * )
    MSG_TITLE="Lumina UI – Reset Mode"
    MSG_CLEANING="→ Cleaning"
    MSG_REMOVED="✖ Removed"
    MSG_COMPLETED="Reset completed. Theme returned to base state"
    MSG_NOT_FOUND="✖ Lumina theme folder not found"
    ;;
esac

echo "========================================="
echo " $MSG_TITLE"
echo "========================================="
sleep 1

reset_group() {
    MANI_PATH="$1"
    DEST_PATH="$2"

    [ -d "$MANI_PATH" ] || return

    echo "$MSG_CLEANING $(basename "$DEST_PATH")"

    for f in "$MANI_PATH"/*.manifest; do
        [ -f "$f" ] || continue
        name="$(basename "$f" .manifest)"
        target="$DEST_PATH/$name.scss"

        if [ -f "$target" ]; then
            rm "$target"
            echo "$MSG_REMOVED $name.scss"
        fi
    done
}

# Reset de todos los grupos
reset_group "$BASE_DIR/manifest/cinnamon" "$THEME_DIR/cinnamon/shell"
reset_group "$BASE_DIR/manifest/gtk3" "$THEME_DIR/gtk-3.0/interface"
reset_group "$BASE_DIR/manifest/gtk320" "$THEME_DIR/gtk-3.20/interface"
reset_group "$BASE_DIR/manifest/gtk324" "$THEME_DIR/gtk-3.24/interface"
reset_group "$BASE_DIR/manifest/gtk4" "$THEME_DIR/gtk-4.0/interface"
reset_group "$BASE_DIR/manifest/gnome-shell" "$THEME_DIR/gnome-shell"
reset_group "$BASE_DIR/manifest/metacity" "$THEME_DIR/metacity-1"
reset_group "$BASE_DIR/manifest/xfwm4" "$THEME_DIR/xfwm4"
reset_group "$BASE_DIR/manifest/kde" "$THEME_DIR/kde"

echo ""
echo "========================================="
echo " $MSG_COMPLETED"
echo "========================================="
