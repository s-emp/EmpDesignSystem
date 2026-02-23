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
        case let .text(viewModel):
            let empText = EmpText()
            empText.configure(with: viewModel)
            return empText

        case let .icon(viewModel):
            let empImage = EmpImage()
            empImage.configure(with: viewModel)
            return empImage

        case let .titleSubtitle(titleVM, subtitleVM):
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .leading
            stack.spacing = 2

            let titleText = EmpText()
            titleText.configure(with: titleVM)

            let subtitleText = EmpText()
            subtitleText.configure(with: subtitleVM)

            stack.addArrangedSubview(titleText)
            stack.addArrangedSubview(subtitleText)
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
            case let .text(viewModel):
                (view as? EmpText)?.configure(with: viewModel)

            case let .icon(viewModel):
                (view as? EmpImage)?.configure(with: viewModel)

            case let .titleSubtitle(titleVM, subtitleVM):
                if let stack = view as? UIStackView {
                    (stack.arrangedSubviews.first as? EmpText)?.configure(with: titleVM)
                    if stack.arrangedSubviews.count > 1, let subtitle = stack.arrangedSubviews[1] as? EmpText {
                        subtitle.configure(with: subtitleVM)
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

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: EmpButton, _: UITraitCollection) in
                view.updateAppearance()
            }
        }
    }

    // MARK: - Hover

    @objc
    private func handleHover(_ recognizer: UIHoverGestureRecognizer) {
        guard isEnabled else { return }
        switch recognizer.state {
        case .began, .changed:
            isHovered = true
        case .cancelled, .ended:
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
