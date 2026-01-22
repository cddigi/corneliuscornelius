#!/bin/bash
# corneliuscornelius - Batch Render Synfig Files
# UNLICENSE - Public Domain

set -e

VERSION="1.0.0"

show_help() {
    cat << 'EOF'
render-episode.sh - Batch render Synfig animations to PNG sequences

USAGE
    ./scripts/render-episode.sh <episode-directory>
    ./scripts/render-episode.sh --help | --help-json

ARGUMENTS
    <episode-directory>    Path to episode folder containing animation/ subdir
                           (e.g., episodes/001-tower-building)

OPTIONS
    -h, --help          Show this help message
    --help-json         Output help as JSON (for machine parsing)
    --version           Show version number

EXAMPLES
    ./scripts/render-episode.sh episodes/001-tower-building
    ./scripts/render-episode.sh episodes/002-catapult-chaos

RENDERS
    For each .sif file in <episode-directory>/animation/:

    <episode-directory>/export/frames/<basename>/
    └── <basename>.0001.png    PNG sequence at 1920x1080
    └── <basename>.0002.png
    └── ...

REQUIREMENTS
    synfig    Synfig CLI renderer
              Install: brew install synfig (macOS)
                       apt install synfigstudio (Linux)

WORKFLOW
    1. Create episode with: ./scripts/new-episode.sh <number> <slug>
    2. Create Synfig animations in animation/
    3. Run this script to batch render all .sif files
    4. Import PNG sequences into Kdenlive:
       - Project > Add Clip > Add Image Sequence
       - Select first frame of each sequence
    5. Sync with audio and export final MP4

EXIT CODES
    0    Success - all files rendered
    1    Invalid arguments, missing directory, or synfig not found

SEE ALSO
    ./scripts/new-episode.sh       Create new episode directory structure
    demo.html                      Preview character assets and animations
    assets/COLOR-PALETTE.md        Color codes for consistent styling
EOF
}

show_help_json() {
    cat << 'EOF'
{
  "name": "render-episode.sh",
  "version": "1.0.0",
  "description": "Batch render Synfig animations to PNG sequences",
  "usage": "./scripts/render-episode.sh <episode-directory>",
  "arguments": [
    {
      "name": "episode-directory",
      "required": true,
      "description": "Path to episode folder containing animation/ subdir",
      "example": "episodes/001-tower-building"
    }
  ],
  "options": [
    {"short": "-h", "long": "--help", "description": "Show help message"},
    {"long": "--help-json", "description": "Output help as JSON"},
    {"long": "--version", "description": "Show version number"}
  ],
  "examples": [
    {"command": "./scripts/render-episode.sh episodes/001-tower-building", "description": "Render first episode"},
    {"command": "./scripts/render-episode.sh episodes/002-catapult-chaos", "description": "Render second episode"}
  ],
  "renders": {
    "input": "<episode-directory>/animation/*.sif",
    "output": "<episode-directory>/export/frames/<basename>/",
    "format": "PNG sequence",
    "resolution": "1920x1080"
  },
  "requirements": [
    {
      "name": "synfig",
      "description": "Synfig CLI renderer",
      "install": {
        "macos": "brew install synfig",
        "linux": "apt install synfigstudio"
      }
    }
  ],
  "exit_codes": [
    {"code": 0, "description": "Success - all files rendered"},
    {"code": 1, "description": "Invalid arguments, missing directory, or synfig not found"}
  ],
  "see_also": [
    {"name": "./scripts/new-episode.sh", "description": "Create new episode directory structure"},
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
    echo "render-episode.sh version $VERSION"
    exit 0
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <episode-directory>"
    echo "Example: $0 episodes/001-tower-building"
    echo ""
    echo "Run '$0 --help' for more information."
    exit 1
fi

EPISODE_DIR="$1"
ANIMATION_DIR="$EPISODE_DIR/animation"
EXPORT_DIR="$EPISODE_DIR/export"

if [ ! -d "$ANIMATION_DIR" ]; then
    echo "Error: Animation directory not found: $ANIMATION_DIR"
    exit 1
fi

# Check for synfig CLI
if ! command -v synfig &> /dev/null; then
    echo "Error: synfig CLI not found"
    echo "Install with: brew install synfig (macOS) or apt install synfigstudio (Linux)"
    exit 1
fi

mkdir -p "$EXPORT_DIR/frames"

echo "Rendering Synfig files in: $ANIMATION_DIR"
echo ""

for SIF_FILE in "$ANIMATION_DIR"/*.sif; do
    if [ -f "$SIF_FILE" ]; then
        BASENAME=$(basename "$SIF_FILE" .sif)
        OUTPUT_DIR="$EXPORT_DIR/frames/$BASENAME"
        mkdir -p "$OUTPUT_DIR"

        echo "Rendering: $BASENAME"
        echo "  Output: $OUTPUT_DIR/"

        # Render to PNG sequence
        # -t png: output format
        # -w 1920 -h 1080: HD resolution
        # --sequence-separator: frame numbering
        synfig "$SIF_FILE" \
            -t png \
            -w 1920 \
            -h 1080 \
            -o "$OUTPUT_DIR/$BASENAME.png" \
            --sequence-separator . \
            2>&1 | sed 's/^/  /'

        echo "  ✓ Done"
        echo ""
    fi
done

echo "All renders complete!"
echo ""
echo "Next: Import frame sequences into Kdenlive"
echo "  1. Open Kdenlive"
echo "  2. Project > Add Clip > Add Image Sequence"
echo "  3. Select first frame of each sequence"
