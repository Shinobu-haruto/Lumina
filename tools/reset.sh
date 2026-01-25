#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
THEME_DIR="$HOME/.local/share/themes/Lumina"
MANIFEST_DIR="$BASE_DIR/manifest"

echo "========================================="
echo " Lumina UI – Reset Mode"
echo "========================================="
sleep 1

reset_group() {
    MANI_PATH="$1"
    DEST_PATH="$2"

    if [ ! -d "$MANI_PATH" ]; then
        return
    fi

    echo "→ Limpiando $(basename "$DEST_PATH")"

    for f in "$MANI_PATH"/*.manifest; do
        [ -f "$f" ] || continue
        name="$(basename "$f" .manifest)"
        target="$DEST_PATH/$name.scss"

        if [ -f "$target" ]; then
            rm "$target"
            echo "✖ Eliminado $name.scss"
        fi
    done
}

echo ""
reset_group "$MANIFEST_DIR/cinnamon" \
            "$THEME_DIR/cinnamon/shell"

reset_group "$MANIFEST_DIR/gtk3" \
            "$THEME_DIR/gtk-3.0/interface"

reset_group "$MANIFEST_DIR/gtk320" \
            "$THEME_DIR/gtk-3.20/interface"

reset_group "$MANIFEST_DIR/gtk324" \
            "$THEME_DIR/gtk-3.24/interface"

reset_group "$MANIFEST_DIR/gtk4" \
            "$THEME_DIR/gtk-4.0/interface"

reset_group "$MANIFEST_DIR/gnome-shell" \
            "$THEME_DIR/gnome-shell"

reset_group "$MANIFEST_DIR/metacity" \
            "$THEME_DIR/metacity-1"

reset_group "$MANIFEST_DIR/xfwm4" \
            "$THEME_DIR/xfwm4"

reset_group "$MANIFEST_DIR/kde" \
            "$THEME_DIR/kde"

echo ""
echo "========================================="
echo " Reset completado"
echo " El tema volvió a estado base"
echo "========================================="

