import UIKit

public final class EScroll: UIScrollView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)
        showsVerticalScrollIndicator = viewModel.showsIndicators && viewModel.axis == .vertical
        showsHorizontalScrollIndicator = viewModel.showsIndicators && viewModel.axis == .horizontal
        return self
    }
}
