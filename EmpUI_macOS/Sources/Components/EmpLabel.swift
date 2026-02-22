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
        textField.isEditable = false
        textField.isBordered = false
        textField.drawsBackground = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: empLayoutMarginsGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: empLayoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: empLayoutMarginsGuide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: empLayoutMarginsGuide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

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
}
