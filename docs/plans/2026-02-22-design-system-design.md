# EmpDesignSystem — Design Document

## Summary

Design system project using Tuist with reusable UI components for iOS (UIKit) and macOS (AppKit). Components are configured via `Component.ViewModel` and `configure(with:)` pattern. Preview-first development workflow.

## Decisions

- **Platform:** iOS + macOS
- **UI frameworks:** UIKit (iOS), AppKit (macOS) — separate implementations
- **Packaging:** Two independent frameworks (`EmpUI_iOS`, `EmpUI_macOS`)
- **Framework name prefix:** `EmpUI`
- **Initial components:** EmpButton, EmpLabel
- **Sandbox app:** EmpDesignSystem (macOS, Hello World) — used for Preview only

## Tuist Targets

| Target | Product | Destinations | Dependencies |
|--------|---------|-------------|-------------|
| `EmpUI_iOS` | framework | .iOS | — |
| `EmpUI_macOS` | framework | .macOS | — |
| `EmpDesignSystem` | app | .macOS | EmpUI_macOS |
| `EmpDesignSystemTests` | unitTests | .macOS | EmpDesignSystem |

## File Structure

```
EmpDesignSystem/
├── Project.swift
├── Tuist.swift
├── Tuist/Package.swift
├── EmpUI_iOS/
│   ├── Sources/
│   │   ├── Components/
│   │   │   ├── EmpButton.swift
│   │   │   └── EmpLabel.swift
│   │   └── Preview/
│   │       ├── EmpButton+Preview.swift
│   │       └── EmpLabel+Preview.swift
│   └── Tests/
├── EmpUI_macOS/
│   ├── Sources/
│   │   ├── Components/
│   │   │   ├── EmpButton.swift
│   │   │   └── EmpLabel.swift
│   │   └── Preview/
│   │       ├── EmpButton+Preview.swift
│   │       └── EmpLabel+Preview.swift
│   └── Tests/
├── EmpDesignSystem/
│   ├── Sources/
│   ├── Resources/
│   └── Tests/
```

## Component Pattern

Each component follows the same structure:

```swift
// iOS example (UIKit)
public final class EmpButton: UIView {

    public struct ViewModel {
        public let title: String
        public let style: Style

        public enum Style {
            case primary
            case secondary
        }
    }

    public func configure(with viewModel: ViewModel) {
        // Apply viewModel properties to UI elements
    }
}
```

macOS version inherits from `NSView` instead of `UIView`.

### Preview Pattern

```swift
#Preview {
    let button = EmpButton()
    button.configure(with: .init(title: "Tap me", style: .primary))
    return button
}
```

## What Is NOT Included

- The sandbox app remains Hello World — no custom UI
- No shared module between iOS and macOS (fully independent)
- No SwiftUI wrappers
- No external dependencies
