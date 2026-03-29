import AppKit

public protocol EComponent: NSView {
    associatedtype ViewModel: ComponentViewModel
    var viewModel: ViewModel { get }

    @discardableResult
    func configure(with viewModel: ViewModel) -> Self
}
