import UIKit

public final class EmpLabel: UIView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let common: CommonViewModel
        public let text: String
        public let style: Style

        public enum Style {
            case title
            case body
            case caption
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            text: String,
            style: Style
        ) {
            self.common = common
            self.text = text
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let label = UILabel()

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
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        label.text = viewModel.text

        switch viewModel.style {
        case .title:
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textColor = .label
        case .body:
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .label
        case .caption:
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textColor = .secondaryLabel
        }
    }
}
