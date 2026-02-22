import UIKit

public final class EmpButton: UIView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let title: String
        public let style: Style

        public enum Style {
            case primary
            case secondary
        }

        public init(title: String, style: Style) {
            self.title = title
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let button = UIButton(type: .system)

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        button.setTitle(viewModel.title, for: .normal)

        switch viewModel.style {
        case .primary:
            button.configuration = {
                var config = UIButton.Configuration.filled()
                config.title = viewModel.title
                config.baseBackgroundColor = .systemBlue
                config.baseForegroundColor = .white
                config.cornerStyle = .medium
                return config
            }()
        case .secondary:
            button.configuration = {
                var config = UIButton.Configuration.bordered()
                config.title = viewModel.title
                config.baseBackgroundColor = .clear
                config.baseForegroundColor = .systemBlue
                config.cornerStyle = .medium
                return config
            }()
        }
    }
}
