# CommonViewModel Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add CommonViewModel with border/shadow/corners/backgroundColor/layoutMargins support to all components, plus apply(common:) extension and updated CLAUDE.md rules.

**Architecture:** CommonViewModel is a struct with nested Border, Shadow, Corners sub-structs. Applied via UIView/NSView extension `apply(common:)`. Every component ViewModel gains a `common: CommonViewModel` field. Content elements pin to `layoutMarginsGuide` instead of view edges.

**Tech Stack:** Swift, UIKit (iOS), AppKit (macOS), Tuist 4.131.1

**Design doc:** `docs/plans/2026-02-22-common-viewmodel-design.md`

**Build commands:**
```bash
mise exec -- tuist generate --no-open
mise exec -- tuist build EmpDesignSystem   # macOS
mise exec -- tuist build EmpUI_iOS         # iOS
```

**Critical Preview rule:** In `#Preview` blocks, wrap `configure(with:)` calls with `let _ =` (result builder cannot handle Void). No explicit `return`.

---

### Task 1: Create CommonViewModel for iOS

**Files:**
- Create: `EmpUI_iOS/Sources/Common/CommonViewModel.swift`

**Step 1: Create the file**

```swift
import UIKit

public struct CommonViewModel {

    // MARK: - Properties

    public let border: Border
    public let shadow: Shadow
    public let corners: Corners
    public let backgroundColor: UIColor
    public let layoutMargins: UIEdgeInsets

    // MARK: - Init

    public init(
        border: Border = Border(),
        shadow: Shadow = Shadow(),
        corners: Corners = Corners(),
        backgroundColor: UIColor = .clear,
        layoutMargins: UIEdgeInsets = .zero
    ) {
        self.border = border
        self.shadow = shadow
        self.corners = corners
        self.backgroundColor = backgroundColor
        self.layoutMargins = layoutMargins
    }
}

// MARK: - Border

extension CommonViewModel {

    public struct Border {
        public let width: CGFloat
        public let color: UIColor
        public let style: Style

        public enum Style {
            case solid
            case dashed
        }

        public init(
            width: CGFloat = 0,
            color: UIColor = .clear,
            style: Style = .solid
        ) {
            self.width = width
            self.color = color
            self.style = style
        }
    }
}

// MARK: - Shadow

extension CommonViewModel {

    public struct Shadow {
        public let color: UIColor
        public let offset: CGSize
        public let radius: CGFloat
        public let opacity: Float

        public init(
            color: UIColor = .clear,
            offset: CGSize = .zero,
            radius: CGFloat = 0,
            opacity: Float = 0
        ) {
            self.color = color
            self.offset = offset
            self.radius = radius
            self.opacity = opacity
        }
    }
}

// MARK: - Corners

extension CommonViewModel {

    public struct Corners {
        public let radius: CGFloat
        public let maskedCorners: CACornerMask

        public init(
            radius: CGFloat = 0,
            maskedCorners: CACornerMask = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner,
            ]
        ) {
            self.radius = radius
            self.maskedCorners = maskedCorners
        }
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_iOS/Sources/Common/CommonViewModel.swift
git commit -m "feat(ios): add CommonViewModel struct"
```

---

### Task 2: Create apply(common:) extension for iOS

**Files:**
- Create: `EmpUI_iOS/Sources/Common/UIView+CommonViewModel.swift`

**Step 1: Create the extension file**

```swift
import UIKit

extension UIView {

    func apply(common viewModel: CommonViewModel) {
        // Background
        backgroundColor = viewModel.backgroundColor

        // Layout margins
        layoutMargins = viewModel.layoutMargins

        // Corners
        layer.cornerRadius = viewModel.corners.radius
        layer.maskedCorners = viewModel.corners.maskedCorners

        // Border
        switch viewModel.border.style {
        case .solid:
            removeDashedBorder()
            layer.borderWidth = viewModel.border.width
            layer.borderColor = viewModel.border.color.cgColor
        case .dashed:
            layer.borderWidth = 0
            applyDashedBorder(
                width: viewModel.border.width,
                color: viewModel.border.color,
                cornerRadius: viewModel.corners.radius
            )
        }

        // Shadow
        layer.shadowColor = viewModel.shadow.color.cgColor
        layer.shadowOffset = viewModel.shadow.offset
        layer.shadowRadius = viewModel.shadow.radius
        layer.shadowOpacity = viewModel.shadow.opacity

        // clipsToBounds must be false for shadow to render
        // but cornerRadius needs masksToBounds — use separate approach
        if viewModel.shadow.opacity > 0 {
            clipsToBounds = false
            layer.masksToBounds = false
        } else if viewModel.corners.radius > 0 {
            clipsToBounds = true
        }
    }

    // MARK: - Dashed Border Helpers

    private static var dashedBorderLayerKey: UInt8 = 0

    private var dashedBorderLayer: CAShapeLayer? {
        get { objc_getAssociatedObject(self, &UIView.dashedBorderLayerKey) as? CAShapeLayer }
        set { objc_setAssociatedObject(self, &UIView.dashedBorderLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private func applyDashedBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        removeDashedBorder()

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [6, 4]
        shapeLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
        shapeLayer.frame = bounds

        layer.addSublayer(shapeLayer)
        dashedBorderLayer = shapeLayer
    }

    private func removeDashedBorder() {
        dashedBorderLayer?.removeFromSuperlayer()
        dashedBorderLayer = nil
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_iOS/Sources/Common/UIView+CommonViewModel.swift
git commit -m "feat(ios): add UIView.apply(common:) extension"
```

---

### Task 3: Update EmpButton iOS — add common to ViewModel, pin to layoutMarginsGuide

**Files:**
- Modify: `EmpUI_iOS/Sources/Components/EmpButton.swift`

**Step 1: Update the file**

Replace entire contents of `EmpUI_iOS/Sources/Components/EmpButton.swift`:

```swift
import UIKit

public final class EmpButton: UIView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let common: CommonViewModel
        public let title: String
        public let style: Style

        public enum Style {
            case primary
            case secondary
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            title: String,
            style: Style
        ) {
            self.common = common
            self.title = title
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let button = UIButton(type: .system)

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            button.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        switch viewModel.style {
        case .primary:
            button.configuration = {
                var config = UIButton.Configuration.filled()
                config.title = viewModel.title
                config.baseBackgroundColor = .systemBlue
                config.baseForegroundColor = .white
                config.cornerStyle = .medium
                return config
            }()
        case .secondary:
            button.configuration = {
                var config = UIButton.Configuration.bordered()
                config.title = viewModel.title
                config.baseBackgroundColor = .clear
                config.baseForegroundColor = .systemBlue
                config.cornerStyle = .medium
                return config
            }()
        }
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_iOS/Sources/Components/EmpButton.swift
git commit -m "feat(ios): update EmpButton with CommonViewModel and layoutMarginsGuide"
```

---

### Task 4: Update EmpLabel iOS — add common to ViewModel, pin to layoutMarginsGuide

**Files:**
- Modify: `EmpUI_iOS/Sources/Components/EmpLabel.swift`

**Step 1: Update the file**

Replace entire contents of `EmpUI_iOS/Sources/Components/EmpLabel.swift`:

```swift
import UIKit

public final class EmpLabel: UIView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let common: CommonViewModel
        public let text: String
        public let style: Style

        public enum Style {
            case title
            case body
            case caption
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            text: String,
            style: Style
        ) {
            self.common = common
            self.text = text
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let label = UILabel()

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        label.text = viewModel.text

        switch viewModel.style {
        case .title:
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textColor = .label
        case .body:
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .label
        case .caption:
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textColor = .secondaryLabel
        }
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_iOS/Sources/Components/EmpLabel.swift
git commit -m "feat(ios): update EmpLabel with CommonViewModel and layoutMarginsGuide"
```

---

### Task 5: Update iOS Previews — add CommonViewModel test data

**Files:**
- Modify: `EmpUI_iOS/Sources/Preview/EmpButton+Preview.swift`
- Modify: `EmpUI_iOS/Sources/Preview/EmpLabel+Preview.swift`

**Step 1: Update EmpButton+Preview.swift**

Replace entire contents:

```swift
import UIKit
import SwiftUI

@available(iOS 17.0, *)
#Preview("EmpButton — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: .init(title: "Primary Action", style: .primary))
    button
}

@available(iOS 17.0, *)
#Preview("EmpButton — Secondary") {
    let button = EmpButton()
    let _ = button.configure(with: .init(title: "Secondary Action", style: .secondary))
    button
}

@available(iOS 17.0, *)
#Preview("EmpButton — With Common Styling") {
    let button = EmpButton()
    let _ = button.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 2, color: .systemBlue, style: .solid),
            shadow: .init(color: .black, offset: CGSize(width: 0, height: 2), radius: 4, opacity: 0.2),
            corners: .init(radius: 12),
            backgroundColor: .systemBackground,
            layoutMargins: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        ),
        title: "Styled Button",
        style: .primary
    ))
    button
}
```

**Step 2: Update EmpLabel+Preview.swift**

Replace entire contents:

```swift
import UIKit
import SwiftUI

@available(iOS 17.0, *)
#Preview("EmpLabel — Title") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Title Text", style: .title))
    label
}

@available(iOS 17.0, *)
#Preview("EmpLabel — Body") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Body text goes here. This is a longer piece of text.", style: .body))
    label
}

@available(iOS 17.0, *)
#Preview("EmpLabel — Caption") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Caption text", style: .caption))
    label
}

@available(iOS 17.0, *)
#Preview("EmpLabel — With Common Styling") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 1, color: .separator, style: .dashed),
            corners: .init(radius: 8),
            backgroundColor: .secondarySystemBackground,
            layoutMargins: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        ),
        text: "Styled label with padding and border",
        style: .body
    ))
    label
}
```

**Step 3: Commit**

```bash
git add EmpUI_iOS/Sources/Preview/EmpButton+Preview.swift EmpUI_iOS/Sources/Preview/EmpLabel+Preview.swift
git commit -m "feat(ios): update previews with CommonViewModel examples"
```

---

### Task 6: Create CommonViewModel for macOS

**Files:**
- Create: `EmpUI_macOS/Sources/Common/CommonViewModel.swift`

**Step 1: Create the file**

```swift
import AppKit

public struct CommonViewModel {

    // MARK: - Properties

    public let border: Border
    public let shadow: Shadow
    public let corners: Corners
    public let backgroundColor: NSColor
    public let layoutMargins: NSEdgeInsets

    // MARK: - Init

    public init(
        border: Border = Border(),
        shadow: Shadow = Shadow(),
        corners: Corners = Corners(),
        backgroundColor: NSColor = .clear,
        layoutMargins: NSEdgeInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    ) {
        self.border = border
        self.shadow = shadow
        self.corners = corners
        self.backgroundColor = backgroundColor
        self.layoutMargins = layoutMargins
    }
}

// MARK: - Border

extension CommonViewModel {

    public struct Border {
        public let width: CGFloat
        public let color: NSColor
        public let style: Style

        public enum Style {
            case solid
            case dashed
        }

        public init(
            width: CGFloat = 0,
            color: NSColor = .clear,
            style: Style = .solid
        ) {
            self.width = width
            self.color = color
            self.style = style
        }
    }
}

// MARK: - Shadow

extension CommonViewModel {

    public struct Shadow {
        public let color: NSColor
        public let offset: CGSize
        public let radius: CGFloat
        public let opacity: Float

        public init(
            color: NSColor = .clear,
            offset: CGSize = .zero,
            radius: CGFloat = 0,
            opacity: Float = 0
        ) {
            self.color = color
            self.offset = offset
            self.radius = radius
            self.opacity = opacity
        }
    }
}

// MARK: - Corners

extension CommonViewModel {

    public struct Corners {
        public let radius: CGFloat
        public let maskedCorners: CACornerMask

        public init(
            radius: CGFloat = 0,
            maskedCorners: CACornerMask = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner,
            ]
        ) {
            self.radius = radius
            self.maskedCorners = maskedCorners
        }
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_macOS/Sources/Common/CommonViewModel.swift
git commit -m "feat(macos): add CommonViewModel struct"
```

---

### Task 7: Create apply(common:) extension for macOS

**Files:**
- Create: `EmpUI_macOS/Sources/Common/NSView+CommonViewModel.swift`

**Step 1: Create the extension file**

Note: NSView requires `wantsLayer = true` for layer-backed drawing. NSView does not have `layoutMargins` natively — we store them manually and components use them in constraints.

```swift
import AppKit

extension NSView {

    private static var storedMarginsKey: UInt8 = 0

    var empLayoutMargins: NSEdgeInsets {
        get {
            (objc_getAssociatedObject(self, &NSView.storedMarginsKey) as? NSValue)?.edgeInsetsValue
                ?? NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        set {
            objc_setAssociatedObject(
                self,
                &NSView.storedMarginsKey,
                NSValue(edgeInsets: newValue),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    func apply(common viewModel: CommonViewModel) {
        wantsLayer = true
        guard let layer = layer else { return }

        // Background
        layer.backgroundColor = viewModel.backgroundColor.cgColor

        // Layout margins (stored for use in constraints)
        empLayoutMargins = viewModel.layoutMargins

        // Corners
        layer.cornerRadius = viewModel.corners.radius
        layer.maskedCorners = viewModel.corners.maskedCorners

        // Border
        switch viewModel.border.style {
        case .solid:
            removeDashedBorder()
            layer.borderWidth = viewModel.border.width
            layer.borderColor = viewModel.border.color.cgColor
        case .dashed:
            layer.borderWidth = 0
            applyDashedBorder(
                width: viewModel.border.width,
                color: viewModel.border.color,
                cornerRadius: viewModel.corners.radius
            )
        }

        // Shadow
        shadow = NSShadow()
        layer.shadowColor = viewModel.shadow.color.cgColor
        layer.shadowOffset = viewModel.shadow.offset
        layer.shadowRadius = viewModel.shadow.radius
        layer.shadowOpacity = viewModel.shadow.opacity
    }

    // MARK: - Dashed Border Helpers

    private static var dashedBorderLayerKey: UInt8 = 0

    private var dashedBorderLayer: CAShapeLayer? {
        get { objc_getAssociatedObject(self, &NSView.dashedBorderLayerKey) as? CAShapeLayer }
        set { objc_setAssociatedObject(self, &NSView.dashedBorderLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private func applyDashedBorder(width: CGFloat, color: NSColor, cornerRadius: CGFloat) {
        removeDashedBorder()
        wantsLayer = true

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [6, 4]
        shapeLayer.path = NSBezierPath(
            roundedRect: bounds,
            xRadius: cornerRadius,
            yRadius: cornerRadius
        ).cgPath
        shapeLayer.frame = bounds

        layer?.addSublayer(shapeLayer)
        dashedBorderLayer = shapeLayer
    }

    private func removeDashedBorder() {
        dashedBorderLayer?.removeFromSuperlayer()
        dashedBorderLayer = nil
    }
}

// MARK: - NSBezierPath to CGPath

extension NSBezierPath {

    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0..<elementCount {
            let type = element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            case .cubicCurveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .quadraticCurveTo:
                path.addQuadCurve(to: points[1], control: points[0])
            @unknown default:
                break
            }
        }

        return path
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_macOS/Sources/Common/NSView+CommonViewModel.swift
git commit -m "feat(macos): add NSView.apply(common:) extension"
```

---

### Task 8: Update EmpButton macOS — add common to ViewModel

**Files:**
- Modify: `EmpUI_macOS/Sources/Components/EmpButton.swift`

**Step 1: Update the file**

Replace entire contents of `EmpUI_macOS/Sources/Components/EmpButton.swift`:

```swift
import AppKit

public final class EmpButton: NSView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let common: CommonViewModel
        public let title: String
        public let style: Style

        public enum Style {
            case primary
            case secondary
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            title: String,
            style: Style
        ) {
            self.common = common
            self.title = title
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let button = NSButton()

    // MARK: - Constraints (updated by apply)

    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        button.bezelStyle = .rounded
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        let top = button.topAnchor.constraint(equalTo: topAnchor)
        let leading = button.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = button.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = button.bottomAnchor.constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([top, leading, trailing, bottom])

        topConstraint = top
        leadingConstraint = leading
        trailingConstraint = trailing
        bottomConstraint = bottom
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)
        applyMargins(viewModel.common.layoutMargins)

        button.title = viewModel.title

        switch viewModel.style {
        case .primary:
            button.bezelColor = .controlAccentColor
            button.contentTintColor = .white
        case .secondary:
            button.bezelColor = nil
            button.contentTintColor = .controlAccentColor
        }
    }

    private func applyMargins(_ margins: NSEdgeInsets) {
        topConstraint?.constant = margins.top
        leadingConstraint?.constant = margins.left
        trailingConstraint?.constant = -margins.right
        bottomConstraint?.constant = -margins.bottom
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_macOS/Sources/Components/EmpButton.swift
git commit -m "feat(macos): update EmpButton with CommonViewModel"
```

---

### Task 9: Update EmpLabel macOS — add common to ViewModel

**Files:**
- Modify: `EmpUI_macOS/Sources/Components/EmpLabel.swift`

**Step 1: Update the file**

Replace entire contents of `EmpUI_macOS/Sources/Components/EmpLabel.swift`:

```swift
import AppKit

public final class EmpLabel: NSView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let common: CommonViewModel
        public let text: String
        public let style: Style

        public enum Style {
            case title
            case body
            case caption
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            text: String,
            style: Style
        ) {
            self.common = common
            self.text = text
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let textField = NSTextField(labelWithString: "")

    // MARK: - Constraints (updated by apply)

    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        textField.isEditable = false
        textField.isBordered = false
        textField.drawsBackground = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        let top = textField.topAnchor.constraint(equalTo: topAnchor)
        let leading = textField.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = textField.bottomAnchor.constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([top, leading, trailing, bottom])

        topConstraint = top
        leadingConstraint = leading
        trailingConstraint = trailing
        bottomConstraint = bottom
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)
        applyMargins(viewModel.common.layoutMargins)

        textField.stringValue = viewModel.text

        switch viewModel.style {
        case .title:
            textField.font = .systemFont(ofSize: 24, weight: .bold)
            textField.textColor = .labelColor
        case .body:
            textField.font = .systemFont(ofSize: 16, weight: .regular)
            textField.textColor = .labelColor
        case .caption:
            textField.font = .systemFont(ofSize: 12, weight: .regular)
            textField.textColor = .secondaryLabelColor
        }
    }

    private func applyMargins(_ margins: NSEdgeInsets) {
        topConstraint?.constant = margins.top
        leadingConstraint?.constant = margins.left
        trailingConstraint?.constant = -margins.right
        bottomConstraint?.constant = -margins.bottom
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_macOS/Sources/Components/EmpLabel.swift
git commit -m "feat(macos): update EmpLabel with CommonViewModel"
```

---

### Task 10: Update macOS Previews — add CommonViewModel test data

**Files:**
- Modify: `EmpUI_macOS/Sources/Preview/EmpButton+Preview.swift`
- Modify: `EmpUI_macOS/Sources/Preview/EmpLabel+Preview.swift`

**Step 1: Update EmpButton+Preview.swift**

Replace entire contents:

```swift
import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpButton — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: .init(title: "Primary Action", style: .primary))
    button
}

@available(macOS 14.0, *)
#Preview("EmpButton — Secondary") {
    let button = EmpButton()
    let _ = button.configure(with: .init(title: "Secondary Action", style: .secondary))
    button
}

@available(macOS 14.0, *)
#Preview("EmpButton — With Common Styling") {
    let button = EmpButton()
    let _ = button.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 2, color: .controlAccentColor, style: .solid),
            shadow: .init(color: .black, offset: CGSize(width: 0, height: 2), radius: 4, opacity: 0.2),
            corners: .init(radius: 12),
            backgroundColor: .windowBackgroundColor,
            layoutMargins: NSEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        ),
        title: "Styled Button",
        style: .primary
    ))
    button
}
```

**Step 2: Update EmpLabel+Preview.swift**

Replace entire contents:

```swift
import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpLabel — Title") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Title Text", style: .title))
    label
}

@available(macOS 14.0, *)
#Preview("EmpLabel — Body") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Body text goes here. This is a longer piece of text.", style: .body))
    label
}

@available(macOS 14.0, *)
#Preview("EmpLabel — Caption") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Caption text", style: .caption))
    label
}

@available(macOS 14.0, *)
#Preview("EmpLabel — With Common Styling") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 1, color: .separatorColor, style: .dashed),
            corners: .init(radius: 8),
            backgroundColor: .controlBackgroundColor,
            layoutMargins: NSEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        ),
        text: "Styled label with padding and border",
        style: .body
    ))
    label
}
```

**Step 3: Commit**

```bash
git add EmpUI_macOS/Sources/Preview/EmpButton+Preview.swift EmpUI_macOS/Sources/Preview/EmpLabel+Preview.swift
git commit -m "feat(macos): update previews with CommonViewModel examples"
```

---

### Task 11: Update CLAUDE.md — add component architecture rules

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Add new sections to CLAUDE.md**

Add after the "Component Pattern" section:

```markdown
## Component Architecture

Every component follows this layout:

```
EmpComponent (UIView/NSView)  ← apply(common:) sets border/shadow/corners/bg/layoutMargins
    └── content element        ← constrained to layoutMarginsGuide (iOS) or manual margins (macOS)
```

### Rules

- Every `ViewModel` MUST contain `common: CommonViewModel` as the first field
- Every `configure(with:)` MUST call `apply(common: viewModel.common)` first
- Content elements MUST be constrained to `layoutMarginsGuide` (iOS) — not to view edges
- On macOS, NSView has no `layoutMarginsGuide` — use stored constraint references and `applyMargins()` helper
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
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add component architecture rules to CLAUDE.md"
```

---

### Task 12: Verify — tuist generate + build both platforms

**Step 1: Generate**

```bash
mise exec -- tuist generate --no-open
```

**Step 2: Build macOS**

```bash
mise exec -- tuist build EmpDesignSystem
```
Expected: Build Succeeded

**Step 3: Build iOS**

```bash
mise exec -- tuist build EmpUI_iOS
```
Expected: Build Succeeded

**Step 4: Commit fixes if needed**

```bash
git add -A
git commit -m "fix: resolve build issues from CommonViewModel integration"
```
