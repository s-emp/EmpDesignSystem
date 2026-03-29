import UIKit

public protocol EComponent: UIView {
    associatedtype ViewModel: ComponentViewModel
    var viewModel: ViewModel { get }

    @discardableResult
    func configure(with viewModel: ViewModel) -> Self
}
