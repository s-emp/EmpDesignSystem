import UIKit

public final class ETextView: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - Callback

    public var onTextChanged: ((String) -> Void)?

    // MARK: - UI Elements

    private let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.Semantic.textTertiary
        return label
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
        addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.delegate = self

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: guide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        textView.text = viewModel.text
        textView.font = viewModel.font
        textView.textColor = viewModel.textColor
        textView.isEditable = viewModel.isEditable
        textView.isScrollEnabled = viewModel.isScrollEnabled

        placeholderLabel.text = viewModel.placeholder
        placeholderLabel.font = viewModel.font
        placeholderLabel.isHidden = !viewModel.text.isEmpty

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: CGSize {
        let textSize = textView.sizeThatFits(CGSize(
            width: textView.bounds.width > 0 ? textView.bounds.width : CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        ))
        let margins = layoutMargins
        let noMetric = UIView.noIntrinsicMetric
        return CGSize(
            width: noMetric,
            height: textSize.height == 0 ? noMetric : textSize.height + margins.top + margins.bottom
        )
    }
}

// MARK: - UITextViewDelegate

extension ETextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        onTextChanged?(textView.text)
        invalidateIntrinsicContentSize()
    }
}
