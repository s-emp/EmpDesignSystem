import UIKit

public extension ESpacer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let length: CGFloat?
        public let axis: NSLayoutConstraint.Axis

        public init(
            common: CommonViewModel = CommonViewModel(),
            length: CGFloat? = nil,
            axis: NSLayoutConstraint.Axis = .horizontal
        ) {
            self.common = common
            self.length = length
            self.axis = axis
        }
    }
}
