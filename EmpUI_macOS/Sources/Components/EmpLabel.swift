import AppKit

public final class EmpLabel: NSView {

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

    private let textField = NSTextField(labelWithString: "")

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
        textField.isEditable = false
        textField.isBordered = false
        textField.drawsBackground = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        let top = textField.topAnchor.constraint(equalTo: topAnchor)
        let leading = textField.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = textField.bottomAnchor.constraint(equalTo: bottomAnchor)

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

        textField.stringValue = viewModel.text

        switch viewModel.style {
        case .title:
            textField.font = .systemFont(ofSize: 24, weight: .bold)
            textField.textColor = .labelColor
        case .body:
            textField.font = .systemFont(ofSize: 16, weight: .regular)
            textField.textColor = .labelColor
        case .caption:
            textField.font = .systemFont(ofSize: 12, weight: .regular)
            textField.textColor = .secondaryLabelColor
        }
    }

    private func applyMargins(_ margins: NSEdgeInsets) {
        topConstraint?.constant = margins.top
        leadingConstraint?.constant = margins.left
        trailingConstraint?.constant = -margins.right
        bottomConstraint?.constant = -margins.bottom
    }
}
