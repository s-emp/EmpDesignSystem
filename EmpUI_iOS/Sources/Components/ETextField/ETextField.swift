import UIKit

public final class ETextField: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - Callbacks

    public var onTextChanged: ((String) -> Void)?
    public var onReturn: (() -> Void)?

    // MARK: - UI Elements

    private let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .none
        return field
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
        addSubview(textField)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: guide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.delegate = self
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        textField.text = viewModel.text
        textField.placeholder = viewModel.placeholder
        textField.isEnabled = viewModel.isEnabled
        textField.isSecureTextEntry = viewModel.isSecure
        textField.keyboardType = viewModel.keyboardType.uiKeyboardType

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Layout

    override public var intrinsicContentSize: CGSize {
        let fieldSize = textField.intrinsicContentSize
        let margins = layoutMargins
        let noMetric = UIView.noIntrinsicMetric
        return CGSize(
            width: fieldSize.width == noMetric ? noMetric : fieldSize.width + margins.left + margins.right,
            height: fieldSize.height == noMetric ? noMetric : fieldSize.height + margins.top + margins.bottom
        )
    }

    // MARK: - Actions

    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }
}

// MARK: - UITextFieldDelegate

extension ETextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?()
        return true
    }
}
