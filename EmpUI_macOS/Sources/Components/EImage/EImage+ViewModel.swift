import AppKit

public extension EImage {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let image: NSImage
        public let tintColor: NSColor?
        public let size: CGSize
        public let contentMode: ContentMode

        public enum ContentMode {
            case aspectFit
            case aspectFill
            case center
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            image: NSImage,
            tintColor: NSColor? = nil,
            size: CGSize,
            contentMode: ContentMode = .aspectFit
        ) {
            self.common = common
            self.image = image
            self.tintColor = tintColor
            self.size = size
            self.contentMode = contentMode
        }
    }
}
