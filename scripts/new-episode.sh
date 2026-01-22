#!/bin/bash
# corneliuscornelius - New Episode Scaffolding
# UNLICENSE - Public Domain

set -e

VERSION="1.0.0"

show_help() {
    cat << 'EOF'
new-episode.sh - Create episode directory structure for corneliuscornelius

USAGE
    ./scripts/new-episode.sh <episode-number> <episode-slug>
    ./scripts/new-episode.sh --help | --help-json

ARGUMENTS
    <episode-number>    Three-digit episode number (e.g., 001, 012, 100)
    <episode-slug>      URL-friendly name using lowercase and hyphens
                        (e.g., "tower-building", "castle-siege")

OPTIONS
    -h, --help          Show this help message
    --help-json         Output help as JSON (for machine parsing)
    --version           Show version number

EXAMPLES
    ./scripts/new-episode.sh 001 tower-building
    ./scripts/new-episode.sh 002 catapult-chaos
    ./scripts/new-episode.sh 010 throne-room-drama

CREATES
    episodes/<number>-<slug>/
    ├── audio/          Raw WAV + edited FLAC files
    ├── animation/      Synfig .sif project files
    ├── export/         Final MP4 renders + PNG sequences
    ├── storyboard.json JSON scene definitions for generate-storyboard.sh
    └── NOTES.md        Storyboard checklist template

WORKFLOW
    1. Run this script to scaffold the episode
    2. Record audio and place raw .wav in audio/
    3. Edit audio in Tenacity, export as FLAC
    4. Define scenes in storyboard.json
    5. Generate .sif files: ./scripts/generate-storyboard.sh episodes/<episode-dir>/storyboard.json
    6. Refine animations in Synfig Studio (optional)
    7. Render with: ./scripts/render-episode.sh episodes/<episode-dir>
    8. Composite in Kdenlive and export final MP4

EXIT CODES
    0    Success
    1    Invalid arguments or episode already exists

SEE ALSO
    ./scripts/generate-storyboard.sh  Generate Synfig .sif from storyboard.json
    ./scripts/render-episode.sh       Batch render Synfig files to PNG sequences
    demo.html                         Preview character assets and animations
    assets/COLOR-PALETTE.md           Color codes for consistent styling
EOF
}

show_help_json() {
    cat << 'EOF'
{
  "name": "new-episode.sh",
  "version": "1.0.0",
  "description": "Create episode directory structure for corneliuscornelius",
  "usage": "./scripts/new-episode.sh <episode-number> <episode-slug>",
  "arguments": [
    {
      "name": "episode-number",
      "required": true,
      "description": "Three-digit episode number (e.g., 001, 012, 100)",
      "pattern": "^[0-9]{3}$"
    },
    {
      "name": "episode-slug",
      "required": true,
      "description": "URL-friendly name using lowercase and hyphens",
      "pattern": "^[a-z0-9-]+$"
    }
  ],
  "options": [
    {"short": "-h", "long": "--help", "description": "Show help message"},
    {"long": "--help-json", "description": "Output help as JSON"},
    {"long": "--version", "description": "Show version number"}
  ],
  "examples": [
    {"command": "./scripts/new-episode.sh 001 tower-building", "description": "Create first episode"},
    {"command": "./scripts/new-episode.sh 002 catapult-chaos", "description": "Create second episode"},
    {"command": "./scripts/new-episode.sh 010 throne-room-drama", "description": "Create tenth episode"}
  ],
  "creates": {
    "path": "episodes/<number>-<slug>/",
    "structure": [
      {"path": "audio/", "description": "Raw WAV + edited FLAC files"},
      {"path": "animation/", "description": "Synfig .sif project files"},
      {"path": "export/", "description": "Final MP4 renders + PNG sequences"},
      {"path": "storyboard.json", "description": "JSON scene definitions"},
      {"path": "NOTES.md", "description": "Storyboard checklist template"}
    ]
  },
  "exit_codes": [
    {"code": 0, "description": "Success"},
    {"code": 1, "description": "Invalid arguments or episode already exists"}
  ],
  "see_also": [
    {"name": "./scripts/generate-storyboard.sh", "description": "Generate Synfig .sif from storyboard.json"},
    {"name": "./scripts/render-episode.sh", "description": "Batch render Synfig files to PNG sequences"},
    {"name": "demo.html", "description": "Preview character assets and animations"},
    {"name": "assets/COLOR-PALETTE.md", "description": "Color codes for consistent styling"}
  ]
}
EOF
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

if [ "$1" = "--help-json" ]; then
    show_help_json
    exit 0
fi

if [ "$1" = "--version" ]; then
    echo "new-episode.sh version $VERSION"
    exit 0
fi

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <episode-number> <episode-slug>"
    echo "Example: $0 001 tower-building"
    echo ""
    echo "Run '$0 --help' for more information."
    exit 1
fi

EPISODE_NUM="$1"
EPISODE_SLUG="$2"
EPISODE_DIR="episodes/${EPISODE_NUM}-${EPISODE_SLUG}"

if [ -d "$EPISODE_DIR" ]; then
    echo "Error: Episode directory already exists: $EPISODE_DIR"
    exit 1
fi

echo "Creating episode: $EPISODE_DIR"

mkdir -p "$EPISODE_DIR/audio"
mkdir -p "$EPISODE_DIR/animation"
mkdir -p "$EPISODE_DIR/export"

# Create episode notes file
cat > "$EPISODE_DIR/NOTES.md" << EOF
# Episode ${EPISODE_NUM}: ${EPISODE_SLUG}

## Audio
- [ ] Record raw audio
- [ ] Clean in Tenacity
- [ ] Export FLAC

## Storyboard
Describe the dark visual gags that contrast with the audio:

1. Scene 1:
2. Scene 2:
3. Scene 3:

## Animation
- [ ] Create scenes in Synfig
- [ ] Render PNG sequences
- [ ] Composite in Kdenlive

## Export
- [ ] Final render 1080p MP4
- [ ] Create thumbnail
- [ ] Write description

## Notes

EOF

# Create storyboard.json template
cat > "$EPISODE_DIR/storyboard.json" << EOF
{
  "episode": "${EPISODE_NUM}",
  "title": "${EPISODE_SLUG}",
  "scenes": [
    {
      "id": "scene-001",
      "name": "Opening shot",
      "duration": 5.0,
      "background": "castle-siege",
      "characters": [
        {
          "asset": "stickman-base",
          "position": {"x": 0.5, "y": 0.7},
          "scale": 1.0
        }
      ],
      "props": [],
      "description": "Describe the dark visual gag for this scene"
    }
  ]
}
EOF

# Create .gitkeep files
touch "$EPISODE_DIR/audio/.gitkeep"
touch "$EPISODE_DIR/animation/.gitkeep"
touch "$EPISODE_DIR/export/.gitkeep"

echo "Created: $EPISODE_DIR/"
echo "  ├── audio/"
echo "  ├── animation/"
echo "  ├── export/"
echo "  ├── storyboard.json"
echo "  └── NOTES.md"
echo ""
echo "Next steps:"
echo "  1. Add raw .wav to audio/"
echo "  2. Define scenes in storyboard.json"
echo "  3. Generate .sif files:"
echo "     ./scripts/generate-storyboard.sh $EPISODE_DIR/storyboard.json"
