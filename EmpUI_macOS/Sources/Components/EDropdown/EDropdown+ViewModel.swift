import AppKit

public extension EDropdown {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let items: [String]
        public let selectedIndex: Int
        public let placeholder: String
        public let isEnabled: Bool

        public init(
            common: CommonViewModel = CommonViewModel(),
            items: [String],
            selectedIndex: Int = -1,
            placeholder: String = "",
            isEnabled: Bool = true
        ) {
            self.common = common
            self.items = items
            self.selectedIndex = selectedIndex
            self.placeholder = placeholder
            self.isEnabled = isEnabled
        }
    }
}
