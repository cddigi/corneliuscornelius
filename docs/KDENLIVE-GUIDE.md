# Kdenlive Guide for corneliuscornelius

This guide covers Kdenlive as your video compositing and audio sync tool in the corneliuscornelius production pipeline.

## Installation

```bash
brew install --cask kdenlive
```

## Role in the Pipeline

Kdenlive sits at the **final compositing stage**:

```
Synfig (.sif) → render-episode.sh → PNG sequences
                                          ↓
Audio (FLAC) ────────────────────→ Kdenlive → Final MP4
```

You import rendered PNG frame sequences and edited audio, sync them, add transitions/effects, and export the final YouTube-ready video.

---

## Project Setup

### Creating a New Project

1. **File → New** (or Ctrl+N)
2. Configure project settings:
   - **Resolution**: 1920×1080 (Full HD)
   - **Frame rate**: 24 fps (cinematic) or 30 fps (web standard)
   - **Aspect ratio**: 16:9
   - **Audio**: 48000 Hz, Stereo

### Recommended Project Settings for corneliuscornelius

| Setting | Value | Rationale |
|---------|-------|-----------|
| Resolution | 1920×1080 | YouTube HD standard |
| Frame rate | 24 fps | Matches Synfig default, cinematic feel |
| Color space | sRGB | Web compatibility |
| Audio sample rate | 48000 Hz | Broadcast standard |

---

## Importing Assets

### PNG Sequences (from Synfig renders)

1. **Project → Add Clip** (or drag into Project Bin)
2. Navigate to `episodes/NNN-name/export/frames/`
3. Select the **first frame** of the sequence (e.g., `scene-001.00001.png`)
4. Kdenlive auto-detects the sequence
5. In the dialog, verify:
   - Frame rate matches your project (24 fps)
   - "Import image sequence" is checked

**Tip**: Each Synfig `.sif` file renders to its own PNG sequence. Import each as a separate clip.

### Audio (FLAC)

1. **Project → Add Clip**
2. Navigate to `episodes/NNN-name/audio/`
3. Select the edited `.flac` file
4. Drag to an audio track in the timeline

---

## Timeline Organization

### Track Layout (recommended)

```
Video Track 3: Overlays / Effects / Text
Video Track 2: Foreground animation
Video Track 1: Background / Scene
─────────────────────────────────────────
Audio Track 1: Voice recording (FLAC)
Audio Track 2: Sound effects
Audio Track 3: Music (if any)
```

### Working with Multiple Scenes

For episodes with multiple animated scenes:

1. Place each PNG sequence on the timeline sequentially
2. Use **razor tool** (X) to cut at scene transitions
3. Add **crossfade** or **cut** transitions between scenes

---

## Audio-Video Sync

This is the **primary task** in Kdenlive for corneliuscornelius—matching stick-figure animations to family conversations.

### Manual Sync Workflow

1. Drag audio to Audio Track 1
2. Drag animation sequence to Video Track 1
3. Play and identify sync points (mouth movements, reactions, beats)
4. Use **arrow keys** for frame-by-frame navigation
5. **Shift+drag** clips to fine-tune position
6. Use **markers** (M) to mark key sync points

### Sync Tips

- **Mark dialogue beats** in the audio waveform before animating
- Synfig animations should already be timed to audio—Kdenlive is for fine adjustment
- Use the **audio waveform** display: Right-click audio clip → Show Audio Waveform

---

## Essential Effects

### For Dark Comedy Aesthetic

| Effect | Use Case | Location |
|--------|----------|----------|
| **Vignette** | Darkens edges, focuses attention | Effects → Alpha/Transform |
| **Color correction** | Enhance dark palette | Effects → Color |
| **Fade in/out** | Scene transitions | Right-click clip → Add Effect |
| **Speed/Duration** | Slow-mo for comedic timing | Right-click → Change Speed |

### Applying Effects

1. Select clip in timeline
2. **Effects** panel (right side)
3. Drag effect onto clip OR double-click
4. Adjust parameters in **Effect Stack** panel

### Blood Red Glow Effect (matching color palette)

For danger scenes:
1. Add **Glow** effect
2. Set color to `#5c1e1e` (blood red accent)
3. Adjust radius and intensity

---

## Transitions

### Adding Transitions

1. Overlap two clips on the same track
2. Kdenlive auto-creates a dissolve
3. OR right-click overlap → **Add Transition**

### Recommended Transitions

| Transition | Use |
|------------|-----|
| **Dissolve** | Standard scene change |
| **Wipe** | Comedic timing, reveals |
| **Cut** (no transition) | Abrupt humor, shock |
| **Fade to black** | End of scene/episode |

---

## Text and Titles

For episode titles or captions:

1. **Project → Add Title Clip**
2. Use Title Editor:
   - Font: Sans-serif, bold (matches stick-figure simplicity)
   - Color: White (`#ffffff`) on dark, or blood red (`#5c1e1e`) for emphasis
   - Add outline/shadow for readability
3. Drag title to Video Track 3 (overlay)

---

## Rendering Final Output

### Export Settings for YouTube

1. **Project → Render** (Ctrl+Enter)
2. Presets: **MP4 - H264/AAC** (or select manually)
3. Settings:

| Parameter | Value |
|-----------|-------|
| Format | MP4 |
| Video codec | H.264 / libx264 |
| Audio codec | AAC |
| Resolution | 1920×1080 |
| Frame rate | 24 fps (match project) |
| Quality | Rate control: Quality-based, ~20-23 CRF |
| Audio | 192 kbps or higher |

4. Output file: `episodes/NNN-name/export/final.mp4`
5. Click **Render to File**

### Render Queue

For batch rendering multiple projects:
1. Configure render settings
2. Click **Generate Script** instead of Render
3. Repeat for other projects
4. Run all scripts via terminal

---

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Play/Pause | Space |
| Next frame | Right arrow |
| Previous frame | Left arrow |
| Razor tool | X |
| Selection tool | S |
| Add marker | M |
| Split clip at playhead | Shift+R |
| Zoom in timeline | Ctrl++ |
| Zoom out timeline | Ctrl+- |
| Render | Ctrl+Enter |
| Undo | Ctrl+Z |
| Save | Ctrl+S |

---

## CLI / Scripting Integration

Kdenlive uses **MLT** (Media Lovin' Toolkit) as its backend. You can script renders:

### Render from Command Line

```bash
# Using melt (MLT's CLI)
melt project.kdenlive -consumer avformat:output.mp4 \
  vcodec=libx264 acodec=aac

# Or use Kdenlive's render script
kdenlive_render -in project.kdenlive -out output.mp4
```

### Headless Rendering

For a fully automated pipeline:

```bash
# Generate render script from Kdenlive GUI first
# Then run the generated .sh script
./project_render_script.sh
```

---

## File Management

### What to Commit

- `.kdenlive` project files (small, XML-based)
- Title clips (if saved separately)

### What NOT to Commit (already in .gitignore)

- Rendered MP4/MOV/AVI files
- Proxy clips (`.proxy.mp4`)
- Backup files (`~`)

### Project Location

Store Kdenlive projects in episode directories:
```
episodes/001-tower-building/
├── animation/         # Synfig sources
├── audio/             # FLAC files
├── export/
│   ├── frames/        # PNG sequences
│   └── final.mp4      # Rendered output (gitignored)
└── 001-tower-building.kdenlive  # Project file
```

---

## Troubleshooting

### Common Issues

| Problem | Solution |
|---------|----------|
| PNG sequence not detected | Ensure sequential naming (`name.00001.png`) |
| Audio out of sync | Check project fps matches Synfig render fps |
| Choppy playback | Enable proxy clips: Settings → Configure → Proxy |
| Black frames in export | Check clip boundaries, no gaps in timeline |
| Colors look wrong | Verify color space (sRGB) in project settings |

### Performance Tips

1. **Enable proxy clips** for smooth editing (especially with 1080p PNGs)
2. **Pre-render** complex effect stacks
3. **Close other apps** during final render
4. Kdenlive autosaves—check **File → Open Backup File** if crash occurs

---

## Integration with Other Tools

### From Synfig

- Use `render-episode.sh` to batch render all `.sif` files
- Output goes to `export/frames/` as PNG sequences
- Import sequences into Kdenlive

### From Tenacity

- Export edited audio as FLAC (lossless)
- Place in `episodes/NNN-name/audio/`
- Import into Kdenlive

### To YouTube

- Render as H.264 MP4
- Upload directly
- Kdenlive's default YouTube preset works well

---

## Quick Reference Workflow

```
1. Create new project (1920×1080, 24fps)
2. Import PNG sequences from export/frames/
3. Import FLAC audio from audio/
4. Arrange on timeline (audio track 1, video track 1)
5. Sync audio to animation
6. Add transitions between scenes
7. Apply effects (vignette, color correction)
8. Add title card if needed
9. Render to MP4 (H.264/AAC)
10. Output: episodes/NNN-name/export/final.mp4
```
