#!/bin/bash
# corneliuscornelius - New Episode Scaffolding
# UNLICENSE - Public Domain

set -e

show_help() {
    cat << 'EOF'
new-episode.sh - Create episode directory structure for corneliuscornelius

USAGE
    ./scripts/new-episode.sh <episode-number> <episode-slug>
    ./scripts/new-episode.sh --help

ARGUMENTS
    <episode-number>    Three-digit episode number (e.g., 001, 012, 100)
    <episode-slug>      URL-friendly name using lowercase and hyphens
                        (e.g., "tower-building", "castle-siege")

EXAMPLES
    ./scripts/new-episode.sh 001 tower-building
    ./scripts/new-episode.sh 002 catapult-chaos
    ./scripts/new-episode.sh 010 throne-room-drama

CREATES
    episodes/<number>-<slug>/
    ├── audio/          Raw WAV + edited FLAC files
    ├── animation/      Synfig .sif project files
    ├── export/         Final MP4 renders + PNG sequences
    └── NOTES.md        Storyboard checklist template

WORKFLOW
    1. Run this script to scaffold the episode
    2. Record audio and place raw .wav in audio/
    3. Edit audio in Tenacity, export as FLAC
    4. Fill out storyboard in NOTES.md
    5. Create Synfig animations in animation/
    6. Render with: ./scripts/render-episode.sh episodes/<episode-dir>
    7. Composite in Kdenlive and export final MP4

SEE ALSO
    ./scripts/render-episode.sh    Batch render Synfig files to PNG sequences
    demo.html                      Preview character assets and animations
    assets/COLOR-PALETTE.md        Color codes for consistent styling
EOF
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
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

# Create .gitkeep files
touch "$EPISODE_DIR/audio/.gitkeep"
touch "$EPISODE_DIR/animation/.gitkeep"
touch "$EPISODE_DIR/export/.gitkeep"

echo "✓ Created: $EPISODE_DIR/"
echo "  ├── audio/"
echo "  ├── animation/"
echo "  ├── export/"
echo "  └── NOTES.md"
echo ""
echo "Next steps:"
echo "  1. Add raw .wav to audio/"
echo "  2. Edit storyboard in NOTES.md"
echo "  3. Create .sif files in animation/"
