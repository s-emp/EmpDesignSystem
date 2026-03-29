import AppKit

public extension ESpacer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let length: CGFloat?
        public let orientation: NSUserInterfaceLayoutOrientation

        public init(
            common: CommonViewModel = CommonViewModel(),
            length: CGFloat? = nil,
            orientation: NSUserInterfaceLayoutOrientation = .horizontal
        ) {
            self.common = common
            self.length = length
            self.orientation = orientation
        }
    }
}
