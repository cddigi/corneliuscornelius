# CorneliusCornelius Animation Workflow
## Wholesome Audio + Dark Stick Figure Animation
### 100% Open Source / UNLICENSE Compatible

Your concept: Casual father-child audio recordings over brutally dark Metalocalypse/Venture Bros.-style stick figure animations of castle sieges and cartoon violence.

---

## The Open Source Toolchain

### Audio Processing

| Tool | License | Purpose |
|------|---------|---------|
| **[Tenacity](https://tenacityaudio.org/)** | GPL-2.0+ | Audacity fork with cleaner UI, dark theme, no telemetry |
| **[Ardour](https://ardour.org/)** | GPL-2.0 | Professional DAW if you need multitrack |
| **[FFmpeg](https://ffmpeg.org/)** | LGPL/GPL | Command-line audio conversion |

**Recommended:** Tenacity - it's Audacity without the privacy concerns, rebased on v3.7 as of late 2025.

### Animation Creation

| Tool | License | Best For |
|------|---------|----------|
| **[Synfig Studio](https://www.synfig.org/)** | GPL-3.0 | Vector animation, bone rigging, tweening |
| **[Pencil2D](https://www.pencil2d.org/)** | GPL-2.0 | Hand-drawn frame-by-frame animation |
| **[Blender (Grease Pencil)](https://www.blender.org/)** | GPL-2.0+ | 2D animation in 3D environment, most powerful |
| **[OpenToonz](https://opentoonz.github.io/)** | BSD-3-Clause | Professional 2D, used by Studio Ghibli |
| **[Glaxnimate](https://glaxnimate.mattbas.org/)** | GPL-3.0 | Vector animation, Lottie export |

**Recommended for your style:**
- **Synfig Studio** - Best for stick figures with bone rigging (animate a skeleton, not every frame)
- **Blender Grease Pencil** - Steeper curve but insanely powerful for dark/stylized looks

### Video Compositing (Audio + Animation Sync)

| Tool | License | Purpose |
|------|---------|---------|
| **[Kdenlive](https://kdenlive.org/)** | GPL-2.0+ | Full-featured editor, audio alignment tools |
| **[OpenShot](https://www.openshot.org/)** | GPL-3.0 | Simpler, good for beginners |
| **[Shotcut](https://shotcut.org/)** | GPL-3.0 | Cross-platform, hardware acceleration |
| **[Olive](https://olivevideoeditor.org/)** | GPL-3.0 | Modern UI, actively developed |

**Recommended:** Kdenlive - has "Align Audio to Reference" feature, rock solid.

### Supporting Tools

| Tool | License | Purpose |
|------|---------|---------|
| **[GIMP](https://www.gimp.org/)** | GPL-3.0 | Image editing, backgrounds, sprites |
| **[Inkscape](https://inkscape.org/)** | GPL-2.0+ | Vector graphics for stick figures |
| **[OBS Studio](https://obsproject.com/)** | GPL-2.0 | Screen recording if needed |

---

## Recommended Pipeline

### 1. Audio Prep (Tenacity)
```bash
# Install on most Linux distros
flatpak install flathub org.tenacityaudio.Tenacity

# Or build from source (UNLICENSE-friendly)
git clone https://codeberg.org/tenacityteam/tenacity.git
```

Workflow:
- Import WAV from Sony recorder
- Effect → Noise Reduction (sample noise, apply)
- Effect → Normalize to -1dB
- Trim dead air, awkward pauses
- Export as FLAC (lossless) or MP3

### 2. Create Stick Figure Assets (Inkscape → Synfig)

Build reusable stick figure SVGs in Inkscape:
```
- body.svg (torso line)
- head.svg (circle)
- limbs.svg (arm/leg segments)
- props/ (swords, catapults, castle walls)
```

Import into Synfig and rig with bones for reusable animation.

### 3. Animate Dark Scenes (Synfig Studio)
```bash
# Install
flatpak install flathub org.synfig.SynfigStudio
```

Key techniques for Metalocalypse/Venture Bros. style:
- **Dark backgrounds:** Black/dark gray rectangles, maybe blood red accents
- **Limited animation:** Don't over-animate; stylized shows use holds and snappy movements
- **Bone rigging:** Set up stick figure skeleton once, reuse across episodes
- **Tweening:** Let Synfig handle in-betweens for smooth movement

Scene ideas that contrast with wholesome audio:
- Castle walls crumbling as child talks about building blocks
- Stick figure accidentally catapulted while you discuss dinner plans
- Siege warfare during naptime discussions

### 4. Composite (Kdenlive)
```bash
# Install
flatpak install flathub org.kde.kdenlive
```

- Import animation renders (PNG sequence or video)
- Import audio from Tenacity
- Use "Align Audio to Reference" if needed
- Add sound effects (Creative Commons sources)
- Export 1080p MP4 (H.264)

### 5. Upload Script (Optional Automation)

You can use `yt-dlp` for downloading reference material and the YouTube Data API for uploads, but I'd recommend manual uploads initially to control metadata.

---

## Project Structure (For GitHub)

```
corneliuscornelius/
├── UNLICENSE
├── README.md
├── assets/
│   ├── characters/
│   │   ├── stickman-base.svg
│   │   └── stickman-rigged.sif  # Synfig file
│   ├── backgrounds/
│   │   ├── castle-dark.svg
│   │   └── siege-scene.svg
│   └── props/
│       ├── catapult.svg
│       └── sword.svg
├── episodes/
│   └── 001-tower-building/
│       ├── audio/
│       │   └── raw.wav
│       │   └── edited.flac
│       ├── animation/
│       │   └── scene.sif
│       └── export/
│           └── final.mp4
├── scripts/
│   └── render.sh  # Batch render helper
└── templates/
    └── episode-template.sif
```

---

## Quick Start

### Day 1: Setup (1-2 hours)
```bash
# Install everything via Flatpak
flatpak install flathub org.tenacityaudio.Tenacity
flatpak install flathub org.synfig.SynfigStudio
flatpak install flathub org.kde.kdenlive
flatpak install flathub org.inkscape.Inkscape
```

### Day 2: First Animation Test (2-3 hours)
1. Clean one short audio clip in Tenacity (30-60 sec)
2. Create simple stick figure in Inkscape
3. Import to Synfig, add basic movement
4. Export frames, composite in Kdenlive
5. Test upload to YouTube (unlisted)

### Day 3+: Iterate
- Build reusable character rigs
- Create background asset library
- Develop your dark visual vocabulary

---

## YouTube Channel Checklist

1. **Create Channel:** `corneliuscornelius`
2. **Monetization threshold:** 1,000 subs + 4,000 watch hours
3. **Content ID:** Your original animation = no copyright issues
4. **Description template:**
   ```
   Audio: Real conversations
   Animation: Original dark comedy stick figures
   Made with open source software (Synfig, Kdenlive, Tenacity)

   All animation assets: UNLICENSE (public domain)
   ```

---

## License Note

Since you're using UNLICENSE, your animation assets, scripts, and any code you write can be freely shared. The tools themselves have GPL licenses (which is fine - you're using them, not distributing them). Your *output* can be UNLICENSE.

Your audio recordings of your child are a separate consideration - those are personal and don't need to be open sourced.

---

## Resources

### Tutorials
- [Synfig Animation Basics](https://wiki.synfig.org/Doc:Animation_Basics)
- [Synfig Video Tutorials](https://wiki.synfig.org/Doc:Video_Tutorials)
- [Kdenlive Manual](https://docs.kdenlive.org/)
- [Pencil2D Documentation](https://www.pencil2d.org/doc/)

### Communities
- [Synfig Forums](https://forums.synfig.org/)
- [Blender Artists - Grease Pencil](https://blenderartists.org/)
- [r/animation](https://reddit.com/r/animation)

### Sound Effects (CC0/Public Domain)
- [Freesound.org](https://freesound.org/) - Filter by CC0 license
- [Sonniss GDC Audio](https://sonniss.com/gameaudiogdc) - Free yearly packs
