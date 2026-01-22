# corneliuscornelius Color Palette

Dark comedy aesthetic inspired by Metalocalypse and The Venture Bros.

## Core Palette

### Backgrounds

| Name | Hex | Usage |
|------|-----|-------|
| Void Black | `#050508` | Deep sky, voids |
| Night | `#0a0a10` | Primary background |
| Dark Purple-Black | `#12121a` | Background gradients |
| Blood Sky Dark | `#1a0505` | Ominous sky mid |
| Blood Sky | `#3d0a0a` | Sunset/fire-lit sky |

### Characters & Objects

| Name | Hex | Usage |
|------|-----|-------|
| Pure Black | `#0a0a0a` | Deepest shadows |
| Stick Black | `#1a1a1a` | Main stick figure lines |
| Dark Gray | `#2a2a2a` | Secondary elements |
| Mid Gray | `#3a3a3a` | Tertiary/detail |
| Stone | `#4a4a4a` | Castle walls |
| Metal | `#5a5a5a` | Weapons, armor |
| Light Stone | `#6a6a6a` | Highlighted surfaces |

### Accents

| Name | Hex | Usage |
|------|-----|-------|
| Blood Red Dark | `#3d1515` | Window glow, ominous light |
| Blood Red | `#5c1e1e` | Brighter glow |
| Fire Dark | `#8a2000` | Outer flames |
| Fire Orange | `#c03000` | Middle flames |
| Fire Bright | `#e06000` | Hot flames |
| Fire Yellow | `#ffcc00` | Hottest flames, sparks |

### Wood & Organic

| Name | Hex | Usage |
|------|-----|-------|
| Dark Wood | `#1a0a00` | Deep wood grain |
| Wood Shadow | `#2a1a0a` | Wood shadows |
| Wood | `#3d2b1f` | Main wood surfaces |
| Rope | `#5c4a3a` | Ropes, bindings |
| Light Wood | `#4a3520` | Arrow shafts |

## CSS Variables

```css
:root {
  /* Backgrounds */
  --bg-void: #050508;
  --bg-night: #0a0a10;
  --bg-blood-dark: #1a0505;
  --bg-blood: #3d0a0a;

  /* Character */
  --char-primary: #1a1a1a;
  --char-secondary: #2a2a2a;
  --char-joint: #1a1a1a;

  /* Stone/Metal */
  --stone-dark: #2a2a2a;
  --stone-mid: #3a3a3a;
  --stone-light: #4a4a4a;
  --metal: #5a5a5a;

  /* Accents */
  --glow-dark: #3d1515;
  --glow-light: #5c1e1e;
  --fire-dark: #8a2000;
  --fire-mid: #c03000;
  --fire-bright: #e06000;
  --fire-hot: #ffcc00;

  /* Wood */
  --wood-dark: #2a1a0a;
  --wood-mid: #3d2b1f;
  --wood-light: #4a3520;
}
```

## Synfig Color Codes

For use in Synfig Studio (RGBA format, 0-1 scale):

```
# Stick Figure
stick_black: 0.102 0.102 0.102 1.0

# Background Night
bg_night: 0.039 0.039 0.063 1.0

# Blood Sky
blood_sky: 0.239 0.039 0.039 1.0

# Fire Orange
fire_orange: 0.753 0.188 0.000 1.0

# Fire Yellow
fire_yellow: 1.000 0.800 0.000 1.0
```

## Design Principles

1. **High contrast** - Black figures against dark (not black) backgrounds
2. **Limited palette** - Mostly grayscale with red/orange accents
3. **Glow, don't highlight** - Use colored glows for light sources, not white
4. **Blood red = danger** - Reserve red tones for ominous/violent moments
5. **Fire = action** - Orange/yellow only for flames and explosions
