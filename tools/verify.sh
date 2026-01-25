#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
THEME_DIR="$HOME/.themes/Lumina"
MANIFEST_DIR="$BASE_DIR/manifest"
BUILD_FILE="$BASE_DIR/LUMINA_BUILD"
STATE_FILE="$BASE_DIR/.lumina-state"
INTEGRITY_DIR="$BASE_DIR/integrity"

SYSTEM_OK=true
INTEGRITY_WARNING=false

# Detectar idioma
USER_LANG="${LANG%%.*}"  # Ej: "es_MX", "en_US"

# Mensajes según idioma
case "$USER_LANG" in
  es* )
    MSG_VERIFY_MODE="Lumina UI – Modo Verificación"
    MSG_BUILD_INFO="Información de la build:"
    MSG_BUILD_NOT_FOUND="⚠ LUMINA_BUILD no encontrado"
    MSG_VERIFY="→ Verificando"
    MSG_MANIFEST_NOT_FOUND="⚠ No existe manifest para"
    MSG_DEST_NOT_FOUND="✖ Directorio del entorno no existe"
    MSG_OK="✔ OK"
    MSG_MISSING="✖ FALTA"
    MSG_MODIFIED="⚠ MODIFICADO"
    MSG_SYSTEM_OK="Estado del sistema: OK"
    MSG_SYSTEM_DEGRADED="Estado del sistema: DEGRADED"
    MSG_COMPLETED="Verificación completada"
    ;;
  en* )
    MSG_VERIFY_MODE="Lumina UI – Verify Mode"
    MSG_BUILD_INFO="Build information:"
    MSG_BUILD_NOT_FOUND="⚠ LUMINA_BUILD not found"
    MSG_VERIFY="→ Verifying"
    MSG_MANIFEST_NOT_FOUND="⚠ Manifest not found for"
    MSG_DEST_NOT_FOUND="✖ Destination directory does not exist"
    MSG_OK="✔ OK"
    MSG_MISSING="✖ MISSING"
    MSG_MODIFIED="⚠ MODIFIED"
    MSG_SYSTEM_OK="System Status: OK"
    MSG_SYSTEM_DEGRADED="System Status: DEGRADED"
    MSG_COMPLETED="Verification completed"
    ;;
  * )
    # Default a inglés
    MSG_VERIFY_MODE="Lumina UI – Verify Mode"
    MSG_BUILD_INFO="Build information:"
    MSG_BUILD_NOT_FOUND="⚠ LUMINA_BUILD not found"
    MSG_VERIFY="→ Verifying"
    MSG_MANIFEST_NOT_FOUND="⚠ Manifest not found for"
    MSG_DEST_NOT_FOUND="✖ Destination directory does not exist"
    MSG_OK="✔ OK"
    MSG_MISSING="✖ MISSING"
    MSG_MODIFIED="⚠ MODIFIED"
    MSG_SYSTEM_OK="System Status: OK"
    MSG_SYSTEM_DEGRADED="System Status: DEGRADED"
    MSG_COMPLETED="Verification completed"
    ;;
esac

echo "========================================="
echo " $MSG_VERIFY_MODE"
echo "========================================="

# Mostrar información de la build
if [ -f "$BUILD_FILE" ]; then
    echo ""
    echo "$MSG_BUILD_INFO"
    echo "-----------------------------------------"
    cat "$BUILD_FILE"
else
    echo ""
    echo "$MSG_BUILD_NOT_FOUND"
fi

sleep 1

# Función para verificar cada grupo de archivos
verify_group() {
    MANI_PATH="$1"
    DEST_PATH="$2"
    LABEL="$3"

    echo ""
    echo "$MSG_VERIFY $LABEL"
    echo "-----------------------------------------"

    if [ ! -d "$MANI_PATH" ]; then
        echo "$MSG_MANIFEST_NOT_FOUND $LABEL"
        return
    fi

    if [ ! -d "$DEST_PATH" ]; then
        echo "$MSG_DEST_NOT_FOUND"
        SYSTEM_OK=false
        return
    fi

    for f in "$MANI_PATH"/*.manifest; do
        [ -f "$f" ] || continue

        name="$(basename "$f" .manifest)"
        target="$DEST_PATH/$name.scss"
        hash_file="$INTEGRITY_DIR/$name.sha256"

        if [ -f "$target" ]; then
            echo "$MSG_OK: $name.scss"
        else
            echo "$MSG_MISSING: $name.scss"
            SYSTEM_OK=false
            continue
        fi

        # Verificación SHA256
        if [ -f "$hash_file" ]; then
            expected="$(cut -d ' ' -f1 "$hash_file")"
            current="$(sha256sum "$target" | cut -d ' ' -f1)"
            if [ "$expected" != "$current" ]; then
                echo "$MSG_MODIFIED: $name.scss"
                INTEGRITY_WARNING=true
            fi
        fi
    done
}

# Verificar todos los entornos
verify_group "$MANIFEST_DIR/cinnamon" "$THEME_DIR/cinnamon/shell" "Cinnamon"
verify_group "$MANIFEST_DIR/gtk3" "$THEME_DIR/gtk-3.0/interface" "GTK 3.0"
verify_group "$MANIFEST_DIR/gtk4" "$THEME_DIR/gtk-4.0/interface" "GTK 4.0"
echo ""
echo "-----------------------------------------"

# Mostrar ventana interactiva si hay cambios
if [ "$INTEGRITY_WARNING" = true ]; then
    "$BASE_DIR/tools/integrity_notice.sh"
fi

# Estado final
if [ "$SYSTEM_OK" = true ]; then
    echo "$MSG_SYSTEM_OK"
    echo "OK" > "$STATE_FILE"
else
    echo "$MSG_SYSTEM_DEGRADED"
    echo "DEGRADED" > "$STATE_FILE"
fi

echo "-----------------------------------------"
echo ""
echo "========================================="
echo " $MSG_COMPLETED"
echo "========================================="
