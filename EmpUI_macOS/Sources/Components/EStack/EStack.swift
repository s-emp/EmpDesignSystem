import AppKit

public final class EStack: NSStackView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        orientation = viewModel.orientation
        spacing = viewModel.spacing
        alignment = viewModel.alignment
        distribution = viewModel.distribution
        apply(common: viewModel.common)
        return self
    }
}
