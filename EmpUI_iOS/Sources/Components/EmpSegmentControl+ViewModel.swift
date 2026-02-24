import UIKit

public extension EmpSegmentControl {
    struct ViewModel {
        public let common: CommonViewModel
        public let segments: [String]
        public let font: UIFont
        public let selectedSegmentTintColor: UIColor?

        public init(
            common: CommonViewModel = CommonViewModel(),
            segments: [String],
            font: UIFont = .systemFont(ofSize: 13, weight: .medium),
            selectedSegmentTintColor: UIColor? = nil
        ) {
            self.common = common
            self.segments = segments
            self.font = font
            self.selectedSegmentTintColor = selectedSegmentTintColor
        }
    }
}
