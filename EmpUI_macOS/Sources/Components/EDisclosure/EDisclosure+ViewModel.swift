import AppKit

public extension EDisclosure {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let title: String
        public let isExpanded: Bool

        public init(
            common: CommonViewModel = CommonViewModel(),
            title: String,
            isExpanded: Bool = false
        ) {
            self.common = common
            self.title = title
            self.isExpanded = isExpanded
        }
    }
}
