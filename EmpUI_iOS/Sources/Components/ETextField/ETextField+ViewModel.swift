import UIKit

public extension ETextField {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let text: String
        public let placeholder: String
        public let isEnabled: Bool
        public let isSecure: Bool
        public let keyboardType: KeyboardType

        public init(
            common: CommonViewModel = CommonViewModel(),
            text: String = "",
            placeholder: String = "",
            isEnabled: Bool = true,
            isSecure: Bool = false,
            keyboardType: KeyboardType = .default
        ) {
            self.common = common
            self.text = text
            self.placeholder = placeholder
            self.isEnabled = isEnabled
            self.isSecure = isSecure
            self.keyboardType = keyboardType
        }
    }
}
