import UIKit

public final class EIcon: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel(source: .sfSymbol("questionmark"), size: 0)

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    // MARK: - Constraints

    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

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
        addSubview(imageView)

        let guide = layoutMarginsGuide
        let wc = imageView.widthAnchor.constraint(equalToConstant: 0)
        let hc = imageView.heightAnchor.constraint(equalToConstant: 0)
        widthConstraint = wc
        heightConstraint = hc

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: guide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            wc,
            hc,
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        let image: UIImage?
        switch viewModel.source {
        case let .sfSymbol(name):
            let config = UIImage.SymbolConfiguration(pointSize: viewModel.size)
            image = UIImage(systemName: name, withConfiguration: config)
        case let .named(name):
            image = UIImage(named: name)
        }

        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = viewModel.tintColor

        widthConstraint?.constant = viewModel.size
        heightConstraint?.constant = viewModel.size
        return self
    }
}
