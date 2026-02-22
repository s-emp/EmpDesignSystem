# CommonViewModel Design

## Summary

Base configuration model for all design system components. Provides shared visual properties (border, shadow, corners, backgroundColor, layoutMargins) applied via a `UIView`/`NSView` extension.

## Decisions

- **Separate implementations** for iOS (UIKit) and macOS (AppKit)
- **All fields required** with default values in init (no optionals)
- **Nested structs** for grouping: `Border`, `Shadow`, `Corners`
- **No intermediate contentView** — content pins directly to `layoutMarginsGuide`

## Component Layout

```
EmpComponent (UIView/NSView)  ← apply(common:) sets border/shadow/corners/bg/layoutMargins on self
    └── content element        ← constrained to layoutMarginsGuide
```

`layoutMargins` on the root view creates the inset. Content is pinned to `layoutMarginsGuide`.

## CommonViewModel Structure

```swift
public struct CommonViewModel {
    public let border: Border
    public let shadow: Shadow
    public let corners: Corners
    public let backgroundColor: UIColor  // NSColor on macOS
    public let layoutMargins: UIEdgeInsets  // NSEdgeInsets on macOS

    public struct Border {
        public let width: CGFloat
        public let color: UIColor
        public let style: Style
        public enum Style { case solid, dashed }
        // defaults: width=0, color=.clear, style=.solid
    }

    public struct Shadow {
        public let color: UIColor
        public let offset: CGSize
        public let radius: CGFloat
        public let opacity: Float
        // defaults: color=.clear, offset=.zero, radius=0, opacity=0
    }

    public struct Corners {
        public let radius: CGFloat
        public let maskedCorners: CACornerMask
        // defaults: radius=0, maskedCorners=all four corners
    }

    // defaults: all sub-structs default, backgroundColor=.clear, layoutMargins=.zero
}
```

## apply(common:) Extension

`UIView` extension (iOS) / `NSView` extension (macOS):

```swift
extension UIView {
    func apply(common viewModel: CommonViewModel) {
        backgroundColor = viewModel.backgroundColor
        layoutMargins = viewModel.layoutMargins
        layer.cornerRadius = viewModel.corners.radius
        layer.maskedCorners = viewModel.corners.maskedCorners
        layer.borderWidth = viewModel.border.width
        layer.borderColor = viewModel.border.color.cgColor
        // dashed style: apply via CAShapeLayer
        layer.shadowColor = viewModel.shadow.color.cgColor
        layer.shadowOffset = viewModel.shadow.offset
        layer.shadowRadius = viewModel.shadow.radius
        layer.shadowOpacity = viewModel.shadow.opacity
    }
}
```

## ViewModel Requirement

Every component ViewModel MUST contain `common: CommonViewModel`:

```swift
public struct ViewModel {
    public let common: CommonViewModel
    public let title: String
    // component-specific fields...
}
```

Every `configure(with:)` MUST call `apply(common: viewModel.common)`.

## Component Setup Change

Content elements must be constrained to `layoutMarginsGuide` (not view edges):

```swift
// Before (wrong):
button.topAnchor.constraint(equalTo: topAnchor)

// After (correct):
button.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
```

## CLAUDE.md Updates

Add rules:
- Every ViewModel must contain `common: CommonViewModel`
- Content elements pin to `layoutMarginsGuide`, not view edges
- Every `configure(with:)` calls `apply(common: viewModel.common)`
- `apply(common:)` is a `UIView`/`NSView` extension, not a method on each component
