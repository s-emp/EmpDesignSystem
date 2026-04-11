import AppKit

public final class EIcon: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel(source: .sfSymbol("questionmark"), size: 0)

    // MARK: - UI Elements

    private let imageView: NSImageView = {
        let iv = NSImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.imageFrameStyle = .none
        iv.isEditable = false
        iv.imageAlignment = .alignCenter
        iv.imageScaling = .scaleProportionallyUpOrDown
        return iv
    }()

    // MARK: - Constraints

    private var widthConstraint: NSLayoutConstraint?
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
        addSubview(imageView)

        let guide = empLayoutMarginsGuide
        let wc = imageView.widthAnchor.constraint(equalToConstant: 0)
        let hc = imageView.heightAnchor.constraint(equalToConstant: 0)
        widthConstraint = wc
        heightConstraint = hc

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: guide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            wc,
            hc,
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        let image: NSImage?
        switch viewModel.source {
        case let .sfSymbol(name):
            image = NSImage(systemSymbolName: name, accessibilityDescription: nil)?
                .withSymbolConfiguration(.init(pointSize: viewModel.size, weight: .regular))
        case let .named(name):
            image = NSImage(named: name)
        }

        imageView.contentTintColor = viewModel.tintColor
        imageView.image = image

        widthConstraint?.constant = viewModel.size
        heightConstraint?.constant = viewModel.size
        return self
    }
}
