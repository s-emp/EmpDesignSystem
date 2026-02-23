# EmpDesignSystem

## Communication

Always communicate with the user in Russian.

## Git Workflow

- **NEVER commit changes yourself.** Write the code, then the user reviews and commits.
- Every feature MUST be developed in a separate branch: `feature/<branch-name>`
- Do NOT work directly on `master`
- **Before starting any work:** check current branch with `git branch`. If on `master` — create and switch to `feature/<name>` BEFORE making any changes

## Project Overview

Design system project with reusable UI components for iOS (UIKit) and macOS (AppKit). Preview-driven development — the sandbox app is just Hello World, all component work happens through Xcode Previews.

## Tech Stack

- **Tuist 4.131.1** (managed via `mise.toml`)
- **Swift**, UIKit (iOS), AppKit (macOS)
- **No external dependencies** in production code
- **swift-snapshot-testing** — test-only dependency (via `Tuist/Package.swift`)

## Project Structure

```
Project.swift              — Tuist project manifest (6 targets)
Tuist.swift                — Tuist configuration
Tuist/Package.swift        — External dependencies (swift-snapshot-testing)
Tuist/Package.resolved     — Locked dependency versions (committed to git)
EmpUI_iOS/Sources/         — iOS framework (UIKit)
  Common/                  — CommonViewModel, nested types (+Border/+Shadow/+Corners), UIView+CommonViewModel
  Components/              — UI components
  Preview/                 — #Preview files
EmpUI_iOS/Tests/           — iOS framework tests
EmpUI_macOS/Sources/       — macOS framework (AppKit)
  Common/                  — CommonViewModel, nested types, NSView+CommonViewModel, NSEdgeInsets+Equatable
  Components/              — UI components
  Preview/                 — #Preview files
EmpUI_macOS/Tests/         — macOS framework tests
EmpDesignSystem/Sources/   — Sandbox macOS app (Hello World)
EmpDesignSystem/Resources/ — App resources
EmpDesignSystem/Tests/     — Sandbox app tests
```

## Targets

| Target | Product | Platform | Dependencies |
|--------|---------|----------|-------------|
| `EmpUI_iOS` | framework | iOS | — |
| `EmpUI_macOS` | framework | macOS | — |
| `EmpDesignSystem` | app | macOS | EmpUI_macOS |
| `EmpUI_iOSTests` | unitTests | iOS | EmpUI_iOS, SnapshotTesting |
| `EmpUI_macOSTests` | unitTests | macOS | EmpUI_macOS, SnapshotTesting |
| `EmpDesignSystemTests` | unitTests | macOS | EmpDesignSystem |

## Commands

```bash
# Install dependencies (required after changing Tuist/Package.swift)
mise exec -- tuist install

# Generate Xcode project (required before building)
mise exec -- tuist generate --no-open

# Build macOS sandbox (includes EmpUI_macOS)
mise exec -- tuist build EmpDesignSystem

# Build iOS framework
mise exec -- tuist build EmpUI_iOS

# Run macOS framework tests
mise exec -- tuist test EmpUI_macOS

# Run iOS framework tests
mise exec -- tuist test EmpUI_iOS

# Note: `tuist build`/`tuist test` takes scheme as positional argument, NOT --scheme flag
# Note: Test targets don't have their own schemes — use framework scheme (EmpUI_macOS, EmpUI_iOS)

# Lint (SwiftLint)
swiftlint

# Lint + autocorrect
swiftlint --fix

# Format (SwiftFormat)
swiftformat .
```

## File Organization

- **One file — one struct/class.** Nested types MUST be in separate files: `ClassName+NestedType.swift`
- Example: `CommonViewModel.swift`, `CommonViewModel+Border.swift`, `CommonViewModel+Shadow.swift`, `CommonViewModel+Corners.swift`
- Extensions on external types go to their own file: `NSEdgeInsets+Equatable.swift`

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
- CommonViewModel and all nested types conform to `Equatable` (auto-synthesized)
- macOS: `NSEdgeInsets` is NOT natively `Equatable` — extension in `NSEdgeInsets+Equatable.swift` provides conformance via `@retroactive`

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

## Testing

- **Swift Testing** — primary test framework (`import Testing`)
- `@Suite("Название")` — group related tests
- `@Test("Описание на русском языке")` — display name in Russian only
- `@Test(arguments:)` — only when >1 element in the array, otherwise inline the value in the test
- Function names — descriptive, no `test` prefix (e.g. `func defaultInitializer()`)
- `#expect` for assertions, `#require` for preconditions
- **swift-snapshot-testing** — for snapshot tests of component previews
- Test files need explicit `import AppKit` (macOS) or `import UIKit` (iOS) — `@testable import` does not re-export platform frameworks

## SourceKit False Positives

These diagnostics appear before `tuist generate` and are **not real errors**:

- `No such module 'ProjectDescription'` in Project.swift — Tuist provides this at generation time
- `No such module 'UIKit'` in EmpUI_iOS files — SourceKit runs in macOS context
- `No such module 'Testing'` in test files — resolved at build time
- `Cannot find type 'X' in scope` in `+NestedType.swift` extension files — same-module references resolve after generation
- `Cannot find 'ComponentName' in scope` in Preview files — same-module references resolve after generation

## SPM Distribution

This project is distributed as a Swift Package via `Package.swift` at the root. Two library products:
- `EmpUI_iOS` — iOS framework
- `EmpUI_macOS` — macOS framework

Consumer integration guide and full API reference are in `README.md`.

## Design Docs

Implementation plans and design documents are in `docs/plans/`.
