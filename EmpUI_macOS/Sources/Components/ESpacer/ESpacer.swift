import AppKit

public final class ESpacer: NSView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()
    private var lengthConstraint: NSLayoutConstraint?

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        lengthConstraint?.isActive = false
        lengthConstraint = nil

        if let length = viewModel.length {
            let constraint = viewModel.orientation == .horizontal
                ? widthAnchor.constraint(equalToConstant: length)
                : heightAnchor.constraint(equalToConstant: length)
            constraint.isActive = true
            lengthConstraint = constraint
        } else {
            let layoutOrientation: NSLayoutConstraint.Orientation = viewModel.orientation == .horizontal ? .horizontal : .vertical
            setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: layoutOrientation)
        }

        return self
    }
}
