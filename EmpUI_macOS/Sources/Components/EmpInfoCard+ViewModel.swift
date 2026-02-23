import AppKit

public extension EmpInfoCard {
    struct ViewModel {
        public let common: CommonViewModel
        public let subtitle: String
        public let value: String
        public let subtitleColor: NSColor
        public let subtitleFont: NSFont
        public let valueColor: NSColor
        public let valueFont: NSFont
        public let background: Background
        public let spacing: CGFloat

        public init(
            common: CommonViewModel = CommonViewModel(),
            subtitle: String,
            value: String,
            subtitleColor: NSColor = NSColor.Semantic.textSecondary,
            subtitleFont: NSFont = .systemFont(ofSize: 11, weight: .medium),
            valueColor: NSColor = NSColor.Semantic.textPrimary,
            valueFont: NSFont = .systemFont(ofSize: 24, weight: .bold),
            background: Background = .color(NSColor.Semantic.backgroundSecondary),
            spacing: CGFloat = EmpSpacing.xs.rawValue
        ) {
            self.common = common
            self.subtitle = subtitle
            self.value = value
            self.subtitleColor = subtitleColor
            self.subtitleFont = subtitleFont
            self.valueColor = valueColor
            self.valueFont = valueFont
            self.background = background
            self.spacing = spacing
        }
    }
}
