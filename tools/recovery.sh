#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
THEME_DIR="$HOME/.local/share/themes/Lumina"
MANIFEST_DIR="$BASE_DIR/manifest"

echo ""
echo "→ Verificando restos de versiones anteriores"
"$BASE_DIR/tools/cleanup.sh" --dry-run


echo "========================================="
echo " Lumina UI – Recovery Mode"
echo "========================================="
sleep 1

restore_file() {
    SRC="$1"
    DST="$2"

    if [ -f "$SRC" ]; then
        cp "$SRC" "$DST"
        echo "✔ $(basename "$DST")"
    else
        echo "✖ Falta manifest: $(basename "$SRC")"
    fi
}

restore_group() {
    MANI_PATH="$1"
    DEST_PATH="$2"

    mkdir -p "$DEST_PATH"

    for f in "$MANI_PATH"/*.manifest; do
        [ -f "$f" ] || continue
        name="$(basename "$f" .manifest)"
        restore_file "$f" "$DEST_PATH/$name.scss"
    done
}

echo ""
echo "→ Cinnamon"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/cinnamon" \
              "$THEME_DIR/cinnamon/shell"

echo ""
echo "→ GTK 3.0"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/gtk3" \
              "$THEME_DIR/gtk-3.0/interface"

echo ""
echo "→ GTK 3.20"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/gtk320" \
              "$THEME_DIR/gtk-3.20/interface"

echo ""
echo "→ GTK 3.24"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/gtk324" \
              "$THEME_DIR/gtk-3.24/interface"

echo ""
echo "→ GTK 4.0"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/gtk4" \
              "$THEME_DIR/gtk-4.0"

echo ""
echo "→ GNOME Shell"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/gnome-shell" \
              "$THEME_DIR/gnome-shell"

echo ""
echo "→ Metacity"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/metacity" \
              "$THEME_DIR/metacity-1"

echo ""
echo "→ XFWM4"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/xfwm4" \
              "$THEME_DIR/xfwm4"

echo ""
echo "→ KDE"
echo "-----------------------------------------"
restore_group "$MANIFEST_DIR/kde" \
              "$THEME_DIR/kde"

echo ""
echo "========================================="
echo " Recovery completado correctamente"
echo " Reinicia el entorno gráfico si es necesario"
echo "========================================="

