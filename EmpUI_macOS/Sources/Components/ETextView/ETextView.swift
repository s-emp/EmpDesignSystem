import AppKit

public final class ETextView: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - Callback

    public var onTextChanged: ((String) -> Void)?

    // MARK: - UI Elements

    private let scrollView: NSScrollView = {
        let sv = NSScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.hasVerticalScroller = true
        sv.hasHorizontalScroller = false
        sv.drawsBackground = false
        sv.borderType = .noBorder
        return sv
    }()

    private let textView: NSTextView = {
        let tv = NSTextView()
        tv.isRichText = false
        tv.allowsUndo = true
        tv.drawsBackground = false
        tv.textContainerInset = .zero
        tv.textContainer?.lineFragmentPadding = 0
        tv.isVerticallyResizable = true
        tv.isHorizontallyResizable = false
        tv.autoresizingMask = [.width]
        return tv
    }()

    private let placeholderField: NSTextField = {
        let field = NSTextField(labelWithString: "")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isEditable = false
        field.isBordered = false
        field.drawsBackground = false
        field.textColor = NSColor.Semantic.textTertiary
        field.cell?.wraps = true
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

        scrollView.documentView = textView
        addSubview(scrollView)
        addSubview(placeholderField)

        textView.delegate = self

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            placeholderField.topAnchor.constraint(equalTo: guide.topAnchor),
            placeholderField.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            placeholderField.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        textView.string = viewModel.text
        textView.font = viewModel.font
        textView.textColor = viewModel.textColor
        textView.isEditable = viewModel.isEditable

        scrollView.hasVerticalScroller = viewModel.isScrollEnabled

        placeholderField.stringValue = viewModel.placeholder
        placeholderField.font = viewModel.font
        placeholderField.isHidden = !viewModel.text.isEmpty

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let margins = empLayoutMargins
        let noMetric = NSView.noIntrinsicMetric
        guard let layoutManager = textView.layoutManager,
              let textContainer = textView.textContainer else {
            return NSSize(width: noMetric, height: noMetric)
        }

        layoutManager.ensureLayout(for: textContainer)
        let textSize = layoutManager.usedRect(for: textContainer).size

        return NSSize(
            width: noMetric,
            height: textSize.height == 0 ? noMetric : textSize.height + margins.top + margins.bottom
        )
    }
}

// MARK: - NSTextViewDelegate

extension ETextView: NSTextViewDelegate {
    public func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        placeholderField.isHidden = !textView.string.isEmpty
        onTextChanged?(textView.string)
        invalidateIntrinsicContentSize()
    }
}
