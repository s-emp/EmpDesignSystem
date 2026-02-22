import UIKit

public final class EmpText: UIView {
    // MARK: - UI Elements

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(label)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: guide.topAnchor),
            label.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        label.numberOfLines = viewModel.numberOfLines
        label.textAlignment = viewModel.alignment

        switch viewModel.content {
        case let .plain(plainText):
            label.attributedText = nil
            label.text = plainText.text
            label.font = plainText.font
            label.textColor = plainText.color

        case let .attributed(attributedString):
            label.attributedText = attributedString
        }
    }
}
