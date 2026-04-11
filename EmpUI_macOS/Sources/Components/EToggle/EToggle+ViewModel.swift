import AppKit

public extension EToggle {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let isOn: Bool
        public let isEnabled: Bool
        public let onTintColor: NSColor

        public init(
            common: CommonViewModel = CommonViewModel(),
            isOn: Bool = false,
            isEnabled: Bool = true,
            onTintColor: NSColor = NSColor.Semantic.actionPrimary
        ) {
            self.common = common
            self.isOn = isOn
            self.isEnabled = isEnabled
            self.onTintColor = onTintColor
        }
    }
}
