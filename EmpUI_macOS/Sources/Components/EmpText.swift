import AppKit

public final class EmpText: NSView {
    // MARK: - UI Elements

    private let textField: NSTextField = {
        let field = NSTextField(labelWithString: "")
        field.isEditable = false
        field.isBordered = false
        field.drawsBackground = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

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
        wantsLayer = true
        addSubview(textField)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: guide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        textField.maximumNumberOfLines = viewModel.numberOfLines
        textField.alignment = viewModel.alignment

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        if viewModel.numberOfLines == 1 {
            textField.cell?.wraps = false
            textField.cell?.isScrollable = false
            textField.cell?.lineBreakMode = .byTruncatingTail
            textField.cell?.truncatesLastVisibleLine = true
        } else {
            textField.cell?.wraps = true
            textField.cell?.isScrollable = false
            textField.cell?.lineBreakMode = .byWordWrapping
        }

        switch viewModel.content {
        case let .plain(plainText):
            textField.stringValue = plainText.text
            textField.font = plainText.font
            textField.textColor = plainText.color

        case let .attributed(attributedString):
            textField.attributedStringValue = attributedString
        }
    }

    // MARK: - Layout

    override public func layout() {
        super.layout()
        if textField.maximumNumberOfLines != 1 {
            textField.preferredMaxLayoutWidth = textField.frame.width
        }
    }
}
