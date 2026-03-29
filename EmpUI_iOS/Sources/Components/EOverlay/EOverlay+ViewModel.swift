import UIKit

public extension EOverlay {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel

        public init(common: CommonViewModel = CommonViewModel()) {
            self.common = common
        }
    }
}
