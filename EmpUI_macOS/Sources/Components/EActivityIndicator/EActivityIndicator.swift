import AppKit

public final class EActivityIndicator: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - UI Elements

    private let indicator: NSProgressIndicator = {
        let indicator = NSProgressIndicator()
        indicator.style = .spinning
        indicator.isDisplayedWhenStopped = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Constraints

    private var indicatorWidthConstraint: NSLayoutConstraint?
    private var indicatorHeightConstraint: NSLayoutConstraint?

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
        addSubview(indicator)

        let guide = empLayoutMarginsGuide
        let size = ViewModel.Style.medium.size
        let widthConstraint = indicator.widthAnchor.constraint(equalToConstant: size)
        let heightConstraint = indicator.heightAnchor.constraint(equalToConstant: size)
        indicatorWidthConstraint = widthConstraint
        indicatorHeightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            widthConstraint,
            heightConstraint,
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        let size = viewModel.style.size
        indicatorWidthConstraint?.constant = size
        indicatorHeightConstraint?.constant = size
        indicator.controlSize = viewModel.style.controlSize

        indicator.appearance = NSAppearance(named: .aqua)
        if let filter = CIFilter(name: "CIFalseColor",
                                 parameters: [
                                     "inputColor0": CIColor(color: viewModel.color) ?? CIColor.black,
                                     "inputColor1": CIColor(color: viewModel.color) ?? CIColor.black,
                                 ]) {
            indicator.contentFilters = [filter]
        }

        if viewModel.isAnimating {
            indicator.startAnimation(nil)
        } else {
            indicator.stopAnimation(nil)
        }

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let size = viewModel.style.size
        let margins = empLayoutMargins
        return NSSize(
            width: size + margins.left + margins.right,
            height: size + margins.top + margins.bottom
        )
    }
}
