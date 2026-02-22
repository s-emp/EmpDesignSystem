# Component Patterns Reference

Code templates for EmpDesignSystem components. Replace `EmpX` with actual component name.

## Simple Component (macOS)

### EmpX.swift

```swift
import AppKit

public final class EmpX: NSView {
    // MARK: - UI Elements

    private let someElement: NSTextField = {
        let field = NSTextField(labelWithString: "")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        wantsLayer = true
        addSubview(someElement)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            someElement.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            someElement.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            someElement.topAnchor.constraint(equalTo: guide.topAnchor),
            someElement.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)
        // Component-specific configuration
    }
}
```

### EmpX ViewModel (inline for simple)

```swift
public extension EmpX {
    struct ViewModel {
        // MARK: Public

        public let common: CommonViewModel  // ALWAYS first
        public let text: String
        // ... component-specific fields

        public init(
            common: CommonViewModel = CommonViewModel(),
            text: String
        ) {
            self.common = common
            self.text = text
        }
    }
}
```

## Simple Component (iOS)

### EmpX.swift

```swift
import UIKit

public final class EmpX: UIView {
    // MARK: - UI Elements

    private let someElement: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(someElement)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            someElement.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            someElement.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            someElement.topAnchor.constraint(equalTo: guide.topAnchor),
            someElement.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)
        // Component-specific configuration
    }
}
```

## Interactive Component (macOS)

### EmpX+ViewModel.swift

```swift
import AppKit

public extension EmpX {
    struct ViewModel {
        public let common: ControlParameter<CommonViewModel>
        public let content: ControlParameter<Content>
        public let height: CGFloat
        public let spacing: CGFloat

        public init(
            common: ControlParameter<CommonViewModel>,
            content: ControlParameter<Content>,
            height: CGFloat,
            spacing: CGFloat
        ) {
            self.common = common
            self.content = content
            self.height = height
            self.spacing = spacing
        }
    }
}
```

### EmpX+Content.swift

```swift
import AppKit

public extension EmpX {
    struct Content {
        public let leading: Element?
        public let center: Element?
        public let trailing: Element?

        public init(
            leading: Element? = nil,
            center: Element? = nil,
            trailing: Element? = nil
        ) {
            self.leading = leading
            self.center = center
            self.trailing = trailing
        }

        // swiftlint:disable enum_case_associated_values_count
        public enum Element {
            case icon(NSImage, color: NSColor, size: CGFloat)
            case text(String, color: NSColor, font: NSFont)
            // Add component-specific cases
        }
        // swiftlint:enable enum_case_associated_values_count
    }
}
```

### EmpX.swift (interactive, macOS)

```swift
import AppKit

public final class EmpX: NSView {
    // MARK: - Action

    public var action: (() -> Void)?

    // MARK: - State

    public var isEnabled: Bool = true {
        didSet {
            updateAppearance()
            window?.invalidateCursorRects(for: self)
        }
    }

    private var isHovered = false
    private var isPressed = false
    private var currentViewModel: ViewModel?

    // MARK: - UI Elements

    private let contentStack: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Constraints

    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        wantsLayer = true
        addSubview(contentStack)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor),
        ])

        heightConstraint = heightAnchor.constraint(equalToConstant: 32)
        heightConstraint?.isActive = true

        setupTracking()
    }

    private func setupTracking() {
        let area = NSTrackingArea(
            rect: .zero,
            options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect],
            owner: self
        )
        addTrackingArea(area)
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        currentViewModel = viewModel
        heightConstraint?.constant = viewModel.height
        contentStack.spacing = viewModel.spacing
        layer?.masksToBounds = true
        rebuildContent(viewModel.content.normal)
        updateAppearance()
        invalidateIntrinsicContentSize()
    }

    // MARK: - State

    private var currentState: ControlState {
        if !isEnabled {
            return .disabled
        }
        if isPressed {
            return .highlighted
        }
        if isHovered {
            return .hover
        }
        return .normal
    }

    // MARK: - Appearance

    private func updateAppearance() {
        guard let viewModel = currentViewModel else { return }
        let state = currentState
        apply(common: viewModel.common[state])
        updateContent(viewModel.content[state])

        if !isEnabled {
            alphaValue = 0.4
        } else if isPressed {
            alphaValue = 0.7
        } else {
            alphaValue = 1.0
        }
    }

    override public func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateAppearance()
    }

    // MARK: - Cursor

    override public func resetCursorRects() {
        if isEnabled {
            addCursorRect(bounds, cursor: .pointingHand)
        }
    }

    // MARK: - Mouse Events

    override public func mouseEntered(with _: NSEvent) {
        guard isEnabled else { return }
        isHovered = true
        updateAppearance()
    }

    override public func mouseExited(with _: NSEvent) {
        isHovered = false
        updateAppearance()
    }

    override public func mouseDown(with _: NSEvent) {
        guard isEnabled else { return }
        isPressed = true
        updateAppearance()
    }

    override public func mouseUp(with event: NSEvent) {
        let wasPressed = isPressed
        isPressed = false
        updateAppearance()
        guard isEnabled, wasPressed else { return }
        if bounds.contains(convert(event.locationInWindow, from: nil)) {
            action?()
        }
    }

    // MARK: - Content (implement rebuildContent and updateContent)

    private func rebuildContent(_ content: Content) {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // Build views from content elements
    }

    private func updateContent(_ content: Content) {
        // Update colors/fonts in-place without rebuilding
    }
}
```

### EmpX+Preset.swift

```swift
import AppKit

// MARK: - EmpX.Preset

public extension EmpX {
    enum Preset {
        // MARK: Public

        public enum ColorVariant {
            case primary
            case danger
        }

        public enum Size {
            case small
            case medium
            case large
        }

        public struct ContentLayout {
            public let leading: ElementLayout?
            public let center: ElementLayout?
            public let trailing: ElementLayout?

            public init(
                leading: ElementLayout? = nil,
                center: ElementLayout? = nil,
                trailing: ElementLayout? = nil
            ) {
                self.leading = leading
                self.center = center
                self.trailing = trailing
            }

            // swiftlint:disable:next nesting
            public enum ElementLayout {
                case icon(NSImage)
                case text(String)
            }
        }

        // MARK: - Factory Methods

        public static func variant(
            _ colorVariant: ColorVariant,
            content: ContentLayout,
            size: Size = .medium
        ) -> ViewModel {
            let config = SizeConfig(for: size)
            let corners = CommonViewModel.Corners(radius: config.cornerRadius)
            let margins = config.margins

            // Build colors from NSColor.Semantic
            // Build styled content from ContentLayout
            // Return ViewModel with ControlParameter wrappers

            fatalError("Implement")
        }

        // MARK: Private

        private static func styledContent(
            from layout: ContentLayout,
            primaryColor: NSColor,
            secondaryColor: NSColor,
            config: SizeConfig
        ) -> Content {
            func style(_ element: ContentLayout.ElementLayout) -> Content.Element {
                styledElement(element, primaryColor: primaryColor, secondaryColor: secondaryColor, config: config)
            }
            return Content(
                leading: layout.leading.map { style($0) },
                center: layout.center.map { style($0) },
                trailing: layout.trailing.map { style($0) }
            )
        }

        private static func styledElement(
            _ element: ContentLayout.ElementLayout,
            primaryColor: NSColor,
            secondaryColor: NSColor,
            config: SizeConfig
        ) -> Content.Element {
            switch element {
            case let .icon(image):
                return .icon(image, color: primaryColor, size: config.iconSize)
            case let .text(string):
                return .text(string, color: primaryColor, font: config.font)
            }
        }
    }
}

// MARK: - SizeConfig

private struct SizeConfig {
    let height: CGFloat
    let font: NSFont
    let iconSize: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let cornerRadius: CGFloat
    let spacing: CGFloat

    var margins: NSEdgeInsets {
        NSEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
    }

    init(for size: EmpX.Preset.Size) {
        switch size {
        case .small:
            height = 24
            font = .systemFont(ofSize: 11, weight: .semibold)
            iconSize = 12
            horizontalPadding = EmpSpacing.xs.rawValue
            verticalPadding = EmpSpacing.xxs.rawValue
            cornerRadius = 4
            spacing = EmpSpacing.xxs.rawValue
        case .medium:
            height = 32
            font = .systemFont(ofSize: 13, weight: .semibold)
            iconSize = 14
            horizontalPadding = EmpSpacing.s.rawValue
            verticalPadding = EmpSpacing.xs.rawValue
            cornerRadius = 6
            spacing = EmpSpacing.xs.rawValue
        case .large:
            height = 40
            font = .systemFont(ofSize: 14, weight: .semibold)
            iconSize = 16
            horizontalPadding = EmpSpacing.m.rawValue
            verticalPadding = EmpSpacing.s.rawValue
            cornerRadius = 8
            spacing = EmpSpacing.xs.rawValue
        }
    }
}
```

## Preview Pattern

### macOS

```swift
import AppKit
import SwiftUI

// Simple component
@available(macOS 14.0, *)
#Preview("EmpX — Default") {
    let view = EmpX()
    let _ = view.configure(with: .init(text: "Hello"))
    view
}

// Interactive with Preset
@available(macOS 14.0, *)
#Preview("EmpX — Primary") {
    let view = EmpX()
    let _ = view.configure(with: EmpX.Preset.variant(.primary, content: .init(center: .text("Label"))))
    view
}

// With system image (extract to variable for swiftlint)
@available(macOS 14.0, *)
#Preview("EmpX — Icon") {
    let view = EmpX()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "star", accessibilityDescription: nil)!
    let _ = view.configure(with: EmpX.Preset.variant(.primary, content: .init(
        leading: .icon(icon),
        center: .text("Starred")
    )))
    view
}

// Disabled state
@available(macOS 14.0, *)
#Preview("EmpX — Disabled") {
    let view = EmpX()
    let _ = view.configure(with: EmpX.Preset.variant(.primary, content: .init(center: .text("Disabled"))))
    view.isEnabled = false
    return view
}
```

### iOS

```swift
import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EmpX — Default") {
    let view = EmpX()
    let _ = view.configure(with: .init(text: "Hello"))
    view
}
```

## Test Pattern

```swift
import AppKit  // or UIKit
import Testing
@testable import EmpUI_macOS  // or EmpUI_iOS

// MARK: - ViewModel

@Suite("EmpX.ViewModel")
struct EmpXViewModelTests {
    @Test("ViewModel сохраняет все поля")
    func storesFields() {
        let common = ControlParameter(normal: CommonViewModel())
        let content = ControlParameter(normal: EmpX.Content(
            center: .text("Test", color: .white, font: .systemFont(ofSize: 13))
        ))
        let sut = EmpX.ViewModel(
            common: common,
            content: content,
            height: 32,
            spacing: 8
        )

        #expect(sut.height == 32)
        #expect(sut.spacing == 8)
    }
}

// MARK: - Content

@Suite("EmpX.Content")
struct EmpXContentTests {
    @Test("Дефолтные значения Content — все nil")
    func defaultNils() {
        let sut = EmpX.Content()
        #expect(sut.leading == nil)
        #expect(sut.center == nil)
        #expect(sut.trailing == nil)
    }
}

// MARK: - Preset

@Suite("EmpX.Preset")
struct EmpXPresetTests {
    private let layout = EmpX.Preset.ContentLayout(center: .text("Test"))

    @Test("variant — задаёт корректный backgroundColor")
    func variantPreset() {
        let sut = EmpX.Preset.variant(.primary, content: layout)
        #expect(sut.common.normal.backgroundColor == NSColor.Semantic.actionPrimary)
    }

    @Test("size small — height 24")
    func sizeSmall() {
        let sut = EmpX.Preset.variant(.primary, content: layout, size: .small)
        #expect(sut.height == 24)
    }
}
```

## Platform Differences Cheatsheet

| Aspect | macOS | iOS |
|--------|-------|-----|
| Base class | `NSView` | `UIView` |
| Color | `NSColor` | `UIColor` |
| Semantic colors | `NSColor.Semantic.X` | `UIColor.Semantic.X` |
| Edge insets | `NSEdgeInsets` | `UIEdgeInsets` |
| Layout guide | `empLayoutMarginsGuide` | `layoutMarginsGuide` |
| Set margins | `empLayoutMargins = X` | `layoutMargins = X` |
| Image | `NSImage` | `UIImage` |
| Label | `NSTextField(labelWithString:)` | `UILabel()` |
| Image view | `NSImageView()` | `UIImageView()` |
| Stack | `NSStackView()` | `UIStackView()` |
| Stack orientation | `.orientation = .horizontal` | `.axis = .horizontal` |
| Tint color | `.contentTintColor = X` | `.tintColor = X` |
| Init | `init(frame frameRect: NSRect)` | `init(frame: CGRect)` |
| Layer setup | `wantsLayer = true` (required) | Not needed |
| Cursor | `resetCursorRects()` | Not needed |
| Hover | `mouseEntered/mouseExited` | Not available |
| Appearance change | `viewDidChangeEffectiveAppearance()` | `traitCollectionDidChange()` |
| Tracking area | Required for hover | Not needed |
| ControlState | normal, hover, highlighted, disabled | normal, highlighted, disabled |
| Preview availability | `@available(macOS 14.0, *)` | `@available(iOS 17.0, *)` |
| Test import | `import AppKit` | `import UIKit` |
| Test target | `@testable import EmpUI_macOS` | `@testable import EmpUI_iOS` |
