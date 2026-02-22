# EmpButton iOS Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Реализовать полнофункциональную кнопку EmpButton для iOS — зеркало macOS-версии с iOS-адаптациями (UIHoverGestureRecognizer, touch handling, iOS-размеры).

**Architecture:** UIView с UIStackView для контента, ControlParameter<T> для мульти-стейт стилей, Preset-система для удобного создания (filled/base/outlined/ghost × primary/danger × S/M/L). Hover через UIHoverGestureRecognizer (iPad + trackpad).

**Tech Stack:** Swift, UIKit, EmpSpacing, UIColor.Semantic

---

### Task 1: Создать ControlParameter

**Files:**
- Create: `EmpUI_iOS/Sources/Common/ControlParameter.swift`

**Step 1: Создать файл ControlParameter.swift**

Точная копия macOS-версии — тип платформонезависимый (import Foundation).

```swift
import Foundation

public enum ControlState {
    case normal
    case hover
    case highlighted
    case disabled
}

public struct ControlParameter<T> {
    public let normal: T
    public let hover: T
    public let highlighted: T
    public let disabled: T

    public init(
        normal: T,
        hover: T? = nil,
        highlighted: T? = nil,
        disabled: T? = nil
    ) {
        self.normal = normal
        self.hover = hover ?? normal
        self.highlighted = highlighted ?? normal
        self.disabled = disabled ?? normal
    }

    public subscript(state: ControlState) -> T {
        switch state {
        case .normal:
            return normal
        case .hover:
            return hover
        case .highlighted:
            return highlighted
        case .disabled:
            return disabled
        }
    }
}

extension ControlParameter: Equatable where T: Equatable { }
```

**Step 2: Собрать iOS-фреймворк**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS`
Expected: BUILD SUCCEEDED

---

### Task 2: Создать EmpButton+Content

**Files:**
- Create: `EmpUI_iOS/Sources/Components/EmpButton+Content.swift`

**Step 1: Создать файл EmpButton+Content.swift**

```swift
import UIKit

public extension EmpButton {
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
            case icon(UIImage, color: UIColor, size: CGFloat)
            case text(String, color: UIColor, font: UIFont)
            case titleSubtitle(
                title: String,
                subtitle: String,
                titleColor: UIColor,
                subtitleColor: UIColor,
                titleFont: UIFont,
                subtitleFont: UIFont
            )
        }
        // swiftlint:enable enum_case_associated_values_count
    }
}
```

**Step 2: Собрать (сборка пока упадёт — EmpButton ещё старый, это ок)**

Сборку проверим после Task 4.

---

### Task 3: Создать EmpButton+ViewModel

**Files:**
- Create: `EmpUI_iOS/Sources/Components/EmpButton+ViewModel.swift`

**Step 1: Создать файл EmpButton+ViewModel.swift**

```swift
import UIKit

public extension EmpButton {
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

---

### Task 4: Переписать EmpButton.swift

**Files:**
- Modify: `EmpUI_iOS/Sources/Components/EmpButton.swift` (полная замена)

**Step 1: Заменить содержимое EmpButton.swift**

```swift
import UIKit

public final class EmpButton: UIView {
    // MARK: - Action

    public var action: (() -> Void)?

    // MARK: - State

    public var isEnabled: Bool = true {
        didSet {
            updateAppearance()
        }
    }

    private var isHovered = false
    private var isPressed = false
    private var currentViewModel: ViewModel?

    // MARK: - UI Elements

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Constraints

    private var heightConstraint: NSLayoutConstraint?

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
        addSubview(contentStack)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor),
        ])

        heightConstraint = heightAnchor.constraint(equalToConstant: 44)
        heightConstraint?.isActive = true

        setupHover()
    }

    private func setupHover() {
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        addGestureRecognizer(hover)
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        currentViewModel = viewModel

        heightConstraint?.constant = viewModel.height
        contentStack.spacing = viewModel.spacing

        layer.masksToBounds = true

        rebuildContent(viewModel.content.normal)
        updateAppearance()
        invalidateIntrinsicContentSize()
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: CGSize {
        let stackSize = contentStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        guard let viewModel = currentViewModel else {
            return CGSize(width: stackSize.width, height: 44)
        }
        let margins = viewModel.common.normal.layoutMargins
        let hPadding = margins.left + margins.right
        return CGSize(width: stackSize.width + hPadding, height: viewModel.height)
    }

    // MARK: - Content

    private func rebuildContent(_ content: Content) {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if let leading = content.leading {
            contentStack.addArrangedSubview(makeElementView(leading))
        }
        if let center = content.center {
            contentStack.addArrangedSubview(makeElementView(center))
        }
        if let trailing = content.trailing {
            contentStack.addArrangedSubview(makeElementView(trailing))
        }
    }

    private func makeElementView(_ element: Content.Element) -> UIView {
        switch element {
        case let .icon(image, color, size):
            let imageView = UIImageView()
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: size),
                imageView.heightAnchor.constraint(equalToConstant: size),
            ])
            return imageView

        case let .text(string, color, font):
            let label = UILabel()
            label.text = string
            label.font = font
            label.textColor = color
            label.lineBreakMode = .byTruncatingTail
            return label

        case let .titleSubtitle(title, subtitle, titleColor, subtitleColor, titleFont, subtitleFont):
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .leading
            stack.spacing = 2

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = titleFont
            titleLabel.textColor = titleColor

            let subtitleLabel = UILabel()
            subtitleLabel.text = subtitle
            subtitleLabel.font = subtitleFont
            subtitleLabel.textColor = subtitleColor

            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(subtitleLabel)
            return stack
        }
    }

    private func updateContent(_ content: Content) {
        let elements: [Content.Element] = [content.leading, content.center, content.trailing].compactMap { $0 }

        guard contentStack.arrangedSubviews.count == elements.count else {
            rebuildContent(content)
            return
        }

        for (view, element) in zip(contentStack.arrangedSubviews, elements) {
            switch element {
            case let .icon(_, color, _):
                (view as? UIImageView)?.tintColor = color

            case let .text(_, color, font):
                if let label = view as? UILabel {
                    label.textColor = color
                    label.font = font
                }

            case let .titleSubtitle(_, _, titleColor, subtitleColor, titleFont, subtitleFont):
                if let stack = view as? UIStackView {
                    if let title = stack.arrangedSubviews.first as? UILabel {
                        title.textColor = titleColor
                        title.font = titleFont
                    }
                    if stack.arrangedSubviews.count > 1,
                       let subtitle = stack.arrangedSubviews[1] as? UILabel {
                        subtitle.textColor = subtitleColor
                        subtitle.font = subtitleFont
                    }
                }
            }
        }
    }

    // MARK: - State

    private var currentState: ControlState {
        if !isEnabled { return .disabled }
        if isPressed { return .highlighted }
        if isHovered { return .hover }
        return .normal
    }

    // MARK: - Appearance

    private func updateAppearance() {
        guard let viewModel = currentViewModel else { return }

        let state = currentState
        apply(common: viewModel.common[state])
        updateContent(viewModel.content[state])

        if !isEnabled {
            alpha = 0.4
        } else if isPressed {
            alpha = 0.7
        } else {
            alpha = 1.0
        }
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
        }
    }

    // MARK: - Hover

    @objc private func handleHover(_ recognizer: UIHoverGestureRecognizer) {
        guard isEnabled else { return }
        switch recognizer.state {
        case .began, .changed:
            isHovered = true
        case .ended, .cancelled:
            isHovered = false
        default:
            break
        }
        updateAppearance()
    }

    // MARK: - Touch Events

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isEnabled else { return }
        isPressed = true
        updateAppearance()
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard isEnabled, let touch = touches.first else { return }
        let inside = bounds.contains(touch.location(in: self))
        if isPressed != inside {
            isPressed = inside
            updateAppearance()
        }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let wasPressed = isPressed
        isPressed = false
        updateAppearance()

        guard isEnabled, wasPressed, let touch = touches.first else { return }
        if bounds.contains(touch.location(in: self)) {
            action?()
        }
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isPressed = false
        updateAppearance()
    }
}
```

**Step 2: Собрать iOS-фреймворк**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS`
Expected: BUILD SUCCEEDED

---

### Task 5: Создать EmpButton+Preset

**Files:**
- Create: `EmpUI_iOS/Sources/Components/EmpButton+Preset.swift`

**Step 1: Создать файл EmpButton+Preset.swift**

Размеры адаптированы под iOS (больше чем macOS для touch-таргетов): S=36, M=44, L=50.

```swift
import UIKit

// MARK: - EmpButton.Preset

public extension EmpButton {
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
                case icon(UIImage)
                case text(String)
                case titleSubtitle(title: String, subtitle: String)
            }
        }

        // MARK: - Filled

        public static func filled(
            _ colorVariant: ColorVariant,
            content: ContentLayout,
            size: Size = .medium
        ) -> ViewModel {
            let config = SizeConfig(for: size)
            let corners = CommonViewModel.Corners(radius: config.cornerRadius)
            let margins = config.margins

            let action = actionColor(for: colorVariant)
            let hover = hoverColor(for: colorVariant)

            let styledContent = styledContent(
                from: content,
                primaryColor: UIColor.Semantic.textPrimaryInverted,
                secondaryColor: UIColor.Semantic.textSecondaryInverted,
                config: config
            )

            return ViewModel(
                common: ControlParameter(
                    normal: CommonViewModel(corners: corners, backgroundColor: action, layoutMargins: margins),
                    hover: CommonViewModel(corners: corners, backgroundColor: hover, layoutMargins: margins)
                ),
                content: ControlParameter(normal: styledContent),
                height: config.height,
                spacing: config.spacing
            )
        }

        // MARK: - Base

        public static func base(
            _ colorVariant: ColorVariant,
            content: ContentLayout,
            size: Size = .medium
        ) -> ViewModel {
            let config = SizeConfig(for: size)
            let corners = CommonViewModel.Corners(radius: config.cornerRadius)
            let margins = config.margins

            let bg = baseColor(for: colorVariant)
            let hoverBg = baseHoverColor(for: colorVariant)
            let colors = contentColors(for: colorVariant)

            let styledContent = styledContent(
                from: content,
                primaryColor: colors.primary,
                secondaryColor: colors.secondary,
                config: config
            )

            return ViewModel(
                common: ControlParameter(
                    normal: CommonViewModel(corners: corners, backgroundColor: bg, layoutMargins: margins),
                    hover: CommonViewModel(corners: corners, backgroundColor: hoverBg, layoutMargins: margins)
                ),
                content: ControlParameter(normal: styledContent),
                height: config.height,
                spacing: config.spacing
            )
        }

        // MARK: - Outlined

        public static func outlined(
            _ colorVariant: ColorVariant,
            content: ContentLayout,
            size: Size = .medium
        ) -> ViewModel {
            let config = SizeConfig(for: size)
            let corners = CommonViewModel.Corners(radius: config.cornerRadius)
            let margins = config.margins

            let action = actionColor(for: colorVariant)
            let tint = tintColor(for: colorVariant)
            let border = CommonViewModel.Border(width: 1, color: action, style: .solid)

            let styledContent = styledContent(
                from: content,
                primaryColor: action,
                secondaryColor: action,
                config: config
            )

            return ViewModel(
                common: ControlParameter(
                    normal: CommonViewModel(border: border, corners: corners, layoutMargins: margins),
                    hover: CommonViewModel(border: border, corners: corners, backgroundColor: tint, layoutMargins: margins)
                ),
                content: ControlParameter(normal: styledContent),
                height: config.height,
                spacing: config.spacing
            )
        }

        // MARK: - Ghost

        public static func ghost(
            _ colorVariant: ColorVariant,
            content: ContentLayout,
            size: Size = .medium
        ) -> ViewModel {
            let config = SizeConfig(for: size)
            let corners = CommonViewModel.Corners(radius: config.cornerRadius)
            let margins = config.margins

            let tint = tintColor(for: colorVariant)
            let colors = contentColors(for: colorVariant)

            let styledContent = styledContent(
                from: content,
                primaryColor: colors.primary,
                secondaryColor: colors.secondary,
                config: config
            )

            return ViewModel(
                common: ControlParameter(
                    normal: CommonViewModel(corners: corners, layoutMargins: margins),
                    hover: CommonViewModel(corners: corners, backgroundColor: tint, layoutMargins: margins)
                ),
                content: ControlParameter(normal: styledContent),
                height: config.height,
                spacing: config.spacing
            )
        }

        // MARK: Private

        // MARK: - Content Builder

        private static func styledContent(
            from layout: ContentLayout,
            primaryColor: UIColor,
            secondaryColor: UIColor,
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
            primaryColor: UIColor,
            secondaryColor: UIColor,
            config: SizeConfig
        ) -> Content.Element {
            switch element {
            case let .icon(image):
                return .icon(image, color: primaryColor, size: config.iconSize)
            case let .text(string):
                return .text(string, color: primaryColor, font: config.font)
            case let .titleSubtitle(title, subtitle):
                return .titleSubtitle(
                    title: title,
                    subtitle: subtitle,
                    titleColor: primaryColor,
                    subtitleColor: secondaryColor,
                    titleFont: config.font,
                    subtitleFont: config.secondaryFont
                )
            }
        }

        // MARK: - Color Helpers

        private static func actionColor(for variant: ColorVariant) -> UIColor {
            switch variant {
            case .primary:
                return UIColor.Semantic.actionPrimary
            case .danger:
                return UIColor.Semantic.actionDanger
            }
        }

        private static func hoverColor(for variant: ColorVariant) -> UIColor {
            switch variant {
            case .primary:
                return UIColor.Semantic.actionPrimaryHover
            case .danger:
                return UIColor.Semantic.actionDangerHover
            }
        }

        private static func tintColor(for variant: ColorVariant) -> UIColor {
            switch variant {
            case .primary:
                return UIColor.Semantic.actionPrimaryTint
            case .danger:
                return UIColor.Semantic.actionDangerTint
            }
        }

        private static func baseColor(for variant: ColorVariant) -> UIColor {
            switch variant {
            case .primary:
                return UIColor.Semantic.actionPrimaryBase
            case .danger:
                return UIColor.Semantic.actionDangerBase
            }
        }

        private static func baseHoverColor(for variant: ColorVariant) -> UIColor {
            switch variant {
            case .primary:
                return UIColor.Semantic.actionPrimaryBaseHover
            case .danger:
                return UIColor.Semantic.actionDangerBaseHover
            }
        }

        private static func contentColors(for variant: ColorVariant) -> (primary: UIColor, secondary: UIColor) {
            switch variant {
            case .primary:
                return (UIColor.Semantic.textPrimary, UIColor.Semantic.textSecondary)
            case .danger:
                return (UIColor.Semantic.actionDanger, UIColor.Semantic.actionDanger)
            }
        }
    }
}

// MARK: - SizeConfig

private struct SizeConfig {
    let height: CGFloat
    let font: UIFont
    let secondaryFont: UIFont
    let iconSize: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let cornerRadius: CGFloat
    let spacing: CGFloat

    var margins: UIEdgeInsets {
        UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
    }

    init(for size: EmpButton.Preset.Size) {
        switch size {
        case .small:
            height = 36
            font = .systemFont(ofSize: 12, weight: .semibold)
            secondaryFont = .systemFont(ofSize: 10)
            iconSize = 14
            horizontalPadding = EmpSpacing.s.rawValue
            verticalPadding = EmpSpacing.xs.rawValue
            cornerRadius = 6
            spacing = EmpSpacing.xs.rawValue
        case .medium:
            height = 44
            font = .systemFont(ofSize: 14, weight: .semibold)
            secondaryFont = .systemFont(ofSize: 12)
            iconSize = 16
            horizontalPadding = EmpSpacing.m.rawValue
            verticalPadding = EmpSpacing.s.rawValue
            cornerRadius = 8
            spacing = EmpSpacing.xs.rawValue
        case .large:
            height = 50
            font = .systemFont(ofSize: 16, weight: .semibold)
            secondaryFont = .systemFont(ofSize: 14)
            iconSize = 20
            horizontalPadding = EmpSpacing.l.rawValue
            verticalPadding = EmpSpacing.m.rawValue
            cornerRadius = 10
            spacing = EmpSpacing.s.rawValue
        }
    }
}
```

**Step 2: Собрать iOS-фреймворк**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS`
Expected: BUILD SUCCEEDED

---

### Task 6: Обновить EmpButton+Preview

**Files:**
- Modify: `EmpUI_iOS/Sources/Preview/EmpButton+Preview.swift` (полная замена)

**Step 1: Заменить содержимое EmpButton+Preview.swift**

```swift
import SwiftUI
import UIKit

// MARK: - Styles

@available(iOS 17.0, *)
#Preview("Filled — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Filled Primary"))))
    button
}

@available(iOS 17.0, *)
#Preview("Base — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.base(.primary, content: .init(center: .text("Base Primary"))))
    button
}

@available(iOS 17.0, *)
#Preview("Outlined — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.outlined(.primary, content: .init(center: .text("Outlined Primary"))))
    button
}

@available(iOS 17.0, *)
#Preview("Ghost — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.ghost(.primary, content: .init(center: .text("Ghost Primary"))))
    button
}

// MARK: - Danger

@available(iOS 17.0, *)
#Preview("Filled — Danger") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.danger, content: .init(center: .text("Delete"))))
    button
}

@available(iOS 17.0, *)
#Preview("Base — Danger") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.base(.danger, content: .init(center: .text("Delete"))))
    button
}

@available(iOS 17.0, *)
#Preview("Outlined — Danger") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.outlined(.danger, content: .init(center: .text("Delete"))))
    button
}

// MARK: - Sizes

@available(iOS 17.0, *)
#Preview("Size — Small") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Small")), size: .small))
    button
}

@available(iOS 17.0, *)
#Preview("Size — Medium") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Medium"))))
    button
}

@available(iOS 17.0, *)
#Preview("Size — Large") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Large")), size: .large))
    button
}

// MARK: - Content Variants

@available(iOS 17.0, *)
#Preview("Icon + Text") {
    let button = EmpButton()
    let icon = UIImage(systemName: "lock.fill")!  // swiftlint:disable:this force_unwrapping
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(
        leading: .icon(icon),
        center: .text("Sign In")
    )))
    button
}

@available(iOS 17.0, *)
#Preview("Text + Icon") {
    let button = EmpButton()
    let icon = UIImage(systemName: "arrow.right")!  // swiftlint:disable:this force_unwrapping
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(
        center: .text("Next"),
        trailing: .icon(icon)
    )))
    button
}

@available(iOS 17.0, *)
#Preview("Icon Only") {
    let button = EmpButton()
    let icon = UIImage(systemName: "plus")!  // swiftlint:disable:this force_unwrapping
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(
        center: .icon(icon)
    )))
    button
}

@available(iOS 17.0, *)
#Preview("Title + Subtitle") {
    let button = EmpButton()
    let icon = UIImage(systemName: "person.fill")!  // swiftlint:disable:this force_unwrapping
    let _ = button.configure(with: EmpButton.Preset.filled(
        .primary,
        content: .init(
            leading: .icon(icon),
            center: .titleSubtitle(title: "Profile", subtitle: "Settings")
        ),
        size: .large
    ))
    button
}

// MARK: - Disabled

@available(iOS 17.0, *)
#Preview("Disabled") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Disabled"))))
    button.isEnabled = false
    return button
}
```

**Step 2: Собрать и прогнать линтер**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS`
Expected: BUILD SUCCEEDED

Run: `cd /Users/emp15/Developer/EmpDesignSystem && swiftlint`
Expected: No errors (warnings допустимы)

---

### Task 7: Финальная проверка

**Step 1: Полная сборка iOS-фреймворка**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS`
Expected: BUILD SUCCEEDED

**Step 2: Прогнать тесты iOS**

Run: `mise exec -- tuist test EmpUI_iOS`
Expected: All tests passed (существующие тесты не должны сломаться)

**Step 3: SwiftFormat + SwiftLint**

Run: `cd /Users/emp15/Developer/EmpDesignSystem && swiftformat . && swiftlint`
Expected: Clean
