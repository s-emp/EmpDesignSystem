# Color Palette Design

## Overview

Base color palette for EmpDesignSystem with two layers: primitive tokens (base colors) and semantic tokens. Supports light and dark themes via native dynamic colors. Soft pastel aesthetic inspired by VoiceInk.

## Base Colors (Primitives)

8 color groups, 5 steps each (50, 100, 200, 300, 500).

### Lavender (purple-blue)

| Step | Light | Dark |
|------|-------|------|
| 50 | #F0F1FF | #1E1F32 |
| 100 | #E2E3FF | #2A2C48 |
| 200 | #C9C8FD | #3F4170 |
| 300 | #9B97F5 | #7D79DB |
| 500 | #6C63FF | #8B84FF |

### Mint (green)

| Step | Light | Dark |
|------|-------|------|
| 50 | #EDFCF8 | #192E28 |
| 100 | #D4F5EA | #223E34 |
| 200 | #B0ECDA | #2E5A4C |
| 300 | #6DD4BC | #52BEA4 |
| 500 | #2FB894 | #3ED4AE |

### Peach (warm orange)

| Step | Light | Dark |
|------|-------|------|
| 50 | #FFF7EC | #2E2519 |
| 100 | #FFECD3 | #3E3223 |
| 200 | #FFDBB4 | #5C482F |
| 300 | #F5B078 | #D49560 |
| 500 | #F08C42 | #F5A05A |

### Rose (pink)

| Step | Light | Dark |
|------|-------|------|
| 50 | #FFF0F1 | #2E191E |
| 100 | #FFDEE2 | #3E2328 |
| 200 | #FFC8CF | #5C303B |
| 300 | #F58C99 | #D86E7C |
| 500 | #E85468 | #F07080 |

### Sky (blue)

| Step | Light | Dark |
|------|-------|------|
| 50 | #EDF6FF | #192535 |
| 100 | #DAEDFF | #22334C |
| 200 | #B5DCFF | #2E4A6E |
| 300 | #70BCF5 | #58A8DB |
| 500 | #3698F0 | #4EB0F5 |

### Lemon (yellow)

| Step | Light | Dark |
|------|-------|------|
| 50 | #FFFCEB | #2E2A17 |
| 100 | #FFF5CC | #3E3820 |
| 200 | #FFEBA5 | #5C4F2C |
| 300 | #F5D160 | #D4B648 |
| 500 | #E8B420 | #F0C838 |

### Lilac (pink-purple)

| Step | Light | Dark |
|------|-------|------|
| 50 | #F8F0FF | #26192E |
| 100 | #EEDDFF | #33233E |
| 200 | #DFC6FF | #48305C |
| 300 | #BE8AF5 | #A86ED8 |
| 500 | #9C52E0 | #B56EF5 |

### Neutral (Tailwind Neutral — pure gray)

| Step | Light | Dark |
|------|-------|------|
| 50 | #fafafa | #171717 |
| 100 | #f5f5f5 | #262626 |
| 200 | #e5e5e5 | #404040 |
| 300 | #d4d4d4 | #525252 |
| 500 | #737373 | #a3a3a3 |

Additional neutral steps for text/backgrounds:

| Step | Light | Dark |
|------|-------|------|
| 700 | #404040 | #d4d4d4 |
| 900 | #171717 | #fafafa |

## Semantic Tokens

Semantic tokens reference base colors. Components use only semantic tokens.

### Backgrounds

| Token | Maps to |
|-------|---------|
| `backgroundPrimary` | white / #0a0a0a |
| `backgroundSecondary` | neutral.50 |
| `backgroundTertiary` | neutral.100 |

### Cards (background + border for each hue)

| Token | Background | Border |
|-------|-----------|--------|
| `cardLavender` / `cardBorderLavender` | lavender.50 | lavender.200 |
| `cardMint` / `cardBorderMint` | mint.50 | mint.200 |
| `cardPeach` / `cardBorderPeach` | peach.50 | peach.200 |
| `cardRose` / `cardBorderRose` | rose.50 | rose.200 |
| `cardSky` / `cardBorderSky` | sky.50 | sky.200 |
| `cardLemon` / `cardBorderLemon` | lemon.50 | lemon.200 |
| `cardLilac` / `cardBorderLilac` | lilac.50 | lilac.200 |

### Borders

| Token | Maps to |
|-------|---------|
| `borderDefault` | neutral.200 |
| `borderSubtle` | neutral.100 |

### Text

| Token | Maps to |
|-------|---------|
| `textPrimary` | neutral.900 |
| `textSecondary` | neutral.500 |
| `textTertiary` | neutral.300 |
| `textAccent` | lavender.500 |

### Actions

| Token | Maps to | Purpose |
|-------|---------|---------|
| `actionPrimary` | lavender.500 | Primary buttons |
| `actionSuccess` | mint.500 | Success |
| `actionWarning` | peach.500 | Warning |
| `actionDanger` | rose.500 | Danger |
| `actionInfo` | sky.500 | Info |

## Gradient Presets

Gradients reference dynamic base colors — automatically support light/dark themes.

### Soft (step 200) — for backgrounds and cards

| Name | From | To |
|------|------|-----|
| `lavenderToSky` | lavender.200 | sky.200 |
| `skyToMint` | sky.200 | mint.200 |
| `peachToRose` | peach.200 | rose.200 |
| `roseToLilac` | rose.200 | lilac.200 |

### Saturated (step 300) — for accents

| Name | From | To |
|------|------|-----|
| `lavenderToLilac` | lavender.300 | lilac.300 |
| `lemonToPeach` | lemon.300 | peach.300 |
| `lavenderToMint` | lavender.300 | mint.300 |
| `skyToLavender` | sky.300 | lavender.300 |

## Architecture

### Namespacing via enum

```swift
// iOS
extension UIColor {
    enum Base {
        static let lavender50 = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0.12, green: 0.12, blue: 0.20, alpha: 1)
                : UIColor(red: 0.94, green: 0.95, blue: 1.00, alpha: 1)
        }
    }
    enum Semantic {
        static let cardLavender = Base.lavender50
        static let textPrimary = Base.neutral900
    }
}

// macOS
extension NSColor {
    enum Base {
        static let lavender50 = NSColor(name: "empLavender50") { appearance in
            appearance.isDark
                ? NSColor(red: 0.12, green: 0.12, blue: 0.20, alpha: 1)
                : NSColor(red: 0.94, green: 0.95, blue: 1.00, alpha: 1)
        }
    }
    enum Semantic {
        static let cardLavender = Base.lavender50
    }
}
```

### Gradient struct

```swift
public struct EmpGradient: Equatable {
    public let startColor: UIColor  // NSColor on macOS
    public let endColor: UIColor

    public func resolvedColors(for traitCollection: UITraitCollection) -> (CGColor, CGColor) {
        (startColor.resolvedColor(with: traitCollection).cgColor,
         endColor.resolvedColor(with: traitCollection).cgColor)
    }

    enum Preset {
        static let lavenderToSky = EmpGradient(
            startColor: UIColor.Base.lavender200,
            endColor: UIColor.Base.sky200
        )
    }
}
```

### File organization

```
EmpUI_iOS/Sources/Common/Colors/
    UIColor+Base+Lavender.swift
    UIColor+Base+Mint.swift
    UIColor+Base+Peach.swift
    UIColor+Base+Rose.swift
    UIColor+Base+Sky.swift
    UIColor+Base+Lemon.swift
    UIColor+Base+Lilac.swift
    UIColor+Base+Neutral.swift
    UIColor+Semantic.swift
    EmpGradient.swift
    EmpGradient+Preset.swift

EmpUI_macOS/Sources/Common/Colors/
    NSColor+Base+Lavender.swift
    NSColor+Base+Mint.swift
    NSColor+Base+Peach.swift
    NSColor+Base+Rose.swift
    NSColor+Base+Sky.swift
    NSColor+Base+Lemon.swift
    NSColor+Base+Lilac.swift
    NSColor+Base+Neutral.swift
    NSColor+Semantic.swift
    EmpGradient.swift
    EmpGradient+Preset.swift
```

## Dark Mode

- iOS: `UIColor { traitCollection in ... }` — resolves automatically
- macOS: `NSColor(name:) { appearance in ... }` — resolves automatically
- Gradients: store dynamic UIColor/NSColor references, resolve via `resolvedColor(with:)` when applying to CAGradientLayer
- Step 50 in dark = very dark with slight hue tint; step 500 in dark = slightly adjusted bright

## Visual Preview

Interactive HTML preview with all colors, semantic tokens, gradients, and theme toggle: `docs/color-palette-preview.html`
