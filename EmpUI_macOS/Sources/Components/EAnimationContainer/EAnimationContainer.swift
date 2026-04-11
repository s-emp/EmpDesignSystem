import AppKit

public final class EAnimationContainer: NSView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel(
        transition: .fade,
        duration: 0.3
    )
    public private(set) var contentView: NSView?

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

    public func animateIn() {
        guard let contentView, let layer = contentView.layer else { return }
        applyHiddenState(to: contentView, layer: layer)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = viewModel.duration
            context.allowsImplicitAnimation = true
            self.applyVisibleState(to: contentView, layer: layer)
        }
    }

    public func animateOut(completion: (@Sendable () -> Void)? = nil) {
        guard let contentView, let layer = contentView.layer else {
            completion?()
            return
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = viewModel.duration
            context.allowsImplicitAnimation = true
            self.applyHiddenState(to: contentView, layer: layer)
        }, completionHandler: {
            completion?()
        })
    }

    private func applyHiddenState(to view: NSView, layer: CALayer) {
        switch viewModel.transition {
        case .fade:
            view.alphaValue = 0
        case let .scale(from):
            view.alphaValue = 0
            layer.setAffineTransform(CGAffineTransform(scaleX: from, y: from))
        case let .slide(edge):
            view.alphaValue = 0
            layer.setAffineTransform(slideTransform(for: edge))
        }
    }

    private func applyVisibleState(to view: NSView, layer: CALayer) {
        view.alphaValue = 1
        layer.setAffineTransform(.identity)
    }

    private func slideTransform(for edge: ViewModel.Transition.Edge) -> CGAffineTransform {
        let distance: CGFloat = bounds.isEmpty ? 50 : max(bounds.width, bounds.height)
        switch edge {
        case .top:
            return CGAffineTransform(translationX: 0, y: distance)
        case .bottom:
            return CGAffineTransform(translationX: 0, y: -distance)
        case .leading:
            return CGAffineTransform(translationX: -distance, y: 0)
        case .trailing:
            return CGAffineTransform(translationX: distance, y: 0)
        }
    }
}
