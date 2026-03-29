import AppKit

public final class ETapContainer: NSView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel(
        action: .init(id: "", handler: { _ in })
    )
    public private(set) var contentView: NSView?
    private var isPressed = false
    private var isHovered = false
    private var trackingArea: NSTrackingArea?

    var onStateChange: ((ControlState) -> Void)?

    public var isEnabled: Bool = true {
        didSet { updateAppearance() }
    }

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
        if isHovered { return .hover }
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
            viewModel.action.handler(viewModel)
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
        isHovered = true
        updateAppearance()
    }

    override public func mouseExited(with event: NSEvent) {
        isHovered = false
        updateAppearance()
    }
}
