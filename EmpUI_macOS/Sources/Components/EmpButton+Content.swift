import AppKit

public extension EmpButton {
    struct Content {
        public let leading: Element?
        public let center: Element?
        public let trailing: Element?

        public init(
            leading: Element? = nil,
            center: Element? = nil,
            trailing: Element? = nil
        ) {
            self.leading = leading
            self.center = center
            self.trailing = trailing
        }

        // swiftlint:disable enum_case_associated_values_count
        public enum Element {
            case icon(NSImage, color: NSColor, size: CGFloat)
            case text(String, color: NSColor, font: NSFont)
            case titleSubtitle(
                title: String,
                subtitle: String,
                titleColor: NSColor,
                subtitleColor: NSColor,
                titleFont: NSFont,
                subtitleFont: NSFont
            )
        }
        // swiftlint:enable enum_case_associated_values_count
    }
}
