#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
THEME_DIR="$HOME/.themes/Lumina"
MANIFEST_DIR="$BASE_DIR/manifest"
BUILD_FILE="$BASE_DIR/LUMINA_BUILD"
STATE_FILE="$BASE_DIR/.lumina-state"
INTEGRITY_DIR="$BASE_DIR/integrity"

SYSTEM_OK=true
INTEGRITY_WARNING=false

echo "========================================="
echo " Lumina UI – Verify Mode"
echo "========================================="

# Mostrar información de la build
if [ -f "$BUILD_FILE" ]; then
    echo ""
    echo "Build information:"
    echo "-----------------------------------------"
    cat "$BUILD_FILE"
else
    echo ""
    echo "⚠ LUMINA_BUILD no encontrado"
fi

sleep 1

# Función para verificar cada grupo de archivos
verify_group() {
    MANI_PATH="$1"
    DEST_PATH="$2"
    LABEL="$3"

    echo ""
    echo "→ Verificando $LABEL"
    echo "-----------------------------------------"

    if [ ! -d "$MANI_PATH" ]; then
        echo "⚠ No existe manifest para $LABEL"
        return
    fi

    if [ ! -d "$DEST_PATH" ]; then
        echo "✖ Directorio del entorno no existe"
        SYSTEM_OK=false
        return
    fi

    for f in "$MANI_PATH"/*.manifest; do
        [ -f "$f" ] || continue

        name="$(basename "$f" .manifest)"
        target="$DEST_PATH/$name.scss"
        hash_file="$INTEGRITY_DIR/$name.sha256"

        if [ -f "$target" ]; then
            echo "✔ OK: $name.scss"
        else
            echo "✖ FALTA: $name.scss"
            SYSTEM_OK=false
            continue
        fi

        # Verificación SHA256
        if [ -f "$hash_file" ]; then
            expected="$(cut -d ' ' -f1 "$hash_file")"
            current="$(sha256sum "$target" | cut -d ' ' -f1)"
            if [ "$expected" != "$current" ]; then
                echo "⚠ MODIFICADO: $name.scss"
                INTEGRITY_WARNING=true
            fi
        fi
    done
}

# Verificar todos los entornos
verify_group "$MANIFEST_DIR/cinnamon" "$THEME_DIR/cinnamon/shell" "Cinnamon"
verify_group "$MANIFEST_DIR/gtk3" "$THEME_DIR/gtk-3.0/interface" "GTK 3.0"
verify_group "$MANIFEST_DIR/gtk320" "$THEME_DIR/gtk-3.20/interface" "GTK 3.20"
verify_group "$MANIFEST_DIR/gtk324" "$THEME_DIR/gtk-3.24/interface" "GTK 3.24"
verify_group "$MANIFEST_DIR/gtk4" "$THEME_DIR/gtk-4.0" "GTK 4.0"
verify_group "$MANIFEST_DIR/gnome-shell" "$THEME_DIR/gnome-shell" "GNOME Shell"
verify_group "$MANIFEST_DIR/metacity" "$THEME_DIR/metacity-1" "Metacity"
verify_group "$MANIFEST_DIR/xfwm4" "$THEME_DIR/xfwm4" "XFWM4"
verify_group "$MANIFEST_DIR/kde" "$THEME_DIR/kde" "KDE"

echo ""
echo "-----------------------------------------"

# Mostrar ventana interactiva si hay cambios
if [ "$INTEGRITY_WARNING" = true ]; then
    "$BASE_DIR/tools/integrity_notice.sh"
fi

# Estado final
if [ "$SYSTEM_OK" = true ]; then
    echo "Estado del sistema: OK"
    echo "OK" > "$STATE_FILE"
else
    echo "Estado del sistema: DEGRADED"
    echo "DEGRADED" > "$STATE_FILE"
fi

echo "-----------------------------------------"
echo ""
echo "========================================="
echo " Verificación completada"
echo "========================================="

