import AppKit

public final class EToggle: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - Callback

    public var onValueChanged: ((Bool) -> Void)?

    // MARK: - UI Elements

    private let toggle: NSSwitch = {
        let toggle = NSSwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
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
        addSubview(toggle)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            toggle.topAnchor.constraint(equalTo: guide.topAnchor),
            toggle.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            toggle.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            toggle.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

        toggle.target = self
        toggle.action = #selector(toggleValueChanged)
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        toggle.state = viewModel.isOn ? .on : .off
        toggle.isEnabled = viewModel.isEnabled
        // NSSwitch does not support custom tint colors natively.
        // onTintColor is kept in ViewModel for API parity with iOS.

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Actions

    @objc private func toggleValueChanged() {
        onValueChanged?(toggle.state == .on)
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let switchSize = toggle.intrinsicContentSize
        let margins = empLayoutMargins
        return NSSize(
            width: switchSize.width + margins.left + margins.right,
            height: switchSize.height + margins.top + margins.bottom
        )
    }
}
