import UIKit

public final class EmpImage: UIView {
    // MARK: - ViewModel

    public struct ViewModel {
        public let common: CommonViewModel
        public let image: UIImage
        public let tintColor: UIColor?
        public let size: CGSize
        public let contentMode: ContentMode

        public enum ContentMode {
            case aspectFit
            case aspectFill
            case center
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            image: UIImage,
            tintColor: UIColor? = nil,
            size: CGSize,
            contentMode: ContentMode = .aspectFit
        ) {
            self.common = common
            self.image = image
            self.tintColor = tintColor
            self.size = size
            self.contentMode = contentMode
        }
    }

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
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

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)
        layer.masksToBounds = true

        if let tintColor = viewModel.tintColor {
            imageView.image = viewModel.image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = tintColor
        } else {
            imageView.image = viewModel.image.withRenderingMode(.automatic)
            imageView.tintColor = nil
        }

        switch viewModel.contentMode {
        case .aspectFit:
            imageView.contentMode = .scaleAspectFit
        case .aspectFill:
            imageView.contentMode = .scaleAspectFill
        case .center:
            imageView.contentMode = .center
        }

        widthConstraint?.constant = viewModel.size.width
        heightConstraint?.constant = viewModel.size.height
    }
}
