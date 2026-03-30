import UIKit

public extension EText {
    enum Content: Equatable {
        case plain(PlainText)
        case attributed(NSAttributedString)

        // MARK: Public

        // MARK: - PlainText

        public struct PlainText: Equatable {
            public let text: String
            public let font: UIFont
            public let color: UIColor

            public init(
                text: String,
                font: UIFont = .preferredFont(forTextStyle: .body),
                color: UIColor = UIColor.Semantic.textPrimary
            ) {
                self.text = text
                self.font = font
                self.color = color
            }
        }
    }
}
