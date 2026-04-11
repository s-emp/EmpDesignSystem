import UIKit

public extension EListContainer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let axis: Axis
        public let spacing: CGFloat
        public let isPagingEnabled: Bool

        public enum Axis: Equatable {
            case vertical
            case horizontal
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            axis: Axis = .vertical,
            spacing: CGFloat = 0,
            isPagingEnabled: Bool = false
        ) {
            self.common = common
            self.axis = axis
            self.spacing = spacing
            self.isPagingEnabled = isPagingEnabled
        }
    }
}
