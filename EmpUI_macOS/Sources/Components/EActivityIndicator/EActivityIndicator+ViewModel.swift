import AppKit

public extension EActivityIndicator {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let style: Style
        public let color: NSColor
        public let isAnimating: Bool

        public init(
            common: CommonViewModel = CommonViewModel(),
            style: Style = .medium,
            color: NSColor = NSColor.Semantic.textPrimary,
            isAnimating: Bool = true
        ) {
            self.common = common
            self.style = style
            self.color = color
            self.isAnimating = isAnimating
        }
    }
}
