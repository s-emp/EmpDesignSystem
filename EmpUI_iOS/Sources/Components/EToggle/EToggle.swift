import UIKit

public final class EToggle: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - Callback

    public var onValueChanged: ((Bool) -> Void)?

    // MARK: - UI Elements

    private let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
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
        addSubview(toggle)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            toggle.topAnchor.constraint(equalTo: guide.topAnchor),
            toggle.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            toggle.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            toggle.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

        toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        toggle.isOn = viewModel.isOn
        toggle.isEnabled = viewModel.isEnabled
        toggle.onTintColor = viewModel.onTintColor

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Actions

    @objc private func toggleValueChanged() {
        onValueChanged?(toggle.isOn)
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: CGSize {
        let switchSize = toggle.intrinsicContentSize
        let margins = layoutMargins
        return CGSize(
            width: switchSize.width + margins.left + margins.right,
            height: switchSize.height + margins.top + margins.bottom
        )
    }
}
