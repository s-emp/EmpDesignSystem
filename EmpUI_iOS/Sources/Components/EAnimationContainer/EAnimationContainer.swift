import UIKit

public final class EAnimationContainer: UIView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel(
        transition: .fade,
        duration: 0.3
    )
    public private(set) var contentView: UIView?

    override public init(frame: CGRect) {
        super.init(frame: frame)
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

    public func setContent(_ view: UIView) {
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
        guard let contentView else { return }
        applyHiddenState(to: contentView)
        UIView.animate(withDuration: viewModel.duration) {
            self.applyVisibleState(to: contentView)
        }
    }

    public func animateOut(completion: (@Sendable () -> Void)? = nil) {
        guard let contentView else {
            completion?()
            return
        }
        UIView.animate(withDuration: viewModel.duration, animations: {
            self.applyHiddenState(to: contentView)
        }, completion: { _ in
            completion?()
        })
    }

    private func applyHiddenState(to view: UIView) {
        switch viewModel.transition {
        case .fade:
            view.alpha = 0
        case let .scale(from):
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: from, y: from)
        case let .slide(edge):
            view.alpha = 0
            view.transform = slideTransform(for: edge)
        }
    }

    private func applyVisibleState(to view: UIView) {
        view.alpha = 1
        view.transform = .identity
    }

    private func slideTransform(for edge: ViewModel.Transition.Edge) -> CGAffineTransform {
        let distance: CGFloat = bounds.isEmpty ? 50 : max(bounds.width, bounds.height)
        switch edge {
        case .top:
            return CGAffineTransform(translationX: 0, y: -distance)
        case .bottom:
            return CGAffineTransform(translationX: 0, y: distance)
        case .leading:
            return CGAffineTransform(translationX: -distance, y: 0)
        case .trailing:
            return CGAffineTransform(translationX: distance, y: 0)
        }
    }
}
