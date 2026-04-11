import UIKit

public final class EDivider: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - UI Elements

    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(lineView)

        let guide = layoutMarginsGuide

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

        lineView.backgroundColor = viewModel.color
        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: CGSize {
        let margins = layoutMargins
        switch viewModel.axis {
        case .horizontal:
            let height = viewModel.thickness + margins.top + margins.bottom
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        case .vertical:
            let width = viewModel.thickness + margins.left + margins.right
            return CGSize(width: width, height: UIView.noIntrinsicMetric)
        }
    }
}
