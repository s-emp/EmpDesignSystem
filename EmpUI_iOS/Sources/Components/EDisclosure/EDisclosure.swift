import UIKit

public final class EDisclosure: UIView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel(title: "")
    public private(set) var contentView: UIView?
    public var onToggle: ((Bool) -> Void)?

    private let headerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private let chevronImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        imageView.contentMode = .center
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        return stack
    }()

    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        headerStack.addArrangedSubview(chevronImageView)
        headerStack.addArrangedSubview(titleLabel)

        headerButton.addSubview(headerStack)
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: headerButton.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: headerButton.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: headerButton.trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: headerButton.bottomAnchor),
        ])

        mainStack.addArrangedSubview(headerButton)
        mainStack.addArrangedSubview(contentContainer)

        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])

        headerButton.addTarget(self, action: #selector(handleToggle), for: .touchUpInside)
    }

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        titleLabel.text = viewModel.title

        let angle: CGFloat = viewModel.isExpanded ? .pi / 2 : 0
        chevronImageView.transform = CGAffineTransform(rotationAngle: angle)
        contentContainer.isHidden = !viewModel.isExpanded

        return self
    }

    public func setContent(_ view: UIView) {
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
