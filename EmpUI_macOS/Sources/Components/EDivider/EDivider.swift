import AppKit

public final class EDivider: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - UI Elements

    private let lineView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(lineView)

        let guide = empLayoutMarginsGuide

        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: guide.topAnchor),
            lineView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        lineView.layer?.backgroundColor = viewModel.color.cgColor
        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let margins = empLayoutMargins
        switch viewModel.axis {
        case .horizontal:
            let height = viewModel.thickness + margins.top + margins.bottom
            return NSSize(width: NSView.noIntrinsicMetric, height: height)
        case .vertical:
            let width = viewModel.thickness + margins.left + margins.right
            return NSSize(width: width, height: NSView.noIntrinsicMetric)
        }
    }
}
