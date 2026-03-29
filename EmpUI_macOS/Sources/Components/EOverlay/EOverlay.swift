import AppKit

public final class EOverlay: NSView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)
        return self
    }
}
