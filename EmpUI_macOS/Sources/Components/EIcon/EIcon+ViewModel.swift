import AppKit

public extension EIcon {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let source: Source
        public let size: CGFloat
        public let tintColor: NSColor

        public enum Source: Equatable {
            case sfSymbol(String)
            case named(String)
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            source: Source,
            size: CGFloat,
            tintColor: NSColor = .labelColor
        ) {
            self.common = common
            self.source = source
            self.size = size
            self.tintColor = tintColor
        }
    }
}
