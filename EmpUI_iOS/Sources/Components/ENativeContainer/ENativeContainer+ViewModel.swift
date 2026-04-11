import UIKit

public extension ENativeContainer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let identifier: String

        public init(
            common: CommonViewModel = CommonViewModel(),
            identifier: String
        ) {
            self.common = common
            self.identifier = identifier
        }
    }
}
