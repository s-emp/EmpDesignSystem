import AppKit

public extension EProgressBar {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let progress: CGFloat
        public let trackColor: NSColor
        public let fillColor: NSColor
        public let barHeight: CGFloat

        public init(
            common: CommonViewModel = CommonViewModel(),
            progress: CGFloat = 0,
            trackColor: NSColor = NSColor.Semantic.backgroundTertiary,
            fillColor: NSColor = NSColor.Semantic.actionPrimary,
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
