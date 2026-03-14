import AppKit

public final class EmpSegmentControl: NSView {
    // MARK: - Action

    public var onSelectionChanged: ((Int) -> Void)?

    // MARK: - State

    public private(set) var selectedIndex: Int = 0

    // MARK: - UI Elements

    private let segmentedControl: NSSegmentedControl = {
        let control = NSSegmentedControl()
        control.segmentStyle = .roundRect
        control.trackingMode = .selectOne
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
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
        addSubview(segmentedControl)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: guide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

        segmentedControl.target = self
        segmentedControl.action = #selector(segmentChanged(_:))
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        segmentedControl.segmentCount = viewModel.segments.count
        for (index, title) in viewModel.segments.enumerated() {
            segmentedControl.setLabel(title, forSegment: index)
        }

        segmentedControl.font = viewModel.font
        segmentedControl.selectedSegmentBezelColor = viewModel.selectedSegmentTintColor

        selectedIndex = 0
        segmentedControl.selectedSegment = 0
        invalidateIntrinsicContentSize()
    }

    // MARK: - Selection

    public func select(index: Int) {
        guard index >= 0, index < segmentedControl.segmentCount, index != selectedIndex else { return }
        selectedIndex = index
        segmentedControl.selectedSegment = index
    }

    // MARK: - Action Handler

    @objc
    private func segmentChanged(_ sender: NSSegmentedControl) {
        let index = sender.selectedSegment
        guard index != selectedIndex else { return }
        selectedIndex = index
        onSelectionChanged?(index)
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let margins = empLayoutMargins
        let controlSize = segmentedControl.intrinsicContentSize

        var width = controlSize.width
        var height = controlSize.height

        if width != NSView.noIntrinsicMetric {
            width += margins.left + margins.right
        }
        if height != NSView.noIntrinsicMetric {
            height += margins.top + margins.bottom
        }

        return NSSize(width: width, height: height)
    }
}
