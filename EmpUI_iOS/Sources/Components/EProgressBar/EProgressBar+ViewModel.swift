import UIKit

public extension EProgressBar {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let progress: CGFloat
        public let trackColor: UIColor
        public let fillColor: UIColor
        public let barHeight: CGFloat

        public init(
            common: CommonViewModel = CommonViewModel(),
            progress: CGFloat = 0,
            trackColor: UIColor = UIColor.Semantic.backgroundTertiary,
            fillColor: UIColor = UIColor.Semantic.actionPrimary,
            barHeight: CGFloat = 4
        ) {
            self.common = common
            self.progress = min(max(progress, 0), 1)
            self.trackColor = trackColor
            self.fillColor = fillColor
            self.barHeight = barHeight
        }
    }
}
