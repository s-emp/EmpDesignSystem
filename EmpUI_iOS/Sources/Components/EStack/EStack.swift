import UIKit

public final class EStack: UIStackView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        axis = viewModel.axis
        spacing = viewModel.spacing
        alignment = viewModel.alignment
        distribution = viewModel.distribution
        apply(common: viewModel.common)
        return self
    }
}
