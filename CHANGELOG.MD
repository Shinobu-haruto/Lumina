## Release 2601 – Build 2124

## 🇪🇸 Español

Esta build introduce mejoras estructurales y herramientas internas para mantenimiento del proyecto.
Cambios principales:
 - Se añadieron scripts de mantenimiento (recovery.sh, reset.sh, verify.sh) organizados dentro del directorio tools/.
 - El sistema de recovery fue actualizado para soportar más entornos de escritorio.
 - Se incorporó verificación básica del entorno antes de aplicar cambios.
 - Se añadió limpieza automática de versiones antiguas.
 - Mejoras internas en organización y estabilidad del proyecto.

English 🇬🇧

This build introduces structural improvements and internal maintenance tools.
Main changes:

 - Added maintenance scripts (recovery.sh, reset.sh, verify.sh) organized inside the tools/ directory.
 - Updated the recovery system to support additional desktop environments.
 - Added basic environment verification before applying changes.
 - Implemented automatic cleanup of old versions.

Internal improvements to project organization and stability.


## Build 2501 - 2026-01-21
  -  Added support for older GTK versions.
  - Added support for XFCE.

    feat: add GTK legacy & XFCE support; spinner still experimental


## Build 2406 — 2026-01-15

### Added
- Core visual tokens for surface, outline and elevation
- Spinner and progressbar animations (GTK 3)
- Levelbar support (horizontal and vertical)

### Changed
- Headerbar behavior unified across GTK 3 apps
- Button motion tuned for reduced visual fatigue
- TextView and SourceView contrast rebalanced

### Fixed
- Transparent popovers in GTK 3
- Missing progress state rendering in AWF
- Headerbar transparency in dark mode

### Known issues
- Spinner animation may not play in some GTK 3 inspectors
- Cinnamon apps may require gtk-dark.css override
