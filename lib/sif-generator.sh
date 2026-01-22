#!/bin/bash
# corneliuscornelius - Synfig .sif XML Generator Library
# UNLICENSE - Public Domain
#
# Provides functions for generating Synfig .sif XML files programmatically.
# Sourced by scripts that need to create Synfig project files.

# Canvas dimensions (1920x1080 at 24fps)
SIF_WIDTH=1920
SIF_HEIGHT=1080
SIF_FPS=24
SIF_VERSION="1.2"

# Synfig coordinate system: viewBox spans -4 to 4 horizontally, 2.25 to -2.25 vertically
# These values map pixel coordinates to Synfig units
SIF_VIEW_LEFT=-4.0
SIF_VIEW_RIGHT=4.0
SIF_VIEW_TOP=2.25
SIF_VIEW_BOTTOM=-2.25

# Synfig color codes (RGBA 0-1 scale) from COLOR-PALETTE.md
declare -A SIF_COLORS=(
    ["bg_void"]="0.020 0.020 0.031 1.0"
    ["bg_night"]="0.039 0.039 0.063 1.0"
    ["bg_blood_dark"]="0.102 0.020 0.020 1.0"
    ["bg_blood"]="0.239 0.039 0.039 1.0"
    ["stick_black"]="0.102 0.102 0.102 1.0"
    ["fire_orange"]="0.753 0.188 0.000 1.0"
    ["fire_yellow"]="1.000 0.800 0.000 1.0"
)

# Convert normalized position (0-1) to Synfig units
# Usage: sif_normalize_x 0.5  # returns 0.0 (center)
sif_normalize_x() {
    local norm=$1
    echo "scale=6; $SIF_VIEW_LEFT + ($norm * ($SIF_VIEW_RIGHT - $SIF_VIEW_LEFT))" | bc
}

sif_normalize_y() {
    local norm=$1
    # Y is inverted: 0 = top (2.25), 1 = bottom (-2.25)
    echo "scale=6; $SIF_VIEW_TOP - ($norm * ($SIF_VIEW_TOP - $SIF_VIEW_BOTTOM))" | bc
}

# Generate XML header and canvas opening tag
# Usage: sif_canvas_header "Scene Name" "5s"
sif_canvas_header() {
    local name="${1:-Untitled}"
    local end_time="${2:-5s}"

    cat << EOF
<?xml version="1.0" encoding="UTF-8"?>
<canvas version="$SIF_VERSION" width="$SIF_WIDTH" height="$SIF_HEIGHT"
        xres="2834.645669" yres="2834.645669"
        view-box="$SIF_VIEW_LEFT $SIF_VIEW_TOP $SIF_VIEW_RIGHT $SIF_VIEW_BOTTOM"
        antialias="1" fps="$SIF_FPS" begin-time="0f" end-time="$end_time"
        bgcolor="0.039 0.039 0.063 1.0">
  <name>$name</name>
EOF
}

# Generate canvas closing tag
sif_canvas_footer() {
    echo "</canvas>"
}

# Generate a solid color background layer
# Usage: sif_solid_color "bg_night" "Background"
sif_solid_color() {
    local color_name="${1:-bg_night}"
    local desc="${2:-Background}"
    local color="${SIF_COLORS[$color_name]:-${SIF_COLORS[bg_night]}}"

    # Parse color components
    local r g b a
    read r g b a <<< "$color"

    cat << EOF
  <layer type="solid_color" active="true" version="0.1" desc="$desc">
    <param name="z_depth">
      <real value="0.0"/>
    </param>
    <param name="amount">
      <real value="1.0"/>
    </param>
    <param name="blend_method">
      <integer value="0"/>
    </param>
    <param name="color">
      <color>
        <r>$r</r>
        <g>$g</g>
        <b>$b</b>
        <a>$a</a>
      </color>
    </param>
  </layer>
EOF
}

# Generate an import layer for an external image/SVG file
# Usage: sif_import_layer "path/to/file.svg" 0.5 0.8 1.0 "Character"
# Args: filepath, normalized_x, normalized_y, scale, description
sif_import_layer() {
    local filepath="$1"
    local norm_x="${2:-0.5}"
    local norm_y="${3:-0.5}"
    local scale="${4:-1.0}"
    local desc="${5:-Imported Asset}"

    # Convert normalized coords to Synfig units
    local x=$(sif_normalize_x "$norm_x")
    local y=$(sif_normalize_y "$norm_y")

    # Calculate bounding box based on scale
    # Default assumes ~0.5 unit width/height at scale 1.0
    local half_width=$(echo "scale=6; 0.5 * $scale" | bc)
    local half_height=$(echo "scale=6; 0.5 * $scale" | bc)

    local tl_x=$(echo "scale=6; $x - $half_width" | bc)
    local tl_y=$(echo "scale=6; $y + $half_height" | bc)
    local br_x=$(echo "scale=6; $x + $half_width" | bc)
    local br_y=$(echo "scale=6; $y - $half_height" | bc)

    cat << EOF
  <layer type="import" active="true" version="0.1" desc="$desc">
    <param name="z_depth">
      <real value="0.0"/>
    </param>
    <param name="amount">
      <real value="1.0"/>
    </param>
    <param name="blend_method">
      <integer value="0"/>
    </param>
    <param name="tl">
      <vector>
        <x>$tl_x</x>
        <y>$tl_y</y>
      </vector>
    </param>
    <param name="br">
      <vector>
        <x>$br_x</x>
        <y>$br_y</y>
      </vector>
    </param>
    <param name="c">
      <integer value="1"/>
    </param>
    <param name="gamma_adjust">
      <real value="1.0"/>
    </param>
    <param name="filename">
      <string>$filepath</string>
    </param>
  </layer>
EOF
}

# Generate a group layer containing other layers
# Usage: sif_group_start "Characters" followed by layer content, then sif_group_end
sif_group_start() {
    local desc="${1:-Group}"
    cat << EOF
  <layer type="group" active="true" version="0.1" desc="$desc">
    <param name="z_depth">
      <real value="0.0"/>
    </param>
    <param name="amount">
      <real value="1.0"/>
    </param>
    <param name="blend_method">
      <integer value="0"/>
    </param>
    <param name="origin">
      <vector>
        <x>0.0</x>
        <y>0.0</y>
      </vector>
    </param>
    <param name="transformation">
      <composite type="transformation">
        <offset>
          <vector>
            <x>0.0</x>
            <y>0.0</y>
          </vector>
        </offset>
        <angle>
          <angle value="0.0"/>
        </angle>
        <skew_angle>
          <angle value="0.0"/>
        </skew_angle>
        <scale>
          <vector>
            <x>1.0</x>
            <y>1.0</y>
          </vector>
        </scale>
      </composite>
    </param>
    <param name="canvas">
      <canvas>
EOF
}

sif_group_end() {
    cat << EOF
      </canvas>
    </param>
  </layer>
EOF
}

# Lookup asset path from asset name
# Usage: sif_asset_path "stickman-base" "characters"
# Returns absolute path to the asset SVG
sif_asset_path() {
    local name="$1"
    local category="${2:-characters}"
    local base_dir="${SIF_ASSETS_DIR:-$(dirname "${BASH_SOURCE[0]}")/../assets}"

    echo "$base_dir/$category/$name.svg"
}

# Resolve asset category from name
sif_asset_category() {
    local name="$1"
    case "$name" in
        stickman-*) echo "characters" ;;
        castle-*|night-*) echo "backgrounds" ;;
        *) echo "props" ;;
    esac
}
