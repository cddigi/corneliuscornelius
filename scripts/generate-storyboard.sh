#!/bin/bash
# corneliuscornelius - Storyboard to Synfig Generator
# UNLICENSE - Public Domain
#
# Generates Synfig .sif project files from JSON storyboard definitions.
# Enables rapid prototyping of animation storyboards using the SVG asset library.

set -e

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source the sif-generator library
source "$PROJECT_ROOT/lib/sif-generator.sh"

# Set assets directory for the library
export SIF_ASSETS_DIR="$PROJECT_ROOT/assets"

show_help() {
    cat << 'EOF'
generate-storyboard.sh - Generate Synfig .sif files from JSON storyboard

USAGE
    ./scripts/generate-storyboard.sh <storyboard.json>
    ./scripts/generate-storyboard.sh --help | --help-json

DESCRIPTION
    Converts a JSON storyboard definition into one or more Synfig .sif project
    files, enabling rapid prototyping of animation scenes using the project's
    SVG asset library.

    Generated .sif files are placed in the episode's animation/ directory
    and can be rendered with render-episode.sh or opened in Synfig Studio
    for further refinement.

ARGUMENTS
    <storyboard.json>   Path to the JSON storyboard definition file
                        (typically episodes/NNN-slug/storyboard.json)

OPTIONS
    -h, --help          Show this help message
    --help-json         Output help as JSON (for machine parsing)
    --version           Show version number
    --dry-run           Show what would be generated without writing files
    -o, --output DIR    Override output directory (default: episode's animation/)

JSON FORMAT
    {
      "episode": "001",
      "title": "Episode Title",
      "scenes": [
        {
          "id": "scene-001",
          "name": "Opening shot",
          "duration": 3.0,
          "background": "castle-siege",
          "characters": [
            {
              "asset": "stickman-base",
              "position": {"x": 0.5, "y": 0.8},
              "scale": 1.0
            }
          ],
          "props": [
            {
              "asset": "catapult",
              "position": {"x": 0.2, "y": 0.85},
              "scale": 0.8
            }
          ],
          "description": "Scene description for storyboard notes"
        }
      ]
    }

COORDINATE SYSTEM
    Position uses normalized 0.0-1.0 coordinates:
    - x: 0.0 = left edge, 0.5 = center, 1.0 = right edge
    - y: 0.0 = top edge, 0.5 = center, 1.0 = bottom edge

AVAILABLE ASSETS
    Characters: stickman-base, stickman-falling, stickman-dead
    Backgrounds: castle-siege, castle-interior, night-sky-simple
    Props: catapult, sword, shield, arrow, boulder, fire, debris-pile, crown, tombstone

EXAMPLES
    ./scripts/generate-storyboard.sh episodes/001-tower-building/storyboard.json
    ./scripts/generate-storyboard.sh --dry-run episodes/001-tower-building/storyboard.json
    ./scripts/generate-storyboard.sh -o /tmp/test episodes/001-tower-building/storyboard.json

WORKFLOW
    1. Create episode: ./scripts/new-episode.sh 001 tower-building
    2. Edit storyboard: episodes/001-tower-building/storyboard.json
    3. Generate .sif:   ./scripts/generate-storyboard.sh episodes/001-tower-building/storyboard.json
    4. Refine in Synfig Studio (optional)
    5. Render: ./scripts/render-episode.sh episodes/001-tower-building

EXIT CODES
    0    Success
    1    Invalid arguments or file not found
    2    JSON parsing error
    3    Asset not found

SEE ALSO
    ./scripts/new-episode.sh       Create episode directory structure
    ./scripts/render-episode.sh    Batch render Synfig files to PNG sequences
    templates/base-scene.sif       Reference Synfig template
    assets/                        Available SVG assets
EOF
}

show_help_json() {
    cat << 'EOF'
{
  "name": "generate-storyboard.sh",
  "version": "1.0.0",
  "description": "Generate Synfig .sif files from JSON storyboard definitions",
  "usage": "./scripts/generate-storyboard.sh <storyboard.json>",
  "arguments": [
    {
      "name": "storyboard.json",
      "required": true,
      "description": "Path to the JSON storyboard definition file"
    }
  ],
  "options": [
    {"short": "-h", "long": "--help", "description": "Show help message"},
    {"long": "--help-json", "description": "Output help as JSON"},
    {"long": "--version", "description": "Show version number"},
    {"long": "--dry-run", "description": "Show what would be generated without writing"},
    {"short": "-o", "long": "--output", "arg": "DIR", "description": "Override output directory"}
  ],
  "json_format": {
    "episode": "string (3-digit episode number)",
    "title": "string (episode title)",
    "scenes": [
      {
        "id": "string (unique scene identifier)",
        "name": "string (human-readable name)",
        "duration": "number (seconds)",
        "background": "string (background asset name)",
        "characters": [
          {
            "asset": "string (character asset name)",
            "position": {"x": "number (0-1)", "y": "number (0-1)"},
            "scale": "number (default 1.0)"
          }
        ],
        "props": [
          {
            "asset": "string (prop asset name)",
            "position": {"x": "number (0-1)", "y": "number (0-1)"},
            "scale": "number (default 1.0)"
          }
        ],
        "description": "string (storyboard notes)"
      }
    ]
  },
  "available_assets": {
    "characters": ["stickman-base", "stickman-falling", "stickman-dead"],
    "backgrounds": ["castle-siege", "castle-interior", "night-sky-simple"],
    "props": ["catapult", "sword", "shield", "arrow", "boulder", "fire", "debris-pile", "crown", "tombstone"]
  },
  "exit_codes": [
    {"code": 0, "description": "Success"},
    {"code": 1, "description": "Invalid arguments or file not found"},
    {"code": 2, "description": "JSON parsing error"},
    {"code": 3, "description": "Asset not found"}
  ]
}
EOF
}

# Check for jq (required for JSON parsing)
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required for JSON parsing"
        echo "Install with: brew install jq"
        exit 1
    fi

    if ! command -v bc &> /dev/null; then
        echo "Error: bc is required for coordinate calculations"
        echo "Install with: brew install bc"
        exit 1
    fi
}

# Validate that an asset exists
validate_asset() {
    local name="$1"
    local category=$(sif_asset_category "$name")
    local path="$SIF_ASSETS_DIR/$category/$name.svg"

    if [[ ! -f "$path" ]]; then
        echo "Error: Asset not found: $name ($path)"
        exit 3
    fi
    echo "$path"
}

# Generate a single scene .sif file
generate_scene() {
    local scene_json="$1"
    local output_path="$2"
    local episode_dir="$3"

    local scene_id=$(echo "$scene_json" | jq -r '.id')
    local scene_name=$(echo "$scene_json" | jq -r '.name // .id')
    local duration=$(echo "$scene_json" | jq -r '.duration // 5')
    local background=$(echo "$scene_json" | jq -r '.background // ""')

    # Convert duration to Synfig time format (e.g., "5s")
    local end_time="${duration}s"

    # Start building the .sif content
    {
        sif_canvas_header "$scene_name" "$end_time"

        # Add background
        if [[ -n "$background" && "$background" != "null" ]]; then
            local bg_path=$(validate_asset "$background")
            # Background spans full canvas
            sif_import_layer "$bg_path" 0.5 0.5 8.0 "Background: $background"
        else
            # Default solid color background
            sif_solid_color "bg_night" "Background"
        fi

        # Add props (behind characters)
        local props_count=$(echo "$scene_json" | jq '.props | length // 0')
        if [[ "$props_count" -gt 0 ]]; then
            echo "$scene_json" | jq -c '.props[]?' | while read -r prop; do
                local asset=$(echo "$prop" | jq -r '.asset')
                local x=$(echo "$prop" | jq -r '.position.x // 0.5')
                local y=$(echo "$prop" | jq -r '.position.y // 0.5')
                local scale=$(echo "$prop" | jq -r '.scale // 1.0')
                local prop_path=$(validate_asset "$asset")
                sif_import_layer "$prop_path" "$x" "$y" "$scale" "Prop: $asset"
            done
        fi

        # Add characters
        local chars_count=$(echo "$scene_json" | jq '.characters | length // 0')
        if [[ "$chars_count" -gt 0 ]]; then
            echo "$scene_json" | jq -c '.characters[]?' | while read -r char; do
                local asset=$(echo "$char" | jq -r '.asset')
                local x=$(echo "$char" | jq -r '.position.x // 0.5')
                local y=$(echo "$char" | jq -r '.position.y // 0.5')
                local scale=$(echo "$char" | jq -r '.scale // 1.0')
                local char_path=$(validate_asset "$asset")
                sif_import_layer "$char_path" "$x" "$y" "$scale" "Character: $asset"
            done
        fi

        sif_canvas_footer
    } > "$output_path"

    echo "  Generated: $output_path"
}

# Main function
main() {
    local dry_run=false
    local output_dir=""
    local storyboard_file=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            --help-json)
                show_help_json
                exit 0
                ;;
            --version)
                echo "generate-storyboard.sh version $VERSION"
                exit 0
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -*)
                echo "Error: Unknown option: $1"
                echo "Run '$0 --help' for usage information."
                exit 1
                ;;
            *)
                storyboard_file="$1"
                shift
                ;;
        esac
    done

    # Validate input
    if [[ -z "$storyboard_file" ]]; then
        echo "Error: No storyboard file specified"
        echo "Usage: $0 <storyboard.json>"
        echo ""
        echo "Run '$0 --help' for more information."
        exit 1
    fi

    if [[ ! -f "$storyboard_file" ]]; then
        echo "Error: Storyboard file not found: $storyboard_file"
        exit 1
    fi

    check_dependencies

    # Parse JSON
    if ! jq empty "$storyboard_file" 2>/dev/null; then
        echo "Error: Invalid JSON in $storyboard_file"
        exit 2
    fi

    local episode=$(jq -r '.episode // ""' "$storyboard_file")
    local title=$(jq -r '.title // "Untitled"' "$storyboard_file")

    # Determine output directory
    if [[ -z "$output_dir" ]]; then
        # Default: same directory as storyboard, in animation/ subfolder
        local storyboard_dir=$(dirname "$storyboard_file")
        output_dir="$storyboard_dir/animation"
    fi

    echo "Generating storyboard: $title (Episode $episode)"
    echo "  Input: $storyboard_file"
    echo "  Output: $output_dir/"

    if $dry_run; then
        echo ""
        echo "[DRY RUN] Would generate:"
    fi

    # Create output directory
    if ! $dry_run; then
        mkdir -p "$output_dir"
    fi

    # Process each scene
    local scene_count=$(jq '.scenes | length' "$storyboard_file")

    if [[ "$scene_count" -eq 0 ]]; then
        echo "Warning: No scenes defined in storyboard"
        exit 0
    fi

    for i in $(seq 0 $((scene_count - 1))); do
        local scene_json=$(jq ".scenes[$i]" "$storyboard_file")
        local scene_id=$(echo "$scene_json" | jq -r '.id')
        local output_path="$output_dir/$scene_id.sif"

        if $dry_run; then
            echo "  - $output_path"
            local chars=$(echo "$scene_json" | jq -r '[.characters[].asset] | join(", ") // "none"')
            local props=$(echo "$scene_json" | jq -r '[.props[].asset] | join(", ") // "none"')
            local bg=$(echo "$scene_json" | jq -r '.background // "solid color"')
            echo "    Background: $bg"
            echo "    Characters: $chars"
            echo "    Props: $props"
        else
            generate_scene "$scene_json" "$output_path" "$(dirname "$storyboard_file")"
        fi
    done

    echo ""
    if $dry_run; then
        echo "[DRY RUN] No files were written"
    else
        echo "Generated $scene_count scene(s)"
        echo ""
        echo "Next steps:"
        echo "  1. Open in Synfig Studio for refinement (optional)"
        echo "  2. Render: ./scripts/render-episode.sh $(dirname "$storyboard_file")"
    fi
}

main "$@"
