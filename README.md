# EmpDesignSystem

Reusable UI component library for iOS (UIKit) and macOS (AppKit).

## Installation

### Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/s-emp/EmpDesignSystem.git", from: "1.0.0")
]

// Target dependency:
.product(name: "EmpUI_iOS", package: "EmpDesignSystem")   // for iOS
.product(name: "EmpUI_macOS", package: "EmpDesignSystem")  // for macOS
```

### Tuist

```swift
// Tuist/Package.swift
.package(url: "https://github.com/s-emp/EmpDesignSystem.git", from: "1.0.0")

// Project.swift target dependency:
.external(name: "EmpUI_iOS")   // for iOS
.external(name: "EmpUI_macOS") // for macOS
```

### Xcode

File > Add Package Dependencies > `https://github.com/s-emp/EmpDesignSystem.git`

## Quick Start

```swift
import EmpUI_macOS  // or EmpUI_iOS

// Text
let label = EmpText()
label.configure(with: .init(content: .plain(.init(text: "Hello"))))

// Button
let button = EmpButton()
button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Click me"))))
button.action = { print("tapped") }

// Progress bar
let progress = EmpProgressBar()
progress.configure(with: .init(progress: 0.75, fillColor: NSColor.Semantic.actionSuccess))

// Image
let image = EmpImage()
let icon = NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil)!
image.configure(with: .init(image: icon, tintColor: NSColor.Semantic.actionPrimary, size: CGSize(width: 24, height: 24)))
```

## Components

| Component | Description | Interactive |
|-----------|-------------|-------------|
| `EmpText` | Text label (plain or attributed) | No |
| `EmpImage` | Image view with tinting | No |
| `EmpButton` | Button with styles, states, presets | Yes |
| `EmpProgressBar` | Linear progress bar (0-100%) | No |

## API Pattern

Every component follows the same pattern:

```swift
let view = EmpComponent()
view.configure(with: .init(common: CommonViewModel(...), ...))
```

- `configure(with:)` is the single public method for all configuration
- Every ViewModel has `common: CommonViewModel` as the first field
- `CommonViewModel` controls border, shadow, corners, background, and layout margins

## Semantic Colors

Use `NSColor.Semantic.*` (macOS) or `UIColor.Semantic.*` (iOS):

- **Text:** `textPrimary`, `textSecondary`, `textTertiary`, `textAccent`
- **Background:** `backgroundPrimary`, `backgroundSecondary`, `backgroundTertiary`
- **Actions:** `actionPrimary`, `actionSuccess`, `actionWarning`, `actionDanger`, `actionInfo`
- **Borders:** `borderDefault`, `borderSubtle`

## Spacing Tokens

Use `EmpSpacing` for consistent spacing: `xxs(4)`, `xs(8)`, `s(12)`, `m(16)`, `l(20)`, `xl(24)`, `xxl(32)`, `xxxl(40)`.

## Platform Differences

| Aspect | macOS | iOS |
|--------|-------|-----|
| Import | `import EmpUI_macOS` | `import EmpUI_iOS` |
| Color | `NSColor.Semantic.*` | `UIColor.Semantic.*` |
| Image | `NSImage` | `UIImage` |
| Font | `NSFont` | `UIFont` |
| Margins | `NSEdgeInsets` | `UIEdgeInsets` |

API is otherwise identical across platforms.

## API Reference

> Examples below use macOS types (`NSColor`, `NSFont`, `NSImage`, `NSEdgeInsets`).
> For iOS, substitute `UIColor`, `UIFont`, `UIImage`, `UIEdgeInsets`.

### CommonViewModel

Shared styling applied to every component via `apply(common:)`.

```swift
CommonViewModel(
    border: .init(width: 1, color: NSColor.Semantic.borderDefault, style: .solid),  // .solid | .dashed
    shadow: .init(color: .black, offset: CGSize(width: 0, height: 2), radius: 4, opacity: 0.1),
    corners: .init(radius: 8, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]),
    backgroundColor: NSColor.Semantic.backgroundSecondary,
    layoutMargins: NSEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
)
```

All fields have sensible defaults (no border, no shadow, no radius, clear bg, zero margins).

### EmpText

Text label supporting plain and attributed strings.

```swift
let text = EmpText()

// Plain text
text.configure(with: .init(
    content: .plain(.init(
        text: "Hello",
        font: .systemFont(ofSize: 14),           // default
        color: NSColor.Semantic.textPrimary       // default
    )),
    numberOfLines: 0,             // 0 = unlimited (default), 1 = single line with truncation
    alignment: .natural           // .natural (default), .center, .left, .right
))

// Attributed text
text.configure(with: .init(
    content: .attributed(NSAttributedString(string: "Styled", attributes: [...]))
))
```

### EmpImage

Image view with optional tinting.

```swift
let image = EmpImage()
image.configure(with: .init(
    image: NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil)!,
    tintColor: NSColor.Semantic.actionPrimary,    // nil = original colors (default)
    size: CGSize(width: 24, height: 24),
    contentMode: .aspectFit                       // .aspectFit (default), .aspectFill, .center
))
```

### EmpButton

Interactive button with hover/press/disabled states, 4 styles, presets.

```swift
let button = EmpButton()

// Use Preset (recommended)
button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Save"))))
button.configure(with: EmpButton.Preset.outlined(.danger, content: .init(center: .text("Delete")), size: .small))

// Content layout options
let content = EmpButton.Preset.ContentLayout(
    leading: .icon(myImage),          // optional
    center: .text("Sign In"),         // optional
    trailing: .icon(arrowImage)       // optional
)
// Also: .titleSubtitle(title: "Title", subtitle: "Subtitle")

// Styles: .filled(), .base(), .outlined(), .ghost()
// Colors: .primary, .danger
// Sizes: .small (h24), .medium (h32, default), .large (h40)

// Action & state
button.action = { print("tapped") }
button.isEnabled = false
```

### EmpProgressBar

Linear progress bar (0.0 to 1.0).

```swift
let bar = EmpProgressBar()
bar.configure(with: .init(
    progress: 0.75,                                        // 0.0-1.0, clamped
    trackColor: NSColor.Semantic.backgroundTertiary,       // default
    fillColor: NSColor.Semantic.actionPrimary,             // default
    barHeight: 4                                           // default, any CGFloat
))
```

### EmpGradient

Predefined gradient pairs for decorative use.

```swift
// Soft (step 200)
EmpGradient.Preset.lavenderToSky
EmpGradient.Preset.skyToMint
EmpGradient.Preset.peachToRose
EmpGradient.Preset.roseToLilac

// Saturated (step 300)
EmpGradient.Preset.lavenderToLilac
EmpGradient.Preset.lemonToPeach
EmpGradient.Preset.lavenderToMint
EmpGradient.Preset.skyToLavender

// Resolve for current appearance (macOS)
let (start, end) = gradient.resolvedColors(for: view.effectiveAppearance)

// Resolve for trait collection (iOS)
let (start, end) = gradient.resolvedColors(for: traitCollection)
```

### Full Semantic Color List

```
// Backgrounds
backgroundPrimary, backgroundSecondary, backgroundTertiary

// Cards (7 palettes: Lavender, Mint, Peach, Rose, Sky, Lemon, Lilac)
cardLavender, cardBorderLavender, cardMint, cardBorderMint, ...

// Borders
borderDefault, borderSubtle

// Text
textPrimary, textSecondary, textTertiary, textAccent
textPrimaryInverted, textSecondaryInverted

// Actions
actionPrimary, actionSuccess, actionWarning, actionDanger, actionInfo
actionPrimaryHover, actionDangerHover
actionPrimaryTint, actionDangerTint
actionPrimaryBase, actionPrimaryBaseHover
actionDangerBase, actionDangerBaseHover
```
