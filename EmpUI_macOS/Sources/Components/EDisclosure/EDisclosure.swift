import AppKit

public final class EDisclosure: NSView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel(title: "")
    public private(set) var contentView: NSView?
    public var onToggle: ((Bool) -> Void)?

    private let chevronImageView: NSImageView = {
        let config = NSImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = NSImage(systemSymbolName: "chevron.right", accessibilityDescription: nil)?
            .withSymbolConfiguration(config)
        let imageView = NSImageView(image: image ?? NSImage())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentTintColor = .labelColor
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private let titleField: NSTextField = {
        let field = NSTextField(labelWithString: "")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 13, weight: .medium)
        field.textColor = .labelColor
        field.isEditable = false
        field.isBezeled = false
        field.drawsBackground = false
        field.lineBreakMode = .byTruncatingTail
        return field
    }()

    private let headerStack: NSStackView = {
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 6
        return stack
    }()

    private let contentContainer: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let mainStack: NSStackView = {
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 0
        return stack
    }()

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        headerStack.addView(chevronImageView, in: .center)
        headerStack.addView(titleField, in: .center)

        mainStack.addView(headerStack, in: .center)
        mainStack.addView(contentContainer, in: .center)

        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: empLayoutMarginsGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: empLayoutMarginsGuide.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: empLayoutMarginsGuide.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: empLayoutMarginsGuide.bottomAnchor),

            headerStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),

            contentContainer.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
        ])

        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleToggle))
        headerStack.addGestureRecognizer(clickGesture)
    }

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        titleField.stringValue = viewModel.title

        let angle: CGFloat = viewModel.isExpanded ? .pi / 2 : 0
        chevronImageView.frameCenterRotation = -(angle * 180 / .pi)
        contentContainer.isHidden = !viewModel.isExpanded

        return self
    }

    public func setContent(_ view: NSView) {
        contentView?.removeFromSuperview()
        contentContainer.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
        ])
        contentView = view
    }

    @objc private func handleToggle() {
        let newExpanded = !viewModel.isExpanded
        onToggle?(newExpanded)
    }
}
