import AppKit

public extension EText {
    enum Content: Equatable {
        case plain(PlainText)
        case attributed(NSAttributedString)

        // MARK: Public

        // MARK: - PlainText

        public struct PlainText: Equatable {
            public let text: String
            public let font: NSFont
            public let color: NSColor

            public init(
                text: String,
                font: NSFont = .preferredFont(forTextStyle: .body),
                color: NSColor = NSColor.Semantic.textPrimary
            ) {
                self.text = text
                self.font = font
                self.color = color
            }
        }
    }
}
