import UIKit

public final class ERichLabel: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel(attributedText: NSAttributedString())

    // MARK: - UI Elements

    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isSelectable = true
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
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

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: guide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        textView.attributedText = viewModel.attributedText
        textView.textContainer.maximumNumberOfLines = viewModel.numberOfLines
        textView.textContainer.lineBreakMode = viewModel.numberOfLines == 0 ? .byWordWrapping : .byTruncatingTail

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Layout

    override public var intrinsicContentSize: CGSize {
        let textSize = textView.intrinsicContentSize
        let margins = layoutMargins
        let noMetric = UIView.noIntrinsicMetric
        return CGSize(
            width: textSize.width == noMetric ? noMetric : textSize.width + margins.left + margins.right,
            height: textSize.height == noMetric ? noMetric : textSize.height + margins.top + margins.bottom
        )
    }
}
