import AppKit

public final class EDropdown: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel(items: [])

    // MARK: - Action

    public var onSelectionChanged: ((Int) -> Void)?

    // MARK: - UI Elements

    private let popUpButton: NSPopUpButton = {
        let button = NSPopUpButton(frame: .zero, pullsDown: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        addSubview(popUpButton)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            popUpButton.topAnchor.constraint(equalTo: guide.topAnchor),
            popUpButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            popUpButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            popUpButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

        popUpButton.target = self
        popUpButton.action = #selector(selectionChanged(_:))
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        popUpButton.removeAllItems()

        if !viewModel.placeholder.isEmpty, viewModel.selectedIndex < 0 {
            popUpButton.addItem(withTitle: viewModel.placeholder)
            popUpButton.item(at: 0)?.isEnabled = false
        }

        popUpButton.addItems(withTitles: viewModel.items)
        popUpButton.isEnabled = viewModel.isEnabled

        if viewModel.selectedIndex >= 0, viewModel.selectedIndex < viewModel.items.count {
            let offset = (!viewModel.placeholder.isEmpty && viewModel.selectedIndex < 0) ? 1 : 0
            popUpButton.selectItem(at: viewModel.selectedIndex + offset)
        }

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Action Handler

    @objc
    private func selectionChanged(_ sender: NSPopUpButton) {
        let index: Int
        if !viewModel.placeholder.isEmpty, viewModel.selectedIndex < 0 {
            index = sender.indexOfSelectedItem - 1
        } else {
            index = sender.indexOfSelectedItem
        }
        guard index >= 0 else { return }
        onSelectionChanged?(index)
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let margins = empLayoutMargins
        let buttonSize = popUpButton.intrinsicContentSize

        var width = buttonSize.width
        var height = buttonSize.height

        if width != NSView.noIntrinsicMetric {
            width += margins.left + margins.right
        }
        if height != NSView.noIntrinsicMetric {
            height += margins.top + margins.bottom
        }

        return NSSize(width: width, height: height)
    }
}
