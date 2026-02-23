import UIKit

public extension EmpInfoCard {
    struct ViewModel {
        public let common: CommonViewModel
        public let subtitle: String
        public let value: String
        public let subtitleColor: UIColor
        public let subtitleFont: UIFont
        public let valueColor: UIColor
        public let valueFont: UIFont
        public let background: Background
        public let spacing: CGFloat

        public init(
            common: CommonViewModel = CommonViewModel(),
            subtitle: String,
            value: String,
            subtitleColor: UIColor = UIColor.Semantic.textSecondary,
            subtitleFont: UIFont = .systemFont(ofSize: 11, weight: .medium),
            valueColor: UIColor = UIColor.Semantic.textPrimary,
            valueFont: UIFont = .systemFont(ofSize: 24, weight: .bold),
            background: Background = .color(UIColor.Semantic.backgroundSecondary),
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
