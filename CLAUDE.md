# CLAUDE.md - AI Assistant Guide for corneliuscornelius

## Project Overview

**corneliuscornelius** is a dark comedy animation project that pairs casual father-child audio recordings with brutally dark stick figure animations (inspired by Metalocalypse and The Venture Bros). This repository contains SVG animation assets, helper scripts, and project templates.

**License:** UNLICENSE (Public Domain) - assets are freely reusable; audio recordings are personal content excluded from this license.

## Repository Structure

```
corneliuscornelius/
├── assets/                    # SVG animation assets
│   ├── COLOR-PALETTE.md       # Design system (hex, CSS vars, Synfig RGBA)
│   ├── characters/            # Stick figure poses (base, falling, dead)
│   ├── backgrounds/           # 1920x1080 scene backgrounds
│   └── props/                 # Weapons, effects, environment objects
├── episodes/                  # Episode content (NNN-episode-name format)
│   └── NNN-episode-name/
│       ├── audio/             # WAV/FLAC recordings
│       ├── animation/         # Synfig project files (.sif)
│       └── export/            # Final MP4 renders
├── scripts/                   # Automation shell scripts
├── templates/                 # Reusable Synfig templates
├── demo.html                  # Interactive asset browser
├── corneliuscornelius_animation_workflow.md  # Detailed toolchain guide
└── README.md                  # Main documentation
```

## Key Tools and Workflow

The project uses 100% open-source tools:

| Purpose | Tool | Usage |
|---------|------|-------|
| Audio editing | Tenacity | Noise reduction, normalize, export FLAC |
| Vector assets | Inkscape | Create/edit SVG files |
| Animation | Synfig Studio | Rig and animate stick figures |
| Video compositing | Kdenlive | Sync audio + animation, final render |

### Episode Production Pipeline

1. Record audio with voice recorder
2. Edit audio in Tenacity (export as FLAC)
3. Storyboard visual gags in NOTES.md
4. Animate scenes in Synfig using rigged stick figures
5. Composite in Kdenlive (sync audio + animation)
6. Export 1080p MP4
7. Upload to YouTube

## Helper Scripts

### Create New Episode
```bash
./scripts/new-episode.sh NNN "episode-slug"
# Example: ./scripts/new-episode.sh 001 "tower-building"
```
Creates folder structure with audio/, animation/, export/ directories and NOTES.md template.

### Render Episode
```bash
./scripts/render-episode.sh episodes/NNN-episode-name
# Example: ./scripts/render-episode.sh episodes/001-tower-building
```
Batch renders all .sif files to PNG sequences for Kdenlive compositing.

## SVG Asset Conventions

### File Naming
- Lowercase with hyphens: `stickman-base.svg`, `castle-siege.svg`
- Semantic names describing content: `stickman-falling`, `stickman-dead`
- Props named by function: `sword.svg`, `catapult.svg`, `fire.svg`

### Structure Pattern
```xml
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 WIDTH HEIGHT">
  <!-- Header comment with project, license, design notes -->
  <defs>
    <!-- Reusable styles, gradients, patterns -->
  </defs>
  <!-- Organized groups by component -->
</svg>
```

### Animation-Ready Design
- Use `<g id="...">` groups for Synfig bone rigging (e.g., `id="left-arm"`, `id="head"`)
- Include joint markers with comments for pivot points
- Nest limb segments: `<g id="left-arm"><g id="left-upper-arm">...</g><g id="left-forearm">...</g></g>`

### CSS Styling Pattern
```css
.limb { stroke: #1a1a1a; stroke-width: 8; stroke-linecap: round; fill: none; }
.joint { fill: #1a1a1a; }
.head { fill: none; stroke: #1a1a1a; stroke-width: 8; }
```

### Color Palette Reference

Reference `assets/COLOR-PALETTE.md` for all colors. Key values:

| Purpose | Hex | Synfig RGBA |
|---------|-----|-------------|
| Figure black | #1a1a1a | 0.102, 0.102, 0.102, 1 |
| Deep background | #0a0a10 | 0.039, 0.039, 0.063, 1 |
| Blood red | #5c1e1e | 0.361, 0.118, 0.118, 1 |
| Fire orange | #c03000 | 0.753, 0.188, 0, 1 |
| Torch glow | #ff6600 | 1, 0.4, 0, 1 |

**Design principles:**
- High contrast: Black figures on dark backgrounds
- Limited palette: Mostly grayscale with red/orange accents
- Glow-based lighting, not white highlights

## Shell Script Conventions

### Error Handling
```bash
#!/bin/bash
set -e                          # Exit on error
if [ -z "$1" ]; then           # Parameter validation
  echo "Usage: script.sh <arg>"
  exit 1
fi
```

### Output Style
```bash
echo "Creating episode: $EPISODE_DIR"
echo "Done."
```

## Common AI Assistant Tasks

### Adding New Assets
1. Follow naming conventions (lowercase-hyphenated.svg)
2. Use color palette from `assets/COLOR-PALETTE.md`
3. Structure SVG with labeled groups for animation rigging
4. Include header comment with project name and license
5. Add to appropriate subdirectory (characters/, backgrounds/, props/)

### Creating Episode Structure
Use the helper script rather than creating manually:
```bash
./scripts/new-episode.sh NNN "episode-name"
```

### Modifying Scripts
- Include shebang: `#!/bin/bash`
- Use `set -e` for error handling
- Validate required parameters
- Provide clear usage messages on error

### Updating Documentation
- README.md: Main project documentation and asset inventory
- COLOR-PALETTE.md: Design system reference (keep hex, CSS vars, and Synfig values in sync)
- corneliuscornelius_animation_workflow.md: Detailed toolchain and process guide

## Files to Avoid Committing

Per `.gitignore`:
- Raw audio files (*.wav) - too large, use FLAC
- Video renders (*.mp4, *.mov, *.avi, *.mkv)
- Synfig backup files (*.sif~, *.sifz~)
- IDE configs (.vscode/, .idea/)
- Temporary files (*.tmp, *.temp, *.swp)
- macOS system files (.DS_Store)

## Testing Assets

Open `demo.html` in a browser to preview all SVG assets with CSS animations demonstrating:
- Siege scene with falling stickman and flying boulder
- Throne room with flickering torches
- Aftermath scene with floating tombstone

## Important Notes

- All backgrounds are 1920x1080 (16:9 HD)
- Stick figures use consistent 8px stroke width
- Joint circles are 6px radius for pivot points
- Props should be sized relative to characters (~200px stickman height)
- Fire effects use 3 layers: outer dark-red, middle orange, inner yellow with sparks
