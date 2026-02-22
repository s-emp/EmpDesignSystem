import AppKit

public final class EmpButton: NSView {
    // MARK: - ViewModel

    public struct ViewModel {
        public let common: CommonViewModel
        public let title: String
        public let style: Style

        public enum Style {
            case primary
            case secondary
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            title: String,
            style: Style
        ) {
            self.common = common
            self.title = title
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let button = NSButton()

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        button.bezelStyle = .rounded
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: empLayoutMarginsGuide.topAnchor),
            button.leadingAnchor.constraint(equalTo: empLayoutMarginsGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: empLayoutMarginsGuide.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: empLayoutMarginsGuide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        button.title = viewModel.title

        switch viewModel.style {
        case .primary:
            button.bezelColor = .controlAccentColor
            button.contentTintColor = .white
        case .secondary:
            button.bezelColor = nil
            button.contentTintColor = .controlAccentColor
        }
    }
}
