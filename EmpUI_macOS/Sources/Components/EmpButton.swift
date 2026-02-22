import AppKit

public final class EmpButton: NSView {
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

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let stackSize = contentStack.fittingSize
        guard let viewModel = currentViewModel else {
            return NSSize(width: stackSize.width, height: 32)
        }
        let margins = viewModel.common.normal.layoutMargins
        let hPadding = margins.left + margins.right
        return NSSize(width: stackSize.width + hPadding, height: viewModel.height)
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

    private func makeElementView(_ element: Content.Element) -> NSView {
        switch element {
        case let .icon(image, color, size):
            let imageView = NSImageView()
            imageView.image = image
            imageView.contentTintColor = color
            imageView.imageScaling = .scaleProportionallyUpOrDown
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: size),
                imageView.heightAnchor.constraint(equalToConstant: size),
            ])
            return imageView

        case let .text(string, color, font):
            let label = NSTextField(labelWithString: string)
            label.font = font
            label.textColor = color
            label.lineBreakMode = .byTruncatingTail
            return label

        case let .titleSubtitle(title, subtitle, titleColor, subtitleColor, titleFont, subtitleFont):
            let stack = NSStackView()
            stack.orientation = .vertical
            stack.alignment = .leading
            stack.spacing = 2

            let titleLabel = NSTextField(labelWithString: title)
            titleLabel.font = titleFont
            titleLabel.textColor = titleColor

            let subtitleLabel = NSTextField(labelWithString: subtitle)
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
                (view as? NSImageView)?.contentTintColor = color

            case let .text(_, color, font):
                if let label = view as? NSTextField {
                    label.textColor = color
                    label.font = font
                }

            case let .titleSubtitle(_, _, titleColor, subtitleColor, titleFont, subtitleFont):
                if let stack = view as? NSStackView {
                    if let title = stack.arrangedSubviews.first as? NSTextField {
                        title.textColor = titleColor
                        title.font = titleFont
                    }
                    if stack.arrangedSubviews.count > 1,
                       let subtitle = stack.arrangedSubviews[1] as? NSTextField {
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
}
