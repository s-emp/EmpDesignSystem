import AppKit

public extension EText {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let content: Content
        public let numberOfLines: Int
        public let alignment: NSTextAlignment

        public init(
            common: CommonViewModel = CommonViewModel(),
            content: Content,
            numberOfLines: Int = 0,
            alignment: NSTextAlignment = .natural
        ) {
            self.common = common
            self.content = content
            self.numberOfLines = numberOfLines
            self.alignment = alignment
        }
    }
}
