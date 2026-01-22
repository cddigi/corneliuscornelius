#!/bin/bash
# corneliuscornelius - Batch Render Synfig Files
# UNLICENSE - Public Domain
#
# Usage: ./scripts/render-episode.sh episodes/001-tower-building

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <episode-directory>"
    echo "Example: $0 episodes/001-tower-building"
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
