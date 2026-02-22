# Color Palette Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement a two-layer color system (base primitives + semantic tokens) with light/dark theme support and gradient presets for both iOS and macOS.

**Architecture:** Static properties on `UIColor.Base`/`NSColor.Base` enums for primitives, `UIColor.Semantic`/`NSColor.Semantic` for semantic tokens. Dynamic colors via `UIColor(dynamicProvider:)` (iOS) and `NSColor(name:dynamicProvider:)` (macOS). `EmpGradient` struct with presets referencing dynamic base colors.

**Tech Stack:** Swift, UIKit (iOS), AppKit (macOS), Swift Testing

**Design doc:** `docs/plans/2026-02-22-color-palette-design.md`

---

### Task 1: Create branch and directory structure

**Step 1: Create branch from master**

```bash
cd "/Users/emp15/Developer/EmpDesignSystem 2"
git checkout master
git checkout -b feature/color-palette
```

**Step 2: Create directories**

```bash
mkdir -p "EmpUI_iOS/Sources/Common/Colors"
mkdir -p "EmpUI_macOS/Sources/Common/Colors"
```

**Step 3: Verify**

```bash
git branch --show-current
```
Expected: `feature/color-palette`

---

### Task 2: iOS — Hex helper + Base enum + Lavender (TDD)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/Colors/UIColor+Hex.swift`
- Create: `EmpUI_iOS/Sources/Common/Colors/UIColor+Base.swift`
- Create: `EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Lavender.swift`
- Create: `EmpUI_iOS/Tests/BaseColorTests.swift`

**Step 1: Write the test file**

```swift
// EmpUI_iOS/Tests/BaseColorTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

// MARK: - Helper

private func resolvedHex(_ color: UIColor, style: UIUserInterfaceStyle) -> UInt32 {
    let traits = UITraitCollection(userInterfaceStyle: style)
    let resolved = color.resolvedColor(with: traits)
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    resolved.getRed(&r, green: &g, blue: &b, alpha: &a)
    return (UInt32(round(r * 255)) << 16) | (UInt32(round(g * 255)) << 8) | UInt32(round(b * 255))
}

// MARK: - Lavender

@Suite("UIColor.Base — Lavender")
struct BaseLavenderTests {

    @Test("Lavender light mode")
    func lavenderLight() {
        #expect(resolvedHex(UIColor.Base.lavender50, style: .light) == 0xF0F1FF)
        #expect(resolvedHex(UIColor.Base.lavender100, style: .light) == 0xE2E3FF)
        #expect(resolvedHex(UIColor.Base.lavender200, style: .light) == 0xC9C8FD)
        #expect(resolvedHex(UIColor.Base.lavender300, style: .light) == 0x9B97F5)
        #expect(resolvedHex(UIColor.Base.lavender500, style: .light) == 0x6C63FF)
    }

    @Test("Lavender dark mode")
    func lavenderDark() {
        #expect(resolvedHex(UIColor.Base.lavender50, style: .dark) == 0x1E1F32)
        #expect(resolvedHex(UIColor.Base.lavender100, style: .dark) == 0x2A2C48)
        #expect(resolvedHex(UIColor.Base.lavender200, style: .dark) == 0x3F4170)
        #expect(resolvedHex(UIColor.Base.lavender300, style: .dark) == 0x7D79DB)
        #expect(resolvedHex(UIColor.Base.lavender500, style: .dark) == 0x8B84FF)
    }
}
```

**Step 2: Create minimal production code to compile**

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Hex.swift
import UIKit

extension UIColor {

    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base.swift
import UIKit

public extension UIColor {

    enum Base {}
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Lavender.swift
import UIKit

public extension UIColor.Base {

    static let lavender50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x1E1F32) : UIColor(hex: 0xF0F1FF) }
    static let lavender100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2A2C48) : UIColor(hex: 0xE2E3FF) }
    static let lavender200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3F4170) : UIColor(hex: 0xC9C8FD) }
    static let lavender300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x7D79DB) : UIColor(hex: 0x9B97F5) }
    static let lavender500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x8B84FF) : UIColor(hex: 0x6C63FF) }
}
```

**Step 3: Generate and test**

```bash
mise exec -- tuist generate --no-open
mise exec -- tuist test EmpUI_iOS
```
Expected: All tests pass including new Lavender tests.

---

### Task 3: iOS — Remaining base colors (Mint through Neutral)

**Files to create:** One file per hue, plus add tests to `BaseColorTests.swift`.

**Step 1: Add tests for all remaining hues to `BaseColorTests.swift`**

Append these suites after `BaseLavenderTests`:

```swift
// MARK: - Mint

@Suite("UIColor.Base — Mint")
struct BaseMintTests {

    @Test("Mint light mode")
    func mintLight() {
        #expect(resolvedHex(UIColor.Base.mint50, style: .light) == 0xEDFCF8)
        #expect(resolvedHex(UIColor.Base.mint100, style: .light) == 0xD4F5EA)
        #expect(resolvedHex(UIColor.Base.mint200, style: .light) == 0xB0ECDA)
        #expect(resolvedHex(UIColor.Base.mint300, style: .light) == 0x6DD4BC)
        #expect(resolvedHex(UIColor.Base.mint500, style: .light) == 0x2FB894)
    }

    @Test("Mint dark mode")
    func mintDark() {
        #expect(resolvedHex(UIColor.Base.mint50, style: .dark) == 0x192E28)
        #expect(resolvedHex(UIColor.Base.mint100, style: .dark) == 0x223E34)
        #expect(resolvedHex(UIColor.Base.mint200, style: .dark) == 0x2E5A4C)
        #expect(resolvedHex(UIColor.Base.mint300, style: .dark) == 0x52BEA4)
        #expect(resolvedHex(UIColor.Base.mint500, style: .dark) == 0x3ED4AE)
    }
}

// MARK: - Peach

@Suite("UIColor.Base — Peach")
struct BasePeachTests {

    @Test("Peach light mode")
    func peachLight() {
        #expect(resolvedHex(UIColor.Base.peach50, style: .light) == 0xFFF7EC)
        #expect(resolvedHex(UIColor.Base.peach100, style: .light) == 0xFFECD3)
        #expect(resolvedHex(UIColor.Base.peach200, style: .light) == 0xFFDBB4)
        #expect(resolvedHex(UIColor.Base.peach300, style: .light) == 0xF5B078)
        #expect(resolvedHex(UIColor.Base.peach500, style: .light) == 0xF08C42)
    }

    @Test("Peach dark mode")
    func peachDark() {
        #expect(resolvedHex(UIColor.Base.peach50, style: .dark) == 0x2E2519)
        #expect(resolvedHex(UIColor.Base.peach100, style: .dark) == 0x3E3223)
        #expect(resolvedHex(UIColor.Base.peach200, style: .dark) == 0x5C482F)
        #expect(resolvedHex(UIColor.Base.peach300, style: .dark) == 0xD49560)
        #expect(resolvedHex(UIColor.Base.peach500, style: .dark) == 0xF5A05A)
    }
}

// MARK: - Rose

@Suite("UIColor.Base — Rose")
struct BaseRoseTests {

    @Test("Rose light mode")
    func roseLight() {
        #expect(resolvedHex(UIColor.Base.rose50, style: .light) == 0xFFF0F1)
        #expect(resolvedHex(UIColor.Base.rose100, style: .light) == 0xFFDEE2)
        #expect(resolvedHex(UIColor.Base.rose200, style: .light) == 0xFFC8CF)
        #expect(resolvedHex(UIColor.Base.rose300, style: .light) == 0xF58C99)
        #expect(resolvedHex(UIColor.Base.rose500, style: .light) == 0xE85468)
    }

    @Test("Rose dark mode")
    func roseDark() {
        #expect(resolvedHex(UIColor.Base.rose50, style: .dark) == 0x2E191E)
        #expect(resolvedHex(UIColor.Base.rose100, style: .dark) == 0x3E2328)
        #expect(resolvedHex(UIColor.Base.rose200, style: .dark) == 0x5C303B)
        #expect(resolvedHex(UIColor.Base.rose300, style: .dark) == 0xD86E7C)
        #expect(resolvedHex(UIColor.Base.rose500, style: .dark) == 0xF07080)
    }
}

// MARK: - Sky

@Suite("UIColor.Base — Sky")
struct BaseSkyTests {

    @Test("Sky light mode")
    func skyLight() {
        #expect(resolvedHex(UIColor.Base.sky50, style: .light) == 0xEDF6FF)
        #expect(resolvedHex(UIColor.Base.sky100, style: .light) == 0xDAEDFF)
        #expect(resolvedHex(UIColor.Base.sky200, style: .light) == 0xB5DCFF)
        #expect(resolvedHex(UIColor.Base.sky300, style: .light) == 0x70BCF5)
        #expect(resolvedHex(UIColor.Base.sky500, style: .light) == 0x3698F0)
    }

    @Test("Sky dark mode")
    func skyDark() {
        #expect(resolvedHex(UIColor.Base.sky50, style: .dark) == 0x192535)
        #expect(resolvedHex(UIColor.Base.sky100, style: .dark) == 0x22334C)
        #expect(resolvedHex(UIColor.Base.sky200, style: .dark) == 0x2E4A6E)
        #expect(resolvedHex(UIColor.Base.sky300, style: .dark) == 0x58A8DB)
        #expect(resolvedHex(UIColor.Base.sky500, style: .dark) == 0x4EB0F5)
    }
}

// MARK: - Lemon

@Suite("UIColor.Base — Lemon")
struct BaseLemonTests {

    @Test("Lemon light mode")
    func lemonLight() {
        #expect(resolvedHex(UIColor.Base.lemon50, style: .light) == 0xFFFCEB)
        #expect(resolvedHex(UIColor.Base.lemon100, style: .light) == 0xFFF5CC)
        #expect(resolvedHex(UIColor.Base.lemon200, style: .light) == 0xFFEBA5)
        #expect(resolvedHex(UIColor.Base.lemon300, style: .light) == 0xF5D160)
        #expect(resolvedHex(UIColor.Base.lemon500, style: .light) == 0xE8B420)
    }

    @Test("Lemon dark mode")
    func lemonDark() {
        #expect(resolvedHex(UIColor.Base.lemon50, style: .dark) == 0x2E2A17)
        #expect(resolvedHex(UIColor.Base.lemon100, style: .dark) == 0x3E3820)
        #expect(resolvedHex(UIColor.Base.lemon200, style: .dark) == 0x5C4F2C)
        #expect(resolvedHex(UIColor.Base.lemon300, style: .dark) == 0xD4B648)
        #expect(resolvedHex(UIColor.Base.lemon500, style: .dark) == 0xF0C838)
    }
}

// MARK: - Lilac

@Suite("UIColor.Base — Lilac")
struct BaseLilacTests {

    @Test("Lilac light mode")
    func lilacLight() {
        #expect(resolvedHex(UIColor.Base.lilac50, style: .light) == 0xF8F0FF)
        #expect(resolvedHex(UIColor.Base.lilac100, style: .light) == 0xEEDDFF)
        #expect(resolvedHex(UIColor.Base.lilac200, style: .light) == 0xDFC6FF)
        #expect(resolvedHex(UIColor.Base.lilac300, style: .light) == 0xBE8AF5)
        #expect(resolvedHex(UIColor.Base.lilac500, style: .light) == 0x9C52E0)
    }

    @Test("Lilac dark mode")
    func lilacDark() {
        #expect(resolvedHex(UIColor.Base.lilac50, style: .dark) == 0x26192E)
        #expect(resolvedHex(UIColor.Base.lilac100, style: .dark) == 0x33233E)
        #expect(resolvedHex(UIColor.Base.lilac200, style: .dark) == 0x48305C)
        #expect(resolvedHex(UIColor.Base.lilac300, style: .dark) == 0xA86ED8)
        #expect(resolvedHex(UIColor.Base.lilac500, style: .dark) == 0xB56EF5)
    }
}

// MARK: - Neutral

@Suite("UIColor.Base — Neutral")
struct BaseNeutralTests {

    @Test("Neutral light mode")
    func neutralLight() {
        #expect(resolvedHex(UIColor.Base.neutral50, style: .light) == 0xFAFAFA)
        #expect(resolvedHex(UIColor.Base.neutral100, style: .light) == 0xF5F5F5)
        #expect(resolvedHex(UIColor.Base.neutral200, style: .light) == 0xE5E5E5)
        #expect(resolvedHex(UIColor.Base.neutral300, style: .light) == 0xD4D4D4)
        #expect(resolvedHex(UIColor.Base.neutral500, style: .light) == 0x737373)
        #expect(resolvedHex(UIColor.Base.neutral700, style: .light) == 0x404040)
        #expect(resolvedHex(UIColor.Base.neutral900, style: .light) == 0x171717)
    }

    @Test("Neutral dark mode")
    func neutralDark() {
        #expect(resolvedHex(UIColor.Base.neutral50, style: .dark) == 0x171717)
        #expect(resolvedHex(UIColor.Base.neutral100, style: .dark) == 0x262626)
        #expect(resolvedHex(UIColor.Base.neutral200, style: .dark) == 0x404040)
        #expect(resolvedHex(UIColor.Base.neutral300, style: .dark) == 0x525252)
        #expect(resolvedHex(UIColor.Base.neutral500, style: .dark) == 0xA3A3A3)
        #expect(resolvedHex(UIColor.Base.neutral700, style: .dark) == 0xD4D4D4)
        #expect(resolvedHex(UIColor.Base.neutral900, style: .dark) == 0xFAFAFA)
    }
}
```

**Step 2: Create all hue files**

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Mint.swift
import UIKit

public extension UIColor.Base {

    static let mint50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x192E28) : UIColor(hex: 0xEDFCF8) }
    static let mint100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x223E34) : UIColor(hex: 0xD4F5EA) }
    static let mint200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E5A4C) : UIColor(hex: 0xB0ECDA) }
    static let mint300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x52BEA4) : UIColor(hex: 0x6DD4BC) }
    static let mint500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3ED4AE) : UIColor(hex: 0x2FB894) }
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Peach.swift
import UIKit

public extension UIColor.Base {

    static let peach50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E2519) : UIColor(hex: 0xFFF7EC) }
    static let peach100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3E3223) : UIColor(hex: 0xFFECD3) }
    static let peach200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x5C482F) : UIColor(hex: 0xFFDBB4) }
    static let peach300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xD49560) : UIColor(hex: 0xF5B078) }
    static let peach500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xF5A05A) : UIColor(hex: 0xF08C42) }
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Rose.swift
import UIKit

public extension UIColor.Base {

    static let rose50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E191E) : UIColor(hex: 0xFFF0F1) }
    static let rose100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3E2328) : UIColor(hex: 0xFFDEE2) }
    static let rose200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x5C303B) : UIColor(hex: 0xFFC8CF) }
    static let rose300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xD86E7C) : UIColor(hex: 0xF58C99) }
    static let rose500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xF07080) : UIColor(hex: 0xE85468) }
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Sky.swift
import UIKit

public extension UIColor.Base {

    static let sky50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x192535) : UIColor(hex: 0xEDF6FF) }
    static let sky100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x22334C) : UIColor(hex: 0xDAEDFF) }
    static let sky200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E4A6E) : UIColor(hex: 0xB5DCFF) }
    static let sky300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x58A8DB) : UIColor(hex: 0x70BCF5) }
    static let sky500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x4EB0F5) : UIColor(hex: 0x3698F0) }
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Lemon.swift
import UIKit

public extension UIColor.Base {

    static let lemon50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E2A17) : UIColor(hex: 0xFFFCEB) }
    static let lemon100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3E3820) : UIColor(hex: 0xFFF5CC) }
    static let lemon200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x5C4F2C) : UIColor(hex: 0xFFEBA5) }
    static let lemon300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xD4B648) : UIColor(hex: 0xF5D160) }
    static let lemon500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xF0C838) : UIColor(hex: 0xE8B420) }
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Lilac.swift
import UIKit

public extension UIColor.Base {

    static let lilac50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x26192E) : UIColor(hex: 0xF8F0FF) }
    static let lilac100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x33233E) : UIColor(hex: 0xEEDDFF) }
    static let lilac200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x48305C) : UIColor(hex: 0xDFC6FF) }
    static let lilac300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xA86ED8) : UIColor(hex: 0xBE8AF5) }
    static let lilac500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xB56EF5) : UIColor(hex: 0x9C52E0) }
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Base+Neutral.swift
import UIKit

public extension UIColor.Base {

    static let neutral50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x171717) : UIColor(hex: 0xFAFAFA) }
    static let neutral100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x262626) : UIColor(hex: 0xF5F5F5) }
    static let neutral200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x404040) : UIColor(hex: 0xE5E5E5) }
    static let neutral300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x525252) : UIColor(hex: 0xD4D4D4) }
    static let neutral500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xA3A3A3) : UIColor(hex: 0x737373) }
    static let neutral700 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xD4D4D4) : UIColor(hex: 0x404040) }
    static let neutral900 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xFAFAFA) : UIColor(hex: 0x171717) }
}
```

**Step 3: Generate and test**

```bash
mise exec -- tuist generate --no-open
mise exec -- tuist test EmpUI_iOS
```
Expected: All base color tests pass.

---

### Task 4: iOS — Semantic tokens (TDD)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/Colors/UIColor+Semantic.swift`
- Create: `EmpUI_iOS/Tests/SemanticColorTests.swift`

**Step 1: Write tests**

```swift
// EmpUI_iOS/Tests/SemanticColorTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

private func resolvedHex(_ color: UIColor, style: UIUserInterfaceStyle) -> UInt32 {
    let traits = UITraitCollection(userInterfaceStyle: style)
    let resolved = color.resolvedColor(with: traits)
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    resolved.getRed(&r, green: &g, blue: &b, alpha: &a)
    return (UInt32(round(r * 255)) << 16) | (UInt32(round(g * 255)) << 8) | UInt32(round(b * 255))
}

@Suite("UIColor.Semantic")
struct SemanticColorTests {

    // MARK: - Backgrounds

    @Test("backgroundPrimary — white/dark")
    func backgroundPrimary() {
        #expect(resolvedHex(UIColor.Semantic.backgroundPrimary, style: .light) == 0xFFFFFF)
        #expect(resolvedHex(UIColor.Semantic.backgroundPrimary, style: .dark) == 0x0A0A0A)
    }

    @Test("backgroundSecondary ссылается на neutral50")
    func backgroundSecondary() {
        #expect(UIColor.Semantic.backgroundSecondary === UIColor.Base.neutral50)
    }

    @Test("backgroundTertiary ссылается на neutral100")
    func backgroundTertiary() {
        #expect(UIColor.Semantic.backgroundTertiary === UIColor.Base.neutral100)
    }

    // MARK: - Cards

    @Test("cardLavender ссылается на lavender50")
    func cardLavender() { #expect(UIColor.Semantic.cardLavender === UIColor.Base.lavender50) }

    @Test("cardBorderLavender ссылается на lavender200")
    func cardBorderLavender() { #expect(UIColor.Semantic.cardBorderLavender === UIColor.Base.lavender200) }

    // MARK: - Text

    @Test("textPrimary ссылается на neutral900")
    func textPrimary() { #expect(UIColor.Semantic.textPrimary === UIColor.Base.neutral900) }

    @Test("textSecondary ссылается на neutral500")
    func textSecondary() { #expect(UIColor.Semantic.textSecondary === UIColor.Base.neutral500) }

    @Test("textAccent ссылается на lavender500")
    func textAccent() { #expect(UIColor.Semantic.textAccent === UIColor.Base.lavender500) }

    // MARK: - Actions

    @Test("actionPrimary ссылается на lavender500")
    func actionPrimary() { #expect(UIColor.Semantic.actionPrimary === UIColor.Base.lavender500) }

    @Test("actionSuccess ссылается на mint500")
    func actionSuccess() { #expect(UIColor.Semantic.actionSuccess === UIColor.Base.mint500) }

    @Test("actionDanger ссылается на rose500")
    func actionDanger() { #expect(UIColor.Semantic.actionDanger === UIColor.Base.rose500) }
}
```

**Step 2: Create semantic tokens**

```swift
// EmpUI_iOS/Sources/Common/Colors/UIColor+Semantic.swift
import UIKit

public extension UIColor {

    enum Semantic {}
}

public extension UIColor.Semantic {

    // MARK: - Backgrounds

    static let backgroundPrimary = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x0A0A0A) : .white }
    static let backgroundSecondary = UIColor.Base.neutral50
    static let backgroundTertiary = UIColor.Base.neutral100

    // MARK: - Cards

    static let cardLavender = UIColor.Base.lavender50
    static let cardBorderLavender = UIColor.Base.lavender200
    static let cardMint = UIColor.Base.mint50
    static let cardBorderMint = UIColor.Base.mint200
    static let cardPeach = UIColor.Base.peach50
    static let cardBorderPeach = UIColor.Base.peach200
    static let cardRose = UIColor.Base.rose50
    static let cardBorderRose = UIColor.Base.rose200
    static let cardSky = UIColor.Base.sky50
    static let cardBorderSky = UIColor.Base.sky200
    static let cardLemon = UIColor.Base.lemon50
    static let cardBorderLemon = UIColor.Base.lemon200
    static let cardLilac = UIColor.Base.lilac50
    static let cardBorderLilac = UIColor.Base.lilac200

    // MARK: - Borders

    static let borderDefault = UIColor.Base.neutral200
    static let borderSubtle = UIColor.Base.neutral100

    // MARK: - Text

    static let textPrimary = UIColor.Base.neutral900
    static let textSecondary = UIColor.Base.neutral500
    static let textTertiary = UIColor.Base.neutral300
    static let textAccent = UIColor.Base.lavender500

    // MARK: - Actions

    static let actionPrimary = UIColor.Base.lavender500
    static let actionSuccess = UIColor.Base.mint500
    static let actionWarning = UIColor.Base.peach500
    static let actionDanger = UIColor.Base.rose500
    static let actionInfo = UIColor.Base.sky500
}
```

**Step 3: Generate and test**

```bash
mise exec -- tuist generate --no-open
mise exec -- tuist test EmpUI_iOS
```

---

### Task 5: iOS — EmpGradient + presets (TDD)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/Colors/EmpGradient.swift`
- Create: `EmpUI_iOS/Sources/Common/Colors/EmpGradient+Preset.swift`
- Create: `EmpUI_iOS/Tests/EmpGradientTests.swift`

**Step 1: Write tests**

```swift
// EmpUI_iOS/Tests/EmpGradientTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("EmpGradient")
struct EmpGradientTests {

    @Test("Инициализация сохраняет цвета")
    func initStoresColors() {
        let start = UIColor.Base.lavender200
        let end = UIColor.Base.sky200
        let gradient = EmpGradient(startColor: start, endColor: end)
        #expect(gradient.startColor === start)
        #expect(gradient.endColor === end)
    }

    @Test("Equatable — одинаковые градиенты равны")
    func equatable() {
        let a = EmpGradient.Preset.lavenderToSky
        let b = EmpGradient.Preset.lavenderToSky
        #expect(a == b)
    }

    @Test("resolvedColors возвращает CGColor для light mode")
    func resolvedColorsLight() {
        let gradient = EmpGradient.Preset.lavenderToSky
        let traits = UITraitCollection(userInterfaceStyle: .light)
        let (start, end) = gradient.resolvedColors(for: traits)
        #expect(start.numberOfComponents >= 3)
        #expect(end.numberOfComponents >= 3)
    }

    @Test("Пресет lavenderToSky использует правильные базовые цвета")
    func presetLavenderToSky() {
        let preset = EmpGradient.Preset.lavenderToSky
        #expect(preset.startColor === UIColor.Base.lavender200)
        #expect(preset.endColor === UIColor.Base.sky200)
    }
}
```

**Step 2: Create implementation**

```swift
// EmpUI_iOS/Sources/Common/Colors/EmpGradient.swift
import UIKit

public struct EmpGradient: Equatable {

    public let startColor: UIColor
    public let endColor: UIColor

    public init(startColor: UIColor, endColor: UIColor) {
        self.startColor = startColor
        self.endColor = endColor
    }

    public func resolvedColors(for traitCollection: UITraitCollection) -> (start: CGColor, end: CGColor) {
        (startColor.resolvedColor(with: traitCollection).cgColor,
         endColor.resolvedColor(with: traitCollection).cgColor)
    }
}
```

```swift
// EmpUI_iOS/Sources/Common/Colors/EmpGradient+Preset.swift
import UIKit

extension EmpGradient {

    public enum Preset {

        // MARK: - Soft (step 200)

        public static let lavenderToSky = EmpGradient(startColor: UIColor.Base.lavender200, endColor: UIColor.Base.sky200)
        public static let skyToMint = EmpGradient(startColor: UIColor.Base.sky200, endColor: UIColor.Base.mint200)
        public static let peachToRose = EmpGradient(startColor: UIColor.Base.peach200, endColor: UIColor.Base.rose200)
        public static let roseToLilac = EmpGradient(startColor: UIColor.Base.rose200, endColor: UIColor.Base.lilac200)

        // MARK: - Saturated (step 300)

        public static let lavenderToLilac = EmpGradient(startColor: UIColor.Base.lavender300, endColor: UIColor.Base.lilac300)
        public static let lemonToPeach = EmpGradient(startColor: UIColor.Base.lemon300, endColor: UIColor.Base.peach300)
        public static let lavenderToMint = EmpGradient(startColor: UIColor.Base.lavender300, endColor: UIColor.Base.mint300)
        public static let skyToLavender = EmpGradient(startColor: UIColor.Base.sky300, endColor: UIColor.Base.lavender300)
    }
}
```

**Step 3: Generate and test**

```bash
mise exec -- tuist generate --no-open
mise exec -- tuist test EmpUI_iOS
```

---

### Task 6: macOS — NSAppearance helper + hex helper + Base enum + all hues (TDD)

**Files:**
- Create: `EmpUI_macOS/Sources/Common/Colors/NSAppearance+isDark.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Hex.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Lavender.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Mint.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Peach.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Rose.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Sky.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Lemon.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Lilac.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Neutral.swift`
- Create: `EmpUI_macOS/Tests/BaseColorTests.swift`

**Step 1: Write tests**

```swift
// EmpUI_macOS/Tests/BaseColorTests.swift
import AppKit
import Testing
@testable import EmpUI_macOS

// MARK: - Helper

private func resolvedHex(_ color: NSColor, dark: Bool) -> UInt32 {
    let saved = NSAppearance.current
    NSAppearance.current = NSAppearance(named: dark ? .darkAqua : .aqua)!
    defer { NSAppearance.current = saved }

    let resolved = color.usingColorSpace(.sRGB)!
    let r = UInt32(round(resolved.redComponent * 255))
    let g = UInt32(round(resolved.greenComponent * 255))
    let b = UInt32(round(resolved.blueComponent * 255))
    return (r << 16) | (g << 8) | b
}

// MARK: - NSAppearance+isDark

@Suite("NSAppearance+isDark")
struct NSAppearanceIsDarkTests {

    @Test("aqua — не dark")
    func aquaIsNotDark() {
        let appearance = NSAppearance(named: .aqua)!
        #expect(!appearance.isDark)
    }

    @Test("darkAqua — dark")
    func darkAquaIsDark() {
        let appearance = NSAppearance(named: .darkAqua)!
        #expect(appearance.isDark)
    }
}

// MARK: - Lavender

@Suite("NSColor.Base — Lavender")
struct BaseLavenderTests {

    @Test("Lavender light mode")
    func lavenderLight() {
        #expect(resolvedHex(NSColor.Base.lavender50, dark: false) == 0xF0F1FF)
        #expect(resolvedHex(NSColor.Base.lavender100, dark: false) == 0xE2E3FF)
        #expect(resolvedHex(NSColor.Base.lavender200, dark: false) == 0xC9C8FD)
        #expect(resolvedHex(NSColor.Base.lavender300, dark: false) == 0x9B97F5)
        #expect(resolvedHex(NSColor.Base.lavender500, dark: false) == 0x6C63FF)
    }

    @Test("Lavender dark mode")
    func lavenderDark() {
        #expect(resolvedHex(NSColor.Base.lavender50, dark: true) == 0x1E1F32)
        #expect(resolvedHex(NSColor.Base.lavender100, dark: true) == 0x2A2C48)
        #expect(resolvedHex(NSColor.Base.lavender200, dark: true) == 0x3F4170)
        #expect(resolvedHex(NSColor.Base.lavender300, dark: true) == 0x7D79DB)
        #expect(resolvedHex(NSColor.Base.lavender500, dark: true) == 0x8B84FF)
    }
}

// MARK: - Mint

@Suite("NSColor.Base — Mint")
struct BaseMintTests {

    @Test("Mint light mode")
    func mintLight() {
        #expect(resolvedHex(NSColor.Base.mint50, dark: false) == 0xEDFCF8)
        #expect(resolvedHex(NSColor.Base.mint100, dark: false) == 0xD4F5EA)
        #expect(resolvedHex(NSColor.Base.mint200, dark: false) == 0xB0ECDA)
        #expect(resolvedHex(NSColor.Base.mint300, dark: false) == 0x6DD4BC)
        #expect(resolvedHex(NSColor.Base.mint500, dark: false) == 0x2FB894)
    }

    @Test("Mint dark mode")
    func mintDark() {
        #expect(resolvedHex(NSColor.Base.mint50, dark: true) == 0x192E28)
        #expect(resolvedHex(NSColor.Base.mint100, dark: true) == 0x223E34)
        #expect(resolvedHex(NSColor.Base.mint200, dark: true) == 0x2E5A4C)
        #expect(resolvedHex(NSColor.Base.mint300, dark: true) == 0x52BEA4)
        #expect(resolvedHex(NSColor.Base.mint500, dark: true) == 0x3ED4AE)
    }
}

// MARK: - Peach

@Suite("NSColor.Base — Peach")
struct BasePeachTests {

    @Test("Peach light mode")
    func peachLight() {
        #expect(resolvedHex(NSColor.Base.peach50, dark: false) == 0xFFF7EC)
        #expect(resolvedHex(NSColor.Base.peach100, dark: false) == 0xFFECD3)
        #expect(resolvedHex(NSColor.Base.peach200, dark: false) == 0xFFDBB4)
        #expect(resolvedHex(NSColor.Base.peach300, dark: false) == 0xF5B078)
        #expect(resolvedHex(NSColor.Base.peach500, dark: false) == 0xF08C42)
    }

    @Test("Peach dark mode")
    func peachDark() {
        #expect(resolvedHex(NSColor.Base.peach50, dark: true) == 0x2E2519)
        #expect(resolvedHex(NSColor.Base.peach100, dark: true) == 0x3E3223)
        #expect(resolvedHex(NSColor.Base.peach200, dark: true) == 0x5C482F)
        #expect(resolvedHex(NSColor.Base.peach300, dark: true) == 0xD49560)
        #expect(resolvedHex(NSColor.Base.peach500, dark: true) == 0xF5A05A)
    }
}

// MARK: - Rose

@Suite("NSColor.Base — Rose")
struct BaseRoseTests {

    @Test("Rose light mode")
    func roseLight() {
        #expect(resolvedHex(NSColor.Base.rose50, dark: false) == 0xFFF0F1)
        #expect(resolvedHex(NSColor.Base.rose100, dark: false) == 0xFFDEE2)
        #expect(resolvedHex(NSColor.Base.rose200, dark: false) == 0xFFC8CF)
        #expect(resolvedHex(NSColor.Base.rose300, dark: false) == 0xF58C99)
        #expect(resolvedHex(NSColor.Base.rose500, dark: false) == 0xE85468)
    }

    @Test("Rose dark mode")
    func roseDark() {
        #expect(resolvedHex(NSColor.Base.rose50, dark: true) == 0x2E191E)
        #expect(resolvedHex(NSColor.Base.rose100, dark: true) == 0x3E2328)
        #expect(resolvedHex(NSColor.Base.rose200, dark: true) == 0x5C303B)
        #expect(resolvedHex(NSColor.Base.rose300, dark: true) == 0xD86E7C)
        #expect(resolvedHex(NSColor.Base.rose500, dark: true) == 0xF07080)
    }
}

// MARK: - Sky

@Suite("NSColor.Base — Sky")
struct BaseSkyTests {

    @Test("Sky light mode")
    func skyLight() {
        #expect(resolvedHex(NSColor.Base.sky50, dark: false) == 0xEDF6FF)
        #expect(resolvedHex(NSColor.Base.sky100, dark: false) == 0xDAEDFF)
        #expect(resolvedHex(NSColor.Base.sky200, dark: false) == 0xB5DCFF)
        #expect(resolvedHex(NSColor.Base.sky300, dark: false) == 0x70BCF5)
        #expect(resolvedHex(NSColor.Base.sky500, dark: false) == 0x3698F0)
    }

    @Test("Sky dark mode")
    func skyDark() {
        #expect(resolvedHex(NSColor.Base.sky50, dark: true) == 0x192535)
        #expect(resolvedHex(NSColor.Base.sky100, dark: true) == 0x22334C)
        #expect(resolvedHex(NSColor.Base.sky200, dark: true) == 0x2E4A6E)
        #expect(resolvedHex(NSColor.Base.sky300, dark: true) == 0x58A8DB)
        #expect(resolvedHex(NSColor.Base.sky500, dark: true) == 0x4EB0F5)
    }
}

// MARK: - Lemon

@Suite("NSColor.Base — Lemon")
struct BaseLemonTests {

    @Test("Lemon light mode")
    func lemonLight() {
        #expect(resolvedHex(NSColor.Base.lemon50, dark: false) == 0xFFFCEB)
        #expect(resolvedHex(NSColor.Base.lemon100, dark: false) == 0xFFF5CC)
        #expect(resolvedHex(NSColor.Base.lemon200, dark: false) == 0xFFEBA5)
        #expect(resolvedHex(NSColor.Base.lemon300, dark: false) == 0xF5D160)
        #expect(resolvedHex(NSColor.Base.lemon500, dark: false) == 0xE8B420)
    }

    @Test("Lemon dark mode")
    func lemonDark() {
        #expect(resolvedHex(NSColor.Base.lemon50, dark: true) == 0x2E2A17)
        #expect(resolvedHex(NSColor.Base.lemon100, dark: true) == 0x3E3820)
        #expect(resolvedHex(NSColor.Base.lemon200, dark: true) == 0x5C4F2C)
        #expect(resolvedHex(NSColor.Base.lemon300, dark: true) == 0xD4B648)
        #expect(resolvedHex(NSColor.Base.lemon500, dark: true) == 0xF0C838)
    }
}

// MARK: - Lilac

@Suite("NSColor.Base — Lilac")
struct BaseLilacTests {

    @Test("Lilac light mode")
    func lilacLight() {
        #expect(resolvedHex(NSColor.Base.lilac50, dark: false) == 0xF8F0FF)
        #expect(resolvedHex(NSColor.Base.lilac100, dark: false) == 0xEEDDFF)
        #expect(resolvedHex(NSColor.Base.lilac200, dark: false) == 0xDFC6FF)
        #expect(resolvedHex(NSColor.Base.lilac300, dark: false) == 0xBE8AF5)
        #expect(resolvedHex(NSColor.Base.lilac500, dark: false) == 0x9C52E0)
    }

    @Test("Lilac dark mode")
    func lilacDark() {
        #expect(resolvedHex(NSColor.Base.lilac50, dark: true) == 0x26192E)
        #expect(resolvedHex(NSColor.Base.lilac100, dark: true) == 0x33233E)
        #expect(resolvedHex(NSColor.Base.lilac200, dark: true) == 0x48305C)
        #expect(resolvedHex(NSColor.Base.lilac300, dark: true) == 0xA86ED8)
        #expect(resolvedHex(NSColor.Base.lilac500, dark: true) == 0xB56EF5)
    }
}

// MARK: - Neutral

@Suite("NSColor.Base — Neutral")
struct BaseNeutralTests {

    @Test("Neutral light mode")
    func neutralLight() {
        #expect(resolvedHex(NSColor.Base.neutral50, dark: false) == 0xFAFAFA)
        #expect(resolvedHex(NSColor.Base.neutral100, dark: false) == 0xF5F5F5)
        #expect(resolvedHex(NSColor.Base.neutral200, dark: false) == 0xE5E5E5)
        #expect(resolvedHex(NSColor.Base.neutral300, dark: false) == 0xD4D4D4)
        #expect(resolvedHex(NSColor.Base.neutral500, dark: false) == 0x737373)
        #expect(resolvedHex(NSColor.Base.neutral700, dark: false) == 0x404040)
        #expect(resolvedHex(NSColor.Base.neutral900, dark: false) == 0x171717)
    }

    @Test("Neutral dark mode")
    func neutralDark() {
        #expect(resolvedHex(NSColor.Base.neutral50, dark: true) == 0x171717)
        #expect(resolvedHex(NSColor.Base.neutral100, dark: true) == 0x262626)
        #expect(resolvedHex(NSColor.Base.neutral200, dark: true) == 0x404040)
        #expect(resolvedHex(NSColor.Base.neutral300, dark: true) == 0x525252)
        #expect(resolvedHex(NSColor.Base.neutral500, dark: true) == 0xA3A3A3)
        #expect(resolvedHex(NSColor.Base.neutral700, dark: true) == 0xD4D4D4)
        #expect(resolvedHex(NSColor.Base.neutral900, dark: true) == 0xFAFAFA)
    }
}
```

**Step 2: Create all production files**

```swift
// EmpUI_macOS/Sources/Common/Colors/NSAppearance+isDark.swift
import AppKit

extension NSAppearance {

    var isDark: Bool {
        bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
}
```

```swift
// EmpUI_macOS/Sources/Common/Colors/NSColor+Hex.swift
import AppKit

extension NSColor {

    convenience init(hex: UInt32) {
        self.init(
            sRGBRed: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
```

```swift
// EmpUI_macOS/Sources/Common/Colors/NSColor+Base.swift
import AppKit

public extension NSColor {

    enum Base {}
}
```

Each hue file follows this pattern (showing Lavender, rest identical to iOS hex values):

```swift
// EmpUI_macOS/Sources/Common/Colors/NSColor+Base+Lavender.swift
import AppKit

public extension NSColor.Base {

    static let lavender50 = NSColor(name: nil) { $0.isDark ? NSColor(hex: 0x1E1F32) : NSColor(hex: 0xF0F1FF) }
    static let lavender100 = NSColor(name: nil) { $0.isDark ? NSColor(hex: 0x2A2C48) : NSColor(hex: 0xE2E3FF) }
    static let lavender200 = NSColor(name: nil) { $0.isDark ? NSColor(hex: 0x3F4170) : NSColor(hex: 0xC9C8FD) }
    static let lavender300 = NSColor(name: nil) { $0.isDark ? NSColor(hex: 0x7D79DB) : NSColor(hex: 0x9B97F5) }
    static let lavender500 = NSColor(name: nil) { $0.isDark ? NSColor(hex: 0x8B84FF) : NSColor(hex: 0x6C63FF) }
}
```

Remaining hues — same hex values as iOS, replace `UIColor` → `NSColor`, `$0.userInterfaceStyle == .dark` → `$0.isDark`, `NSColor(name: nil)` dynamic provider:

- `NSColor+Base+Mint.swift` — mint50-500, same hex as Task 3
- `NSColor+Base+Peach.swift` — peach50-500, same hex as Task 3
- `NSColor+Base+Rose.swift` — rose50-500, same hex as Task 3
- `NSColor+Base+Sky.swift` — sky50-500, same hex as Task 3
- `NSColor+Base+Lemon.swift` — lemon50-500, same hex as Task 3
- `NSColor+Base+Lilac.swift` — lilac50-500, same hex as Task 3
- `NSColor+Base+Neutral.swift` — neutral50-900 (7 steps), same hex as Task 3

**Step 3: Generate and test**

```bash
mise exec -- tuist generate --no-open
mise exec -- tuist test EmpUI_macOS
```

---

### Task 7: macOS — Semantic tokens (TDD)

**Files:**
- Create: `EmpUI_macOS/Sources/Common/Colors/NSColor+Semantic.swift`
- Create: `EmpUI_macOS/Tests/SemanticColorTests.swift`

**Step 1: Write tests**

```swift
// EmpUI_macOS/Tests/SemanticColorTests.swift
import AppKit
import Testing
@testable import EmpUI_macOS

private func resolvedHex(_ color: NSColor, dark: Bool) -> UInt32 {
    let saved = NSAppearance.current
    NSAppearance.current = NSAppearance(named: dark ? .darkAqua : .aqua)!
    defer { NSAppearance.current = saved }

    let resolved = color.usingColorSpace(.sRGB)!
    let r = UInt32(round(resolved.redComponent * 255))
    let g = UInt32(round(resolved.greenComponent * 255))
    let b = UInt32(round(resolved.blueComponent * 255))
    return (r << 16) | (g << 8) | b
}

@Suite("NSColor.Semantic")
struct SemanticColorTests {

    @Test("backgroundPrimary — white/dark")
    func backgroundPrimary() {
        #expect(resolvedHex(NSColor.Semantic.backgroundPrimary, dark: false) == 0xFFFFFF)
        #expect(resolvedHex(NSColor.Semantic.backgroundPrimary, dark: true) == 0x0A0A0A)
    }

    @Test("backgroundSecondary ссылается на neutral50")
    func backgroundSecondary() {
        #expect(NSColor.Semantic.backgroundSecondary === NSColor.Base.neutral50)
    }

    @Test("textPrimary ссылается на neutral900")
    func textPrimary() { #expect(NSColor.Semantic.textPrimary === NSColor.Base.neutral900) }

    @Test("actionPrimary ссылается на lavender500")
    func actionPrimary() { #expect(NSColor.Semantic.actionPrimary === NSColor.Base.lavender500) }

    @Test("cardLavender ссылается на lavender50")
    func cardLavender() { #expect(NSColor.Semantic.cardLavender === NSColor.Base.lavender50) }
}
```

**Step 2: Create semantic tokens**

```swift
// EmpUI_macOS/Sources/Common/Colors/NSColor+Semantic.swift
import AppKit

public extension NSColor {

    enum Semantic {}
}

public extension NSColor.Semantic {

    // MARK: - Backgrounds

    static let backgroundPrimary = NSColor(name: nil) { $0.isDark ? NSColor(hex: 0x0A0A0A) : .white }
    static let backgroundSecondary = NSColor.Base.neutral50
    static let backgroundTertiary = NSColor.Base.neutral100

    // MARK: - Cards

    static let cardLavender = NSColor.Base.lavender50
    static let cardBorderLavender = NSColor.Base.lavender200
    static let cardMint = NSColor.Base.mint50
    static let cardBorderMint = NSColor.Base.mint200
    static let cardPeach = NSColor.Base.peach50
    static let cardBorderPeach = NSColor.Base.peach200
    static let cardRose = NSColor.Base.rose50
    static let cardBorderRose = NSColor.Base.rose200
    static let cardSky = NSColor.Base.sky50
    static let cardBorderSky = NSColor.Base.sky200
    static let cardLemon = NSColor.Base.lemon50
    static let cardBorderLemon = NSColor.Base.lemon200
    static let cardLilac = NSColor.Base.lilac50
    static let cardBorderLilac = NSColor.Base.lilac200

    // MARK: - Borders

    static let borderDefault = NSColor.Base.neutral200
    static let borderSubtle = NSColor.Base.neutral100

    // MARK: - Text

    static let textPrimary = NSColor.Base.neutral900
    static let textSecondary = NSColor.Base.neutral500
    static let textTertiary = NSColor.Base.neutral300
    static let textAccent = NSColor.Base.lavender500

    // MARK: - Actions

    static let actionPrimary = NSColor.Base.lavender500
    static let actionSuccess = NSColor.Base.mint500
    static let actionWarning = NSColor.Base.peach500
    static let actionDanger = NSColor.Base.rose500
    static let actionInfo = NSColor.Base.sky500
}
```

**Step 3: Generate and test**

```bash
mise exec -- tuist generate --no-open
mise exec -- tuist test EmpUI_macOS
```

---

### Task 8: macOS — EmpGradient + presets (TDD)

**Files:**
- Create: `EmpUI_macOS/Sources/Common/Colors/EmpGradient.swift`
- Create: `EmpUI_macOS/Sources/Common/Colors/EmpGradient+Preset.swift`
- Create: `EmpUI_macOS/Tests/EmpGradientTests.swift`

**Step 1: Write tests**

```swift
// EmpUI_macOS/Tests/EmpGradientTests.swift
import AppKit
import Testing
@testable import EmpUI_macOS

@Suite("EmpGradient")
struct EmpGradientTests {

    @Test("Инициализация сохраняет цвета")
    func initStoresColors() {
        let start = NSColor.Base.lavender200
        let end = NSColor.Base.sky200
        let gradient = EmpGradient(startColor: start, endColor: end)
        #expect(gradient.startColor === start)
        #expect(gradient.endColor === end)
    }

    @Test("Equatable — одинаковые градиенты равны")
    func equatable() {
        let a = EmpGradient.Preset.lavenderToSky
        let b = EmpGradient.Preset.lavenderToSky
        #expect(a == b)
    }

    @Test("resolvedColors возвращает CGColor")
    func resolvedColors() {
        let gradient = EmpGradient.Preset.lavenderToSky
        let appearance = NSAppearance(named: .aqua)!
        let (start, end) = gradient.resolvedColors(for: appearance)
        #expect(start.numberOfComponents >= 3)
        #expect(end.numberOfComponents >= 3)
    }

    @Test("Пресет lavenderToSky использует правильные базовые цвета")
    func presetLavenderToSky() {
        let preset = EmpGradient.Preset.lavenderToSky
        #expect(preset.startColor === NSColor.Base.lavender200)
        #expect(preset.endColor === NSColor.Base.sky200)
    }
}
```

**Step 2: Create implementation**

```swift
// EmpUI_macOS/Sources/Common/Colors/EmpGradient.swift
import AppKit

public struct EmpGradient: Equatable {

    public let startColor: NSColor
    public let endColor: NSColor

    public init(startColor: NSColor, endColor: NSColor) {
        self.startColor = startColor
        self.endColor = endColor
    }

    public func resolvedColors(for appearance: NSAppearance) -> (start: CGColor, end: CGColor) {
        let saved = NSAppearance.current
        NSAppearance.current = appearance
        defer { NSAppearance.current = saved }

        return (startColor.cgColor, endColor.cgColor)
    }
}
```

```swift
// EmpUI_macOS/Sources/Common/Colors/EmpGradient+Preset.swift
import AppKit

extension EmpGradient {

    public enum Preset {

        // MARK: - Soft (step 200)

        public static let lavenderToSky = EmpGradient(startColor: NSColor.Base.lavender200, endColor: NSColor.Base.sky200)
        public static let skyToMint = EmpGradient(startColor: NSColor.Base.sky200, endColor: NSColor.Base.mint200)
        public static let peachToRose = EmpGradient(startColor: NSColor.Base.peach200, endColor: NSColor.Base.rose200)
        public static let roseToLilac = EmpGradient(startColor: NSColor.Base.rose200, endColor: NSColor.Base.lilac200)

        // MARK: - Saturated (step 300)

        public static let lavenderToLilac = EmpGradient(startColor: NSColor.Base.lavender300, endColor: NSColor.Base.lilac300)
        public static let lemonToPeach = EmpGradient(startColor: NSColor.Base.lemon300, endColor: NSColor.Base.peach300)
        public static let lavenderToMint = EmpGradient(startColor: NSColor.Base.lavender300, endColor: NSColor.Base.mint300)
        public static let skyToLavender = EmpGradient(startColor: NSColor.Base.sky300, endColor: NSColor.Base.lavender300)
    }
}
```

**Step 3: Generate and test**

```bash
mise exec -- tuist generate --no-open
mise exec -- tuist test EmpUI_macOS
```

---

### Task 9: Full build verification

**Step 1: Build both platforms**

```bash
mise exec -- tuist build EmpUI_iOS
mise exec -- tuist build EmpDesignSystem
```
Expected: Both succeed.

**Step 2: Run all tests**

```bash
mise exec -- tuist test EmpUI_iOS
mise exec -- tuist test EmpUI_macOS
```
Expected: All tests pass.
