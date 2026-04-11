import UIKit

public final class EActivityIndicator: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - UI Elements

    private let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
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
        addSubview(indicator)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        indicator.style = viewModel.style.uiStyle
        indicator.color = viewModel.color

        if viewModel.isAnimating {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: CGSize {
        let indicatorSize = indicator.intrinsicContentSize
        let margins = layoutMargins
        return CGSize(
            width: indicatorSize.width + margins.left + margins.right,
            height: indicatorSize.height + margins.top + margins.bottom
        )
    }
}
