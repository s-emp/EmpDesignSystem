import AppKit

public final class EmpButton: NSView {

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

    private let button = NSButton()

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        button.bezelStyle = .rounded
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
