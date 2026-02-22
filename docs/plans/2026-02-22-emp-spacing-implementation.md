# EmpSpacing Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Добавить spacing-токены на 4pt-сетке (enum EmpSpacing) и convenience init для UIEdgeInsets/NSEdgeInsets.

**Architecture:** EmpSpacing — CGFloat enum, идентичный на обеих платформах. Convenience init на UIEdgeInsets (iOS) и NSEdgeInsets (macOS) позволяет передавать токены напрямую. CommonViewModel не меняется.

**Tech Stack:** Swift, UIKit (iOS), AppKit (macOS), Swift Testing

**Design doc:** `docs/plans/2026-02-22-emp-spacing-design.md`

---

### Task 1: EmpSpacing enum + тесты (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/EmpSpacing.swift`
- Create: `EmpUI_iOS/Tests/EmpSpacingTests.swift`

**Step 1: Write the failing test**

```swift
// EmpUI_iOS/Tests/EmpSpacingTests.swift
import Testing
@testable import EmpUI_iOS

@Suite("EmpSpacing")
struct EmpSpacingTests {
    @Test("Все токены соответствуют ожидаемым значениям", arguments: [
        (EmpSpacing.xxs, 4.0),
        (EmpSpacing.xs, 8.0),
        (EmpSpacing.s, 12.0),
        (EmpSpacing.m, 16.0),
        (EmpSpacing.l, 20.0),
        (EmpSpacing.xl, 24.0),
        (EmpSpacing.xxl, 32.0),
        (EmpSpacing.xxxl, 40.0),
    ] as [(EmpSpacing, Double)])
    func tokenValues(token: EmpSpacing, expected: Double) {
        #expect(token.rawValue == CGFloat(expected))
    }

    @Test("Все токены кратны 4")
    func allMultiplesOfFour() {
        for token in [EmpSpacing.xxs, .xs, .s, .m, .l, .xl, .xxl, .xxxl] {
            #expect(token.rawValue.truncatingRemainder(dividingBy: 4) == 0)
        }
    }
}
```

**Step 2: Run test to verify it fails**

Run: `mise exec -- tuist test EmpUI_iOS`
Expected: FAIL — `Cannot find type 'EmpSpacing' in scope`

**Step 3: Write minimal implementation**

```swift
// EmpUI_iOS/Sources/Common/EmpSpacing.swift
import CoreGraphics

public enum EmpSpacing: CGFloat {
    case xxs = 4
    case xs = 8
    case s = 12
    case m = 16
    case l = 20
    case xl = 24
    case xxl = 32
    case xxxl = 40
}
```

**Step 4: Run test to verify it passes**

Run: `mise exec -- tuist test EmpUI_iOS`
Expected: PASS

**Step 5: Commit**

```bash
git add EmpUI_iOS/Sources/Common/EmpSpacing.swift EmpUI_iOS/Tests/EmpSpacingTests.swift
git commit -m "feat(ios): add EmpSpacing enum with 4pt grid tokens"
```

---

### Task 2: UIEdgeInsets+EmpSpacing + тесты (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/UIEdgeInsets+EmpSpacing.swift`
- Modify: `EmpUI_iOS/Tests/EmpSpacingTests.swift`

**Step 1: Write the failing test**

Добавить в существующий `EmpSpacingTests.swift`:

```swift
import UIKit

// Добавить внутрь @Suite("EmpSpacing"):

@Test("UIEdgeInsets init корректно передаёт значения")
func edgeInsetsInit() {
    let insets = UIEdgeInsets(top: .xs, left: .m, bottom: .s, right: .xl)
    #expect(insets == UIEdgeInsets(top: 8, left: 16, bottom: 12, right: 24))
}

@Test("UIEdgeInsets init с одинаковыми значениями")
func edgeInsetsUniform() {
    let insets = UIEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
    #expect(insets == UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
}
```

**Step 2: Run test to verify it fails**

Run: `mise exec -- tuist test EmpUI_iOS`
Expected: FAIL — нет init на UIEdgeInsets с EmpSpacing

**Step 3: Write minimal implementation**

```swift
// EmpUI_iOS/Sources/Common/UIEdgeInsets+EmpSpacing.swift
import UIKit

public extension UIEdgeInsets {
    init(top: EmpSpacing, left: EmpSpacing, bottom: EmpSpacing, right: EmpSpacing) {
        self.init(top: top.rawValue, left: left.rawValue, bottom: bottom.rawValue, right: right.rawValue)
    }
}
```

**Step 4: Run test to verify it passes**

Run: `mise exec -- tuist test EmpUI_iOS`
Expected: PASS

**Step 5: Commit**

```bash
git add EmpUI_iOS/Sources/Common/UIEdgeInsets+EmpSpacing.swift EmpUI_iOS/Tests/EmpSpacingTests.swift
git commit -m "feat(ios): add UIEdgeInsets convenience init with EmpSpacing"
```

---

### Task 3: EmpSpacing enum + тесты (macOS)

**Files:**
- Create: `EmpUI_macOS/Sources/Common/EmpSpacing.swift`
- Create: `EmpUI_macOS/Tests/EmpSpacingTests.swift`

**Step 1: Write the failing test**

```swift
// EmpUI_macOS/Tests/EmpSpacingTests.swift
import Testing
@testable import EmpUI_macOS

@Suite("EmpSpacing")
struct EmpSpacingTests {
    @Test("Все токены соответствуют ожидаемым значениям", arguments: [
        (EmpSpacing.xxs, 4.0),
        (EmpSpacing.xs, 8.0),
        (EmpSpacing.s, 12.0),
        (EmpSpacing.m, 16.0),
        (EmpSpacing.l, 20.0),
        (EmpSpacing.xl, 24.0),
        (EmpSpacing.xxl, 32.0),
        (EmpSpacing.xxxl, 40.0),
    ] as [(EmpSpacing, Double)])
    func tokenValues(token: EmpSpacing, expected: Double) {
        #expect(token.rawValue == CGFloat(expected))
    }

    @Test("Все токены кратны 4")
    func allMultiplesOfFour() {
        for token in [EmpSpacing.xxs, .xs, .s, .m, .l, .xl, .xxl, .xxxl] {
            #expect(token.rawValue.truncatingRemainder(dividingBy: 4) == 0)
        }
    }
}
```

**Step 2: Run test to verify it fails**

Run: `mise exec -- tuist test EmpUI_macOS`
Expected: FAIL — `Cannot find type 'EmpSpacing' in scope`

**Step 3: Write minimal implementation**

```swift
// EmpUI_macOS/Sources/Common/EmpSpacing.swift
import CoreGraphics

public enum EmpSpacing: CGFloat {
    case xxs = 4
    case xs = 8
    case s = 12
    case m = 16
    case l = 20
    case xl = 24
    case xxl = 32
    case xxxl = 40
}
```

**Step 4: Run test to verify it passes**

Run: `mise exec -- tuist test EmpUI_macOS`
Expected: PASS

**Step 5: Commit**

```bash
git add EmpUI_macOS/Sources/Common/EmpSpacing.swift EmpUI_macOS/Tests/EmpSpacingTests.swift
git commit -m "feat(macos): add EmpSpacing enum with 4pt grid tokens"
```

---

### Task 4: NSEdgeInsets+EmpSpacing + тесты (macOS)

**Files:**
- Create: `EmpUI_macOS/Sources/Common/NSEdgeInsets+EmpSpacing.swift`
- Modify: `EmpUI_macOS/Tests/EmpSpacingTests.swift`

**Step 1: Write the failing test**

Добавить в существующий `EmpSpacingTests.swift`:

```swift
import AppKit

// Добавить внутрь @Suite("EmpSpacing"):

@Test("NSEdgeInsets init корректно передаёт значения")
func edgeInsetsInit() {
    let insets = NSEdgeInsets(top: .xs, left: .m, bottom: .s, right: .xl)
    #expect(insets == NSEdgeInsets(top: 8, left: 16, bottom: 12, right: 24))
}

@Test("NSEdgeInsets init с одинаковыми значениями")
func edgeInsetsUniform() {
    let insets = NSEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
    #expect(insets == NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
}
```

> **Примечание:** NSEdgeInsets Equatable уже реализован в `NSEdgeInsets+Equatable.swift`.

**Step 2: Run test to verify it fails**

Run: `mise exec -- tuist test EmpUI_macOS`
Expected: FAIL — нет init на NSEdgeInsets с EmpSpacing

**Step 3: Write minimal implementation**

```swift
// EmpUI_macOS/Sources/Common/NSEdgeInsets+EmpSpacing.swift
import AppKit

public extension NSEdgeInsets {
    init(top: EmpSpacing, left: EmpSpacing, bottom: EmpSpacing, right: EmpSpacing) {
        self.init(top: top.rawValue, left: left.rawValue, bottom: bottom.rawValue, right: right.rawValue)
    }
}
```

**Step 4: Run test to verify it passes**

Run: `mise exec -- tuist test EmpUI_macOS`
Expected: PASS

**Step 5: Commit**

```bash
git add EmpUI_macOS/Sources/Common/NSEdgeInsets+EmpSpacing.swift EmpUI_macOS/Tests/EmpSpacingTests.swift
git commit -m "feat(macos): add NSEdgeInsets convenience init with EmpSpacing"
```

---

### Task 5: tuist generate + финальная проверка

**Step 1: Регенерировать проект**

Run: `mise exec -- tuist generate --no-open`
Expected: Project generated.

**Step 2: Собрать оба фреймворка**

Run: `mise exec -- tuist build EmpUI_iOS && mise exec -- tuist build EmpUI_macOS`
Expected: Build succeeded (оба).

**Step 3: Прогнать все тесты**

Run: `mise exec -- tuist test EmpUI_iOS && mise exec -- tuist test EmpUI_macOS`
Expected: All tests pass (оба).

**Step 4: Lint**

Run: `swiftlint && swiftformat --lint .`
Expected: No violations.
