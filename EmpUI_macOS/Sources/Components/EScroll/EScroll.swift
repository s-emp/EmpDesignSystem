import AppKit

public final class EScroll: NSScrollView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        drawsBackground = false
        apply(common: viewModel.common)
        hasVerticalScroller = viewModel.showsIndicators && viewModel.orientation == .vertical
        hasHorizontalScroller = viewModel.showsIndicators && viewModel.orientation == .horizontal
        return self
    }
}
