import UIKit

public final class EScroll: UIScrollView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)
        showsVerticalScrollIndicator = viewModel.showsIndicators
        showsHorizontalScrollIndicator = viewModel.showsIndicators
        return self
    }
}
