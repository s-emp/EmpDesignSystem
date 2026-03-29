import UIKit

public final class ESpacer: UIView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()
    private var lengthConstraint: NSLayoutConstraint?

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        lengthConstraint?.isActive = false
        lengthConstraint = nil

        if let length = viewModel.length {
            let constraint = viewModel.axis == .horizontal
                ? widthAnchor.constraint(equalToConstant: length)
                : heightAnchor.constraint(equalToConstant: length)
            constraint.isActive = true
            lengthConstraint = constraint
        } else {
            setContentHuggingPriority(.defaultLow, for: viewModel.axis)
        }

        return self
    }
}
