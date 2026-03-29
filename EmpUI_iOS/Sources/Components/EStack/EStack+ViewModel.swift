import UIKit

public extension EStack {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let axis: NSLayoutConstraint.Axis
        public let spacing: CGFloat
        public let alignment: UIStackView.Alignment
        public let distribution: UIStackView.Distribution

        public init(
            common: CommonViewModel = CommonViewModel(),
            axis: NSLayoutConstraint.Axis = .horizontal,
            spacing: CGFloat = 0,
            alignment: UIStackView.Alignment = .fill,
            distribution: UIStackView.Distribution = .fill
        ) {
            self.common = common
            self.axis = axis
            self.spacing = spacing
            self.alignment = alignment
            self.distribution = distribution
        }
    }
}
