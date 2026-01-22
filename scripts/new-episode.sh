#!/bin/bash
# corneliuscornelius - New Episode Scaffolding
# UNLICENSE - Public Domain
#
# Usage: ./scripts/new-episode.sh 001 "tower-building"

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <episode-number> <episode-slug>"
    echo "Example: $0 001 tower-building"
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
