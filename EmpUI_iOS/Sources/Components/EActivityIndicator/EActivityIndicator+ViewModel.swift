import UIKit

public extension EActivityIndicator {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let style: Style
        public let color: UIColor
        public let isAnimating: Bool

        public init(
            common: CommonViewModel = CommonViewModel(),
            style: Style = .medium,
            color: UIColor = UIColor.Semantic.textPrimary,
            isAnimating: Bool = true
        ) {
            self.common = common
            self.style = style
            self.color = color
            self.isAnimating = isAnimating
        }
    }
}
