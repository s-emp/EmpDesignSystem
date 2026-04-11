import AppKit

public extension EDivider {
    struct ViewModel: ComponentViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let axis: Axis
        public let thickness: CGFloat
        public let color: NSColor

        public enum Axis: Equatable, Sendable {
            case horizontal
            case vertical
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            axis: Axis = .horizontal,
            thickness: CGFloat = 1,
            color: NSColor = NSColor.Semantic.borderDefault
        ) {
            self.common = common
            self.axis = axis
            self.thickness = thickness
            self.color = color
        }
    }
}
