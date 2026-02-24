import AppKit

public extension EmpSegmentControl {
    struct ViewModel {
        public let common: CommonViewModel
        public let segments: [String]
        public let font: NSFont
        public let selectedSegmentTintColor: NSColor?

        public init(
            common: CommonViewModel = CommonViewModel(),
            segments: [String],
            font: NSFont = .systemFont(ofSize: 13, weight: .medium),
            selectedSegmentTintColor: NSColor? = nil
        ) {
            self.common = common
            self.segments = segments
            self.font = font
            self.selectedSegmentTintColor = selectedSegmentTintColor
        }
    }
}
