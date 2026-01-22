# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **media production project**, not a traditional software project. It produces dark comedy stick-figure animations paired with wholesome family audio recordings for YouTube (@corneliuscornelius).

The aesthetic draws from Metalocalypse and The Venture Bros.—castle sieges, cartoon violence, and absurdist dark humor contrasted against mundane father-child conversations.

## Commands

### Create a new episode
```bash
./scripts/new-episode.sh <number> <slug>
# Example: ./scripts/new-episode.sh 001 "tower-building"
```

### Batch render Synfig animations
```bash
./scripts/render-episode.sh episodes/<episode-dir>
# Example: ./scripts/render-episode.sh episodes/001-tower-building
```
Renders all `.sif` files to 1920x1080 PNG sequences in `export/frames/`.

### Preview assets
```bash
open demo.html
# or: python3 -m http.server 8000
```

## Toolchain (All Open Source)

| Tool | Purpose | Install (macOS) |
|------|---------|-----------------|
| Synfig Studio | Vector animation, bone rigging | `brew install --cask synfigstudio` |
| Kdenlive | Video compositing, audio sync | `brew install --cask kdenlive` |
| Tenacity | Audio editing (Audacity fork) | `brew install --cask tenacityaudio` |
| Inkscape | SVG asset creation | `brew install --cask inkscape` |
| FFmpeg | Audio/video conversion | `brew install ffmpeg` |

## Architecture

### Asset Library (`assets/`)
All assets are SVG files designed for Synfig animation:
- **characters/**: Stick figures with semantic grouping for bone rigging (left-arm, right-leg, head joints)
- **backgrounds/**: 1920x1080 scene backdrops
- **props/**: Weapons, effects, decorations
- **COLOR-PALETTE.md**: Hex codes, CSS variables, and Synfig RGBA values

### Episode Structure (`episodes/NNN-name/`)
```
audio/      # WAV (raw) + FLAC (edited, committed)
animation/  # Synfig .sif project files
export/     # Final MP4 renders + PNG sequences
NOTES.md    # Storyboard checklist
```

### Demo (`demo.html`)
Self-contained HTML/CSS/JS preview page with CSS animations demonstrating character interactions. No external dependencies.

## Design System

Color palette follows dark comedy aesthetic:
- Backgrounds: Void blacks and deep purples (#050508-#12121a)
- Characters: Stick black (#1a1a1a)
- Accents: Blood red (#3d1515, #5c1e1e) for danger/glow
- Fire: Orange/yellow gradient (#c03000-#ffcc00) for action

Principles:
1. High contrast—black figures on dark (not black) backgrounds
2. Limited palette—grayscale with red/orange accents only
3. Glow, don't highlight—colored glows for light sources
4. Blood red = danger, Fire orange/yellow = action

## Production Workflow

1. Record audio (Sony voice recorder → WAV)
2. Edit audio (Tenacity → FLAC)
3. Storyboard dark visual gags in NOTES.md
4. Animate in Synfig using rigged stick figures
5. Batch render with `render-episode.sh`
6. Composite audio + animation in Kdenlive
7. Export 1080p MP4 (H.264)

## File Conventions

- Raw WAV files: excluded via .gitignore
- Edited audio: commit as FLAC
- Renders (MP4/MOV/AVI): excluded via .gitignore
- Synfig backups (~): excluded via .gitignore

## License

Animation assets and scripts are UNLICENSE (public domain). Audio recordings with identifiable voices are personal content and excluded from this license.
