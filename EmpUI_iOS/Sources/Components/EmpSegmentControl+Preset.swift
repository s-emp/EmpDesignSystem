import UIKit

public extension EmpSegmentControl {
    enum Preset {
        public static func `default`(segments: [String]) -> ViewModel {
            ViewModel(
                common: CommonViewModel(
                    layoutMargins: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
                ),
                segments: segments
            )
        }
    }
}
