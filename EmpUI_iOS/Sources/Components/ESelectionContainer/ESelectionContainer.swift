import UIKit

public final class ESelectionContainer: UIControl, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel()
    public private(set) var contentView: UIView?

    public var onSelectionChanged: ((Bool) -> Void)?

    var onStateChange: ((ControlState) -> Void)?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)
        return self
    }

    public func setContent(_ view: UIView) {
        contentView?.removeFromSuperview()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        contentView = view
    }

    @objc private func handleTap() {
        let newValue = !viewModel.isSelected
        viewModel = ViewModel(
            common: viewModel.common,
            isSelected: newValue
        )
        onSelectionChanged?(newValue)
    }

    public var currentState: ControlState {
        if !isEnabled { return .disabled }
        if isHighlighted { return .highlighted }
        return .normal
    }

    private func updateAppearance() {
        onStateChange?(currentState)
    }

    override public var isHighlighted: Bool { didSet { updateAppearance() } }
    override public var isEnabled: Bool { didSet { updateAppearance() } }
}
