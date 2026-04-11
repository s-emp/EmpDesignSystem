import AppKit

public extension ESlider {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let value: Double
        public let minimumValue: Double
        public let maximumValue: Double
        public let step: Double?
        public let isEnabled: Bool
        public let trackColor: NSColor
        public let knobColor: NSColor

        public init(
            common: CommonViewModel = CommonViewModel(),
            value: Double = 0,
            minimumValue: Double = 0,
            maximumValue: Double = 1,
            step: Double? = nil,
            isEnabled: Bool = true,
            trackColor: NSColor = NSColor.Semantic.actionPrimary,
            knobColor: NSColor = .white
        ) {
            self.common = common
            self.value = min(max(value, minimumValue), maximumValue)
            self.minimumValue = minimumValue
            self.maximumValue = maximumValue
            self.step = step
            self.isEnabled = isEnabled
            self.trackColor = trackColor
            self.knobColor = knobColor
        }
    }
}
