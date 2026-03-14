import UIKit

public extension EmpText {
    enum Content {
        case plain(PlainText)
        case attributed(NSAttributedString)

        // MARK: Public

        // MARK: - PlainText

        public struct PlainText {
            public let text: String
            public let font: UIFont
            public let color: UIColor

            public init(
                text: String,
                font: UIFont = .systemFont(ofSize: 14),
                color: UIColor = UIColor.Semantic.textPrimary
            ) {
                self.text = text
                self.font = font
                self.color = color
            }
        }
    }
}
