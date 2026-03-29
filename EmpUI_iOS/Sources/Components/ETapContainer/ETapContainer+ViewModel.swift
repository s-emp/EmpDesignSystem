import UIKit

public extension ETapContainer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public var action: Action
        public var longPress: Action?

        public init(
            common: CommonViewModel = CommonViewModel(),
            action: Action,
            longPress: Action? = nil
        ) {
            self.common = common
            self.action = action
            self.longPress = longPress
        }
    }
}
