import AppKit

public final class ESelectionContainer: NSView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel()
    public private(set) var contentView: NSView?
    private var trackingArea: NSTrackingArea?

    public var onSelectionChanged: ((Bool) -> Void)?

    var onStateChange: ((ControlState) -> Void)?

    public var isEnabled: Bool = true {
        didSet { updateAppearance() }
    }

    private var isPressed = false

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)
        return self
    }

    public func setContent(_ view: NSView) {
        contentView?.removeFromSuperview()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        contentView = view
    }

    public var currentState: ControlState {
        if !isEnabled { return .disabled }
        if isPressed { return .highlighted }
        return .normal
    }

    private func updateAppearance() {
        onStateChange?(currentState)
    }

    // Mouse handling
    override public func mouseDown(with event: NSEvent) {
        guard isEnabled else { return }
        isPressed = true
        updateAppearance()
    }

    override public func mouseUp(with event: NSEvent) {
        guard isEnabled, isPressed else { return }
        isPressed = false
        updateAppearance()

        let location = convert(event.locationInWindow, from: nil)
        if bounds.contains(location) {
            let newValue = !viewModel.isSelected
            viewModel = ViewModel(
                common: viewModel.common,
                isSelected: newValue
            )
            onSelectionChanged?(newValue)
        }
    }

    // Hover via NSTrackingArea
    override public func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let existing = trackingArea {
            removeTrackingArea(existing)
        }
        let area = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeInKeyWindow],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
        trackingArea = area
    }

    override public func mouseEntered(with event: NSEvent) {
        updateAppearance()
    }

    override public func mouseExited(with event: NSEvent) {
        updateAppearance()
    }
}
