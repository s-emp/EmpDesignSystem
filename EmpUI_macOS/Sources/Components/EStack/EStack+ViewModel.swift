import AppKit

public extension EStack {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let orientation: NSUserInterfaceLayoutOrientation
        public let spacing: CGFloat
        public let alignment: NSLayoutConstraint.Attribute
        public let distribution: NSStackView.Distribution

        public init(
            common: CommonViewModel = CommonViewModel(),
            orientation: NSUserInterfaceLayoutOrientation = .horizontal,
            spacing: CGFloat = 0,
            alignment: NSLayoutConstraint.Attribute = .centerY,
            distribution: NSStackView.Distribution = .fill
        ) {
            self.common = common
            self.orientation = orientation
            self.spacing = spacing
            self.alignment = alignment
            self.distribution = distribution
        }
    }
}
