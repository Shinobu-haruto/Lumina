## Build 2501 - 2026-01-21
  -  Added support for older GTK versions.
  - Added support for XFCE.

    feat: add GTK legacy & XFCE support; spinner still experimental
=======================================================================
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
