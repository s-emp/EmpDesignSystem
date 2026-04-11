import AppKit

public final class ETextField: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - Callbacks

    public var onTextChanged: ((String) -> Void)?
    public var onReturn: (() -> Void)?

    // MARK: - UI Elements

    private let textField: NSTextField = {
        let field = NSTextField()
        field.isEditable = true
        field.isBordered = true
        field.drawsBackground = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let secureField: NSSecureTextField = {
        let field = NSSecureTextField()
        field.isEditable = true
        field.isBordered = true
        field.drawsBackground = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    // MARK: - State

    private var isShowingSecure = false

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
        addSubview(secureField)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: guide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            secureField.topAnchor.constraint(equalTo: guide.topAnchor),
            secureField.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            secureField.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            secureField.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

        textField.delegate = self
        secureField.delegate = self

        secureField.isHidden = true
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        let showSecure = viewModel.isSecure
        textField.isHidden = showSecure
        secureField.isHidden = !showSecure
        isShowingSecure = showSecure

        let activeField: NSTextField = showSecure ? secureField : textField

        activeField.stringValue = viewModel.text
        activeField.placeholderString = viewModel.placeholder
        activeField.isEnabled = viewModel.isEnabled
        activeField.isEditable = viewModel.isEnabled

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let activeField: NSTextField = isShowingSecure ? secureField : textField
        let fieldSize = activeField.intrinsicContentSize
        let margins = empLayoutMargins
        let noMetric = NSView.noIntrinsicMetric
        return NSSize(
            width: fieldSize.width == noMetric ? noMetric : fieldSize.width + margins.left + margins.right,
            height: fieldSize.height == noMetric ? noMetric : fieldSize.height + margins.top + margins.bottom
        )
    }
}

// MARK: - NSTextFieldDelegate

extension ETextField: NSTextFieldDelegate {
    public func controlTextDidChange(_ obj: Notification) {
        guard let field = obj.object as? NSTextField else { return }
        onTextChanged?(field.stringValue)
    }

    public func control(_ control: NSControl, textView _: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            onReturn?()
            return true
        }
        return false
    }
}
