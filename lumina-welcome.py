#!/usr/bin/env python3
import gi
import os
from pathlib import Path

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

# -----------------------------
# Configuración Lumina
# -----------------------------
APP_NAME = "Lumina"
VERSION = "0.1"

CONFIG_DIR = Path.home() / ".config" / "lumina"
FIRST_RUN_FILE = CONFIG_DIR / "first-run"

# -----------------------------
# Comprobación first run
# -----------------------------
if FIRST_RUN_FILE.exists():
    raise SystemExit  # No mostrar de nuevo

CONFIG_DIR.mkdir(parents=True, exist_ok=True)

# -----------------------------
# Ventana
# -----------------------------
class LuminaWelcome(Gtk.Window):
    def __init__(self):
        super().__init__(title=f"Bienvenido a {APP_NAME}")
        self.set_default_size(440, 260)
        self.set_border_width(20)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_resizable(False)

        main = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.add(main)

        title = Gtk.Label()
        title.set_markup(
            "<span size='20000' weight='bold'>Lumina</span>"
        )
        main.pack_start(title, False, False, 0)

        subtitle = Gtk.Label(
            label=f"Interfaz ligera y personalizable • v{VERSION}"
        )
        main.pack_start(subtitle, False, False, 0)

        text = Gtk.Label(
            label=(
                "Lumina es un entorno visual en evolución,\n"
                "diseñado para ser claro, rápido y flexible.\n\n"
                "Gracias por formar parte del proceso."
            )
        )
        text.set_justify(Gtk.Justification.CENTER)
        main.pack_start(text, True, True, 10)

        actions = Gtk.Box(spacing=8)
        main.pack_end(actions, False, False, 0)

        start_btn = Gtk.Button(label="Iniciar Lumina")
        start_btn.connect("clicked", self.on_start)
        actions.pack_end(start_btn, False, False, 0)

    def on_start(self, widget):
        FIRST_RUN_FILE.touch()
        self.close()

# -----------------------------
# Ejecución
# -----------------------------
win = LuminaWelcome()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()