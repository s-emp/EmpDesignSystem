import AppKit

public extension ESelectionContainer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let isSelected: Bool

        public init(
            common: CommonViewModel = CommonViewModel(),
            isSelected: Bool = false
        ) {
            self.common = common
            self.isSelected = isSelected
        }
    }
}
