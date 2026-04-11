import UIKit

public extension ESlider {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let value: Double
        public let minimumValue: Double
        public let maximumValue: Double
        public let step: Double?
        public let isEnabled: Bool
        public let minimumTrackColor: UIColor
        public let maximumTrackColor: UIColor
        public let thumbColor: UIColor

        public init(
            common: CommonViewModel = CommonViewModel(),
            value: Double = 0,
            minimumValue: Double = 0,
            maximumValue: Double = 1,
            step: Double? = nil,
            isEnabled: Bool = true,
            minimumTrackColor: UIColor = UIColor.Semantic.actionPrimary,
            maximumTrackColor: UIColor = UIColor.Semantic.backgroundTertiary,
            thumbColor: UIColor = .white
        ) {
            self.common = common
            self.value = min(max(value, minimumValue), maximumValue)
            self.minimumValue = minimumValue
            self.maximumValue = maximumValue
            self.step = step
            self.isEnabled = isEnabled
            self.minimumTrackColor = minimumTrackColor
            self.maximumTrackColor = maximumTrackColor
            self.thumbColor = thumbColor
        }
    }
}
