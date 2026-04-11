import AppKit

public final class ERichLabel: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel(attributedText: NSAttributedString())

    // MARK: - UI Elements

    private let textField: NSTextField = {
        let field = NSTextField(labelWithAttributedString: NSAttributedString())
        field.isEditable = false
        field.isBordered = false
        field.drawsBackground = false
        field.isSelectable = true
        field.allowsEditingTextAttributes = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    // MARK: - State

    private var configuredNumberOfLines: Int = 0

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

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        textField.attributedStringValue = viewModel.attributedText

        configuredNumberOfLines = viewModel.numberOfLines
        textField.maximumNumberOfLines = viewModel.numberOfLines

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        if viewModel.numberOfLines == 1 {
            textField.cell?.wraps = false
            textField.cell?.isScrollable = false
        } else {
            textField.cell?.wraps = true
            textField.cell?.isScrollable = false
            textField.cell?.lineBreakMode = .byWordWrapping
        }

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let textSize = textField.intrinsicContentSize
        let margins = empLayoutMargins
        let noMetric = NSView.noIntrinsicMetric
        return NSSize(
            width: textSize.width == noMetric ? noMetric : textSize.width + margins.left + margins.right,
            height: textSize.height == noMetric ? noMetric : textSize.height + margins.top + margins.bottom
        )
    }

    // MARK: - Layout

    override public func layout() {
        super.layout()
        if configuredNumberOfLines == 1 {
            let textWidth = textField.attributedStringValue.size().width
            if textField.frame.width < textWidth {
                textField.cell?.lineBreakMode = .byTruncatingTail
                textField.cell?.truncatesLastVisibleLine = true
            }
        } else {
            textField.preferredMaxLayoutWidth = textField.frame.width
        }
    }
}
