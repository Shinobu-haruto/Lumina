#!/bin/sh

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
THEME_DIR="$HOME/.themes/Lumina"
MANIFEST_DIR="$BASE_DIR/manifest"
TOOLS_DIR="$BASE_DIR/tools"
BUILD_FILE="$BASE_DIR/LUMINA_BUILD"
STATE_FILE="$BASE_DIR/.lumina-state"
INTEGRITY_DIR="$BASE_DIR/integrity"
LOG_FILE="$BASE_DIR/install.log"
BUILD_VERSION="2601 build 2124"

# -----------------------------
# Función de idioma simple ES/EN
# -----------------------------
LANG_CODE=$(echo "$LANG" | cut -d_ -f1)
get_text() {
    case "$LANG_CODE" in
        es)
            case "$1" in
                setup_title) echo "Instalador Lumina UI";;
                setup_message) echo "Seleccione la acción que desea realizar";;
                install) echo "Instalar Lumina";;
                verify) echo "Verificar archivos";;
                welcome) echo "Mostrar bienvenida";;
                docs) echo "Ver documentación";;
                exit) echo "Salir";;
                success) echo "¡Lumina instalado correctamente!";;
                restoring) echo "Restaurando archivos...";;
                copying) echo "Copiando archivos...";;
                integrity_fail) echo "⚠ SHA256 no coincide: ";;
            esac
            ;;
        *)
            case "$1" in
                setup_title) echo "Lumina UI Installer";;
                setup_message) echo "Select the action you want to perform";;
                install) echo "Install Lumina";;
                verify) echo "Verify files";;
                welcome) echo "Show welcome";;
                docs) echo "View documentation";;
                exit) echo "Exit";;
                success) echo "Lumina installed successfully!";;
                restoring) echo "Restoring files...";;
                copying) echo "Copying files...";;
                integrity_fail) echo "⚠ SHA256 mismatch: ";;
            esac
            ;;
    esac
}

# -----------------------------
# Limpiar versiones antiguas
# -----------------------------
rm -rf "$THEME_DIR" "$INTEGRITY_DIR"
mkdir -p "$THEME_DIR" "$INTEGRITY_DIR"
echo "Instalación iniciada: $(date)" > "$LOG_FILE"

# -----------------------------
# Menú inicial Zenity
# -----------------------------
ACTION=$(zenity --width=480 --height=320 --list \
    --title="$(get_text setup_title)" \
    --text="$(get_text setup_message)" \
    --column="Acción" \
    "$(get_text install)" \
    "$(get_text verify)" \
    "$(get_text welcome)" \
    "$(get_text docs)" \
    "$(get_text exit)" \
    --hide-header \
    --window-icon="$BASE_DIR/icons/lumina.png")

# -----------------------------
# Función de instalación
# -----------------------------
install_env() {
    ENV="$1"
    case $ENV in
        cinnamon) DEST="$THEME_DIR/cinnamon/shell";;
        gtk3) DEST="$THEME_DIR/gtk-3.0/interface";;
        gtk320) DEST="$THEME_DIR/gtk-3.20/interface";;
        gtk324) DEST="$THEME_DIR/gtk-3.24/interface";;
        gtk4) DEST="$THEME_DIR/gtk-4.0";;
        gnome-shell) DEST="$THEME_DIR/gnome-shell";;
        metacity) DEST="$THEME_DIR/metacity-1";;
        xfwm4) DEST="$THEME_DIR/xfwm4";;
        kde) DEST="$THEME_DIR/kde";;
    esac
    mkdir -p "$DEST"

    FILES=()
    # Agregar manifests
    for f in "$MANIFEST_DIR/$ENV"/*.manifest; do
        [ -f "$f" ] || continue
        FILES+=("$f")
    done
    # Agregar CSS base si existe
    if [ -d "$MANIFEST_DIR/$ENV/css" ]; then
        for f in "$MANIFEST_DIR/$ENV/css/"*; do
            [ -f "$f" ] || continue
            FILES+=("$f")
        done
    fi

    TOTAL=${#FILES[@]}
    COUNT=0

    for f in "${FILES[@]}"; do
        ((COUNT++))
        FNAME=$(basename "$f")
        if [[ "$f" == *.manifest ]]; then
            DEST_FILE="$DEST/${FNAME%.manifest}.scss"
        else
            DEST_FILE="$DEST/$FNAME"
        fi

        cp "$f" "$DEST_FILE"
        sha256sum "$DEST_FILE" > "$INTEGRITY_DIR/${DEST_FILE##*/}.sha256"

        # Verificar integridad inmediatamente
        EXPECTED=$(cut -d ' ' -f1 "$INTEGRITY_DIR/${DEST_FILE##*/}.sha256")
        CURRENT=$(sha256sum "$DEST_FILE" | cut -d ' ' -f1)
        if [ "$EXPECTED" != "$CURRENT" ]; then
            zenity --warning --text="$(get_text integrity_fail)$DEST_FILE"
            echo "$(date) $ENV: SHA256 mismatch $DEST_FILE" >> "$LOG_FILE"
        fi

        # Actualizar barra de progreso
        PERCENT=$((COUNT * 100 / TOTAL))
        echo $PERCENT | zenity --progress \
            --title="$(get_text copying)" \
            --text="$DEST_FILE" \
            --percentage=$PERCENT \
            --auto-close
        echo "$(date) Copiado: $DEST_FILE" >> "$LOG_FILE"
    done
}

# -----------------------------
# Ejecutar acción
# -----------------------------
case "$ACTION" in
    "$(get_text install)")
        for ENV in cinnamon gtk3 gtk320 gtk324 gtk4 gnome-shell metacity xfwm4 kde; do
            install_env $ENV
        done
        echo "$BUILD_VERSION" > "$BUILD_FILE"
        echo "OK" > "$STATE_FILE"
        zenity --info --width=400 --text="$(get_text success)"
        ;;

    "$(get_text verify)")
        "$TOOLS_DIR/verify.sh"
        ;;

    "$(get_text welcome)")
        "$TOOLS_DIR/welcome.sh"
        ;;

    "$(get_text docs)")
        xdg-open "https://github.com/Shinobu-haruto/Lumina/blob/main/CHANGELOG.MD"
        ;;

    "$(get_text exit)")
        exit 0
        ;;

    *)
        exit 0
        ;;
esac