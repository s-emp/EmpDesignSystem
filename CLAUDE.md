# EmpDesignSystem

## Communication

Always communicate with the user in Russian.

## Git Workflow

- **NEVER commit changes yourself.** Write the code, then the user reviews and commits.
- Every feature MUST be developed in a separate branch: `feature/<branch-name>`
- Do NOT work directly on `master`

## Project Overview

Design system project with reusable UI components for iOS (UIKit) and macOS (AppKit). Preview-driven development — the sandbox app is just Hello World, all component work happens through Xcode Previews.

## Tech Stack

- **Tuist 4.131.1** (managed via `mise.toml`)
- **Swift**, UIKit (iOS), AppKit (macOS)
- **No external dependencies**

## Project Structure

```
Project.swift              — Tuist project manifest (4 targets)
Tuist.swift                — Tuist configuration
Tuist/Package.swift        — Dependencies (currently empty)
EmpUI_iOS/Sources/         — iOS framework (UIKit)
  Common/                  — CommonViewModel, UIView+CommonViewModel
  Components/              — UI components
  Preview/                 — #Preview files
EmpUI_macOS/Sources/       — macOS framework (AppKit)
  Common/                  — CommonViewModel, NSView+CommonViewModel
  Components/              — UI components
  Preview/                 — #Preview files
EmpDesignSystem/Sources/   — Sandbox macOS app (Hello World)
EmpDesignSystem/Resources/ — App resources
EmpDesignSystem/Tests/     — Unit tests
```

## Targets

| Target | Product | Platform | Dependencies |
|--------|---------|----------|-------------|
| `EmpUI_iOS` | framework | iOS | — |
| `EmpUI_macOS` | framework | macOS | — |
| `EmpDesignSystem` | app | macOS | EmpUI_macOS |
| `EmpDesignSystemTests` | unitTests | macOS | EmpDesignSystem |

## Commands

```bash
# Generate Xcode project (required before building)
mise exec -- tuist generate --no-open

# Build macOS sandbox (includes EmpUI_macOS)
mise exec -- tuist build EmpDesignSystem

# Build iOS framework
mise exec -- tuist build EmpUI_iOS

# Note: `tuist build` takes scheme as positional argument, NOT --scheme flag
```

## Component Pattern

Every component follows this structure:

- Class inherits from `UIView` (iOS) or `NSView` (macOS)
- Nested `ViewModel` struct inside the component
- Public `configure(with viewModel: ViewModel)` method
- Separate `+Preview.swift` file with `#Preview` macros and test data

### iOS example

```swift
public final class EmpButton: UIView {
    public struct ViewModel {
        public let common: CommonViewModel
        public let title: String
        public let style: Style
        public enum Style { case primary, secondary }
        public init(common: CommonViewModel = CommonViewModel(), title: String, style: Style) { ... }
    }
    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)
        // component-specific configuration...
    }
}
```

### macOS — same pattern but inherits from `NSView`

## Component Architecture

Every component follows this layout:

```
EmpComponent (UIView/NSView)  ← apply(common:) sets border/shadow/corners/bg/layoutMargins
    └── content element        ← constrained to layoutMarginsGuide
```

### Layout Margins Approach

Content is pinned to `layoutMarginsGuide` via constraints. Margins are applied by setting `layoutMargins` — constraints are NEVER updated manually.

- **iOS:** `UIView` has native `layoutMarginsGuide`. Just set `layoutMargins = margins`.
- **macOS:** `NSView` does NOT have native `layoutMarginsGuide`. Use a custom `NSLayoutGuide` (called `empLayoutMarginsGuide`) added to the view. Setting margins updates the guide's edge constraints automatically.

**Wrong (do NOT do this):**
```swift
// Storing constraint references and updating constants
topConstraint?.constant = margins.top
leadingConstraint?.constant = margins.left
```

**Correct:**
```swift
// iOS — native
layoutMargins = viewModel.layoutMargins

// macOS — custom guide, same concept
empLayoutMargins = viewModel.layoutMargins  // updates guide constraints internally
```

### Rules

- Every `ViewModel` MUST contain `common: CommonViewModel` as the first field
- Every `configure(with:)` MUST call `apply(common: viewModel.common)` first
- Content elements MUST be constrained to `layoutMarginsGuide` (iOS) or `empLayoutMarginsGuide` (macOS) — NEVER to view edges directly
- `apply(common:)` sets `layoutMargins` (iOS) or `empLayoutMargins` (macOS) — NEVER updates constraint constants manually
- `apply(common:)` is a `UIView`/`NSView` extension in `Common/` directory — not a method on each component
- CommonViewModel fields are all required with sensible defaults (no optionals)

### CommonViewModel Properties

| Property | Type (iOS) | Type (macOS) | Default |
|----------|-----------|-------------|---------|
| `border` | `CommonViewModel.Border` | same | width=0, color=.clear, solid |
| `shadow` | `CommonViewModel.Shadow` | same | no shadow |
| `corners` | `CommonViewModel.Corners` | same | radius=0, all corners |
| `backgroundColor` | `UIColor` | `NSColor` | `.clear` |
| `layoutMargins` | `UIEdgeInsets` | `NSEdgeInsets` | `.zero` |

## Critical: #Preview with AppKit/UIKit Views

The `#Preview` macro uses `PreviewMacroBodyBuilder` result builder. Every expression inside is treated as a potential view return value.

**`configure(with:)` returns Void — the result builder cannot convert `()` to NSView/UIView.**

Always wrap configure calls with `let _ =`:

```swift
#Preview("EmpButton — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: .init(title: "Primary", style: .primary))
    button
}
```

Do NOT use explicit `return` — result builders forbid it.

## SourceKit False Positives

These diagnostics appear before `tuist generate` and are **not real errors**:

- `No such module 'ProjectDescription'` in Project.swift — Tuist provides this at generation time
- `No such module 'UIKit'` in EmpUI_iOS files — SourceKit runs in macOS context
- `Cannot find 'ComponentName' in scope` in Preview files — same-module references resolve after generation

## Design Docs

Implementation plans and design documents are in `docs/plans/`.
