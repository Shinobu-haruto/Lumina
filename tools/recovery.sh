#!/bin/sh

# ==========================
# Configuración de rutas
# ==========================
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Detectar directorio de temas según entorno
if [ -d "$HOME/.local/share/themes/Lumina" ]; then
    THEME_DIR="$HOME/.local/share/themes/Lumina"
else
    THEME_DIR="$HOME/.themes/Lumina"
fi

MANIFEST_DIR="$BASE_DIR/manifest"

# Detectar idioma
USER_LANG="${LANG%%.*}"

# ==========================
# Mensajes por idioma
# ==========================
if [ "${USER_LANG#es}" != "$USER_LANG" ]; then
    # Español
    MSG_VERIFY="→ Verificando restos de versiones anteriores"
    MSG_RECOVERY="Lumina UI – Modo Recovery"
    MSG_GROUP_SEPARATOR="-----------------------------------------"
    MSG_COMPLETE="Recovery completado correctamente\nReinicia el entorno gráfico si es necesario"
    MSG_FILE_OK="✔"
    MSG_FILE_MISSING="✖ Falta manifest"

    GROUPS="Cinnamon:Cinnamon
GTK3:GTK 3.0
GTK320:GTK 3.20
GTK324:GTK 3.24
GTK4:GTK 4.0
GNOME:GNOME Shell
Metacity:Metacity
XFWM4:XFWM4
KDE:KDE"
else
    # Inglés
    MSG_VERIFY="→ Checking leftovers from previous versions"
    MSG_RECOVERY="Lumina UI – Recovery Mode"
    MSG_GROUP_SEPARATOR="-----------------------------------------"
    MSG_COMPLETE="Recovery completed successfully\nRestart the graphical session if needed"
    MSG_FILE_OK="✔"
    MSG_FILE_MISSING="✖ Missing manifest"

    GROUPS="Cinnamon:Cinnamon
GTK3:GTK 3.0
GTK320:GTK 3.20
GTK324:GTK 3.24
GTK4:GTK 4.0
GNOME:GNOME Shell
Metacity:Metacity
XFWM4:XFWM4
KDE:KDE"
fi

# ==========================
# Inicio del recovery
# ==========================
echo ""
echo "$MSG_VERIFY"
"$BASE_DIR/tools/cleanup.sh" --dry-run

echo ""
echo "========================================="
echo " $MSG_RECOVERY"
echo "========================================="
sleep 1

# ==========================
# Funciones de restauración
# ==========================
restore_file() {
    SRC="$1"
    DST="$2"

    if [ -f "$SRC" ]; then
        cp "$SRC" "$DST"
        echo "$MSG_FILE_OK $(basename "$DST")"
    else
        echo "$MSG_FILE_MISSING: $(basename "$SRC")"
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

# ==========================
# Restaurar todos los grupos
# ==========================
echo ""
while IFS=: read -r DIR_NAME LABEL; do
    echo "→ $LABEL"
    echo "$MSG_GROUP_SEPARATOR"
    restore_group "$MANIFEST_DIR/$DIR_NAME" "$THEME_DIR/$DIR_NAME"
    echo ""
done <<EOF
$GROUPS
EOF

# ==========================
# Fin del recovery
# ==========================
echo "========================================="
echo "$MSG_COMPLETE"
echo "========================================="
