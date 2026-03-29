import AppKit

public extension EScroll {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let orientation: NSUserInterfaceLayoutOrientation
        public let showsIndicators: Bool

        public init(
            common: CommonViewModel = CommonViewModel(),
            orientation: NSUserInterfaceLayoutOrientation = .vertical,
            showsIndicators: Bool = true
        ) {
            self.common = common
            self.orientation = orientation
            self.showsIndicators = showsIndicators
        }
    }
}
