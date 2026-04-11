import UIKit

public extension ETextView {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let text: String
        public let placeholder: String
        public let isEditable: Bool
        public let isScrollEnabled: Bool
        public let font: UIFont
        public let textColor: UIColor

        public init(
            common: CommonViewModel = CommonViewModel(),
            text: String = "",
            placeholder: String = "",
            isEditable: Bool = true,
            isScrollEnabled: Bool = true,
            font: UIFont = .preferredFont(forTextStyle: .body),
            textColor: UIColor = UIColor.Semantic.textPrimary
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
