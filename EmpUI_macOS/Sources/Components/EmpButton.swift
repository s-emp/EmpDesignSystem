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

    // MARK: - Constraints

    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?

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

        let top = button.topAnchor.constraint(equalTo: topAnchor)
        let leading = button.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = button.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = button.bottomAnchor.constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([top, leading, trailing, bottom])

        topConstraint = top
        leadingConstraint = leading
        trailingConstraint = trailing
        bottomConstraint = bottom
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)
        applyMargins(viewModel.common.layoutMargins)

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

    private func applyMargins(_ margins: NSEdgeInsets) {
        topConstraint?.constant = margins.top
        leadingConstraint?.constant = margins.left
        trailingConstraint?.constant = -margins.right
        bottomConstraint?.constant = -margins.bottom
    }
}
