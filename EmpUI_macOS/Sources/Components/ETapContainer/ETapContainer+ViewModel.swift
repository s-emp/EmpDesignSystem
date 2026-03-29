import AppKit

public extension ETapContainer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public var action: Action

        public init(
            common: CommonViewModel = CommonViewModel(),
            action: Action
        ) {
            self.common = common
            self.action = action
        }
    }
}
