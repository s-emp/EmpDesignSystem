import UIKit

public extension EScroll {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let axis: NSLayoutConstraint.Axis
        public let showsIndicators: Bool

        public init(
            common: CommonViewModel = CommonViewModel(),
            axis: NSLayoutConstraint.Axis = .vertical,
            showsIndicators: Bool = true
        ) {
            self.common = common
            self.axis = axis
            self.showsIndicators = showsIndicators
        }
    }
}
