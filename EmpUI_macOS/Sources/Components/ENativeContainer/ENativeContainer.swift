import AppKit

public final class ENativeContainer: NSView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel(identifier: "")
    public private(set) var contentView: NSView?

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)
        return self
    }

    public func setContent(_ view: NSView) {
        contentView?.removeFromSuperview()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: empLayoutMarginsGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: empLayoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: empLayoutMarginsGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: empLayoutMarginsGuide.bottomAnchor),
        ])
        contentView = view
    }
}
