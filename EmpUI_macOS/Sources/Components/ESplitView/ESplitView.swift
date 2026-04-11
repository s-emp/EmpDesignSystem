import AppKit

public final class ESplitView: NSView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    private let splitView = NSSplitView()
    private var panelConstraints: [(min: CGFloat?, max: CGFloat?)] = []
    private var splitViewDelegate: SplitViewDelegate?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupSplitView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSplitView() {
        splitView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(splitView)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            splitView.topAnchor.constraint(equalTo: guide.topAnchor),
            splitView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            splitView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            splitView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        switch viewModel.orientation {
        case .horizontal:
            splitView.isVertical = true
        case .vertical:
            splitView.isVertical = false
        }

        switch viewModel.dividerStyle {
        case .thin:
            splitView.dividerStyle = .thin
        case .thick:
            splitView.dividerStyle = .thick
        }

        return self
    }

    @discardableResult
    public func addPanel(_ view: NSView, minSize: CGFloat? = nil, maxSize: CGFloat? = nil) -> Self {
        splitView.addArrangedSubview(view)
        panelConstraints.append((min: minSize, max: maxSize))
        updateDelegate()
        return self
    }

    private func updateDelegate() {
        let delegate = SplitViewDelegate(panelConstraints: panelConstraints)
        splitViewDelegate = delegate
        splitView.delegate = delegate
    }
}

// MARK: - SplitViewDelegate

private final class SplitViewDelegate: NSObject, NSSplitViewDelegate {
    let panelConstraints: [(min: CGFloat?, max: CGFloat?)]

    init(panelConstraints: [(min: CGFloat?, max: CGFloat?)]) {
        self.panelConstraints = panelConstraints
    }

    func splitView(
        _ splitView: NSSplitView,
        constrainMinCoordinate proposedMinimumPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        guard dividerIndex < panelConstraints.count else { return proposedMinimumPosition }
        if let minSize = panelConstraints[dividerIndex].min {
            return proposedMinimumPosition + minSize - proposedMinimumPosition > 0
                ? minSize
                : proposedMinimumPosition
        }
        return proposedMinimumPosition
    }

    func splitView(
        _ splitView: NSSplitView,
        constrainMaxCoordinate proposedMaximumPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        guard dividerIndex < panelConstraints.count else { return proposedMaximumPosition }
        if let maxSize = panelConstraints[dividerIndex].max {
            let totalSize = splitView.isVertical ? splitView.bounds.width : splitView.bounds.height
            return min(proposedMaximumPosition, totalSize - maxSize)
        }
        return proposedMaximumPosition
    }

    func splitView(
        _ splitView: NSSplitView,
        constrainSplitPosition proposedPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        var position = proposedPosition

        // Enforce min size for the panel before the divider
        if dividerIndex < panelConstraints.count,
           let minSize = panelConstraints[dividerIndex].min {
            position = max(position, minSize)
        }

        // Enforce max size for the panel before the divider
        if dividerIndex < panelConstraints.count,
           let maxSize = panelConstraints[dividerIndex].max {
            position = min(position, maxSize)
        }

        // Enforce min size for the panel after the divider
        let nextIndex = dividerIndex + 1
        if nextIndex < panelConstraints.count,
           let minSize = panelConstraints[nextIndex].min {
            let totalSize = splitView.isVertical ? splitView.bounds.width : splitView.bounds.height
            let dividerThickness = splitView.dividerThickness
            let maxAllowed = totalSize - dividerThickness - minSize
            position = min(position, maxAllowed)
        }

        return position
    }
}
