import UIKit

public extension EToggle {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let isOn: Bool
        public let isEnabled: Bool
        public let onTintColor: UIColor

        public init(
            common: CommonViewModel = CommonViewModel(),
            isOn: Bool = false,
            isEnabled: Bool = true,
            onTintColor: UIColor = UIColor.Semantic.actionPrimary
        ) {
            self.common = common
            self.isOn = isOn
            self.isEnabled = isEnabled
            self.onTintColor = onTintColor
        }
    }
}
