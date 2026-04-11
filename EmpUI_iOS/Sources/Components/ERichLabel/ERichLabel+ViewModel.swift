import UIKit

public extension ERichLabel {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let attributedText: NSAttributedString
        public let numberOfLines: Int

        public init(
            common: CommonViewModel = CommonViewModel(),
            attributedText: NSAttributedString,
            numberOfLines: Int = 0
        ) {
            self.common = common
            self.attributedText = attributedText
            self.numberOfLines = numberOfLines
        }
    }
}
