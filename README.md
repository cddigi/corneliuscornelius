# corneliuscornelius

Dark comedy stick figure animations over wholesome family audio.

## Concept

Casual father-child audio recordings paired with brutally dark Metalocalypse/Venture Bros.-style stick figure animations. Castle sieges, accidental cartoon violence, and absurdist dark humor—contrasted against mundane conversations about building blocks and naptime.

## Demo

Open `demo.html` in your browser to see the assets in action:

```bash
cd corneliuscornelius
open demo.html
# or
python3 -m http.server 8000  # then visit http://localhost:8000/demo.html
```

## Assets Included

### Characters
| Asset | Description |
|-------|-------------|
| `stickman-base.svg` | Standing pose with labeled joints for rigging |
| `stickman-falling.svg` | Flailing panic pose |
| `stickman-dead.svg` | X-eyes, lying flat |

### Backgrounds (1920x1080)
| Asset | Description |
|-------|-------------|
| `castle-siege.svg` | Blood-red sky, fortress silhouette |
| `castle-interior.svg` | Dark throne room with torches |
| `night-sky-simple.svg` | Minimal stars for dialogue scenes |

### Props
| Asset | Description |
|-------|-------------|
| `catapult.svg` | Siege weapon with animatable arm |
| `sword.svg` | Medieval sword |
| `shield.svg` | Heater shield with rivets |
| `boulder.svg` | Catapult ammo |
| `arrow.svg` | Flying projectile |
| `fire.svg` | Layered flames with sparks |
| `debris-pile.svg` | Rubble from destruction |
| `crown.svg` | For doomed kings |
| `tombstone.svg` | RIP |

### Reference
| File | Description |
|------|-------------|
| `COLOR-PALETTE.md` | Hex codes, CSS variables, Synfig values |

## Tools (100% Open Source)

| Purpose | Tool | License |
|---------|------|---------|
| Audio editing | [Tenacity](https://tenacityaudio.org/) | GPL-2.0+ |
| Animation | [Synfig Studio](https://www.synfig.org/) | GPL-3.0 |
| Vector assets | [Inkscape](https://inkscape.org/) | GPL-2.0+ |
| Video compositing | [Kdenlive](https://kdenlive.org/) | GPL-2.0+ |

### macOS Install

```bash
brew install --cask synfigstudio kdenlive inkscape audacity
```

## Project Structure

```
corneliuscornelius/
├── demo.html               # Interactive asset preview
├── assets/
│   ├── COLOR-PALETTE.md    # Color reference
│   ├── characters/         # Stick figure SVGs
│   ├── backgrounds/        # Scene backgrounds (1920x1080)
│   └── props/              # Weapons, debris, fire, etc.
├── episodes/
│   └── NNN-episode-name/
│       ├── audio/          # WAV (raw) and FLAC (edited)
│       ├── animation/      # Synfig project files (.sif)
│       └── export/         # Final MP4 renders
├── scripts/
│   ├── new-episode.sh      # Scaffold new episode folders
│   └── render-episode.sh   # Batch render Synfig files
└── templates/              # Reusable Synfig templates
```

## Scripts

### Create a new episode

```bash
./scripts/new-episode.sh 001 "tower-building"
```

Creates folder structure with `NOTES.md` for storyboarding.

### Batch render Synfig files

```bash
./scripts/render-episode.sh episodes/001-tower-building
```

Renders all `.sif` files to PNG sequences for Kdenlive import.

## Episode Workflow

1. **Record** - Capture audio with Sony voice recorder
2. **Edit audio** - Clean up in Tenacity, export FLAC
3. **Storyboard** - Sketch dark visual gags that contrast with audio
4. **Animate** - Build scenes in Synfig using rigged stick figures
5. **Composite** - Sync audio + animation in Kdenlive
6. **Export** - Render 1080p MP4
7. **Upload** - Post to YouTube [@corneliuscornelius](https://youtube.com/@corneliuscornelius)

## License

All animation assets, scripts, and code in this repository are released into the public domain under the [UNLICENSE](UNLICENSE).

**Note:** Audio recordings containing identifiable voices are personal content and are not included in this license.

## Contributing

This is a personal project, but the assets are public domain—fork freely.
