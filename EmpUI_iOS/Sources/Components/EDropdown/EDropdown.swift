import UIKit

public final class EDropdown: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel(items: [])

    // MARK: - Action

    public var onSelectionChanged: ((Int) -> Void)?

    // MARK: - UI Elements

    private let button: UIButton = {
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .medium
        config.indicator = .popup
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changesSelectionAsPrimaryAction = false
        button.showsMenuAsPrimaryAction = true
        return button
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
        addSubview(button)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: guide.topAnchor),
            button.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        let title: String
        if viewModel.selectedIndex >= 0, viewModel.selectedIndex < viewModel.items.count {
            title = viewModel.items[viewModel.selectedIndex]
        } else {
            title = viewModel.placeholder
        }

        button.configuration?.title = title
        button.isEnabled = viewModel.isEnabled

        let actions = viewModel.items.enumerated().map { index, item in
            UIAction(
                title: item,
                state: index == viewModel.selectedIndex ? .on : .off
            ) { [weak self] _ in
                self?.onSelectionChanged?(index)
            }
        }

        button.menu = UIMenu(children: actions)

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: CGSize {
        let margins = layoutMargins
        let buttonSize = button.intrinsicContentSize

        return CGSize(
            width: buttonSize.width + margins.left + margins.right,
            height: buttonSize.height + margins.top + margins.bottom
        )
    }
}
