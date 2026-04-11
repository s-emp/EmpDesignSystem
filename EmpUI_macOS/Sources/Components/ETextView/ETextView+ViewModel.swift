import AppKit

public extension ETextView {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let text: String
        public let placeholder: String
        public let isEditable: Bool
        public let isScrollEnabled: Bool
        public let font: NSFont
        public let textColor: NSColor

        public init(
            common: CommonViewModel = CommonViewModel(),
            text: String = "",
            placeholder: String = "",
            isEditable: Bool = true,
            isScrollEnabled: Bool = true,
            font: NSFont = .systemFont(ofSize: NSFont.systemFontSize),
            textColor: NSColor = NSColor.Semantic.textPrimary
        ) {
            self.common = common
            self.text = text
            self.placeholder = placeholder
            self.isEditable = isEditable
            self.isScrollEnabled = isScrollEnabled
            self.font = font
            self.textColor = textColor
        }
    }
}
