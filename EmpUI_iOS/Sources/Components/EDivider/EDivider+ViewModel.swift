import UIKit

public extension EDivider {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let axis: Axis
        public let thickness: CGFloat
        public let color: UIColor

        public enum Axis: Equatable, Sendable {
            case horizontal
            case vertical
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            axis: Axis = .horizontal,
            thickness: CGFloat = 1,
            color: UIColor = UIColor.Semantic.borderDefault
        ) {
            self.common = common
            self.axis = axis
            self.thickness = thickness
            self.color = color
        }
    }
}
