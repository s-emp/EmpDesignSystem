import UIKit

public extension CommonViewModel.Shadow {
    enum Elevation {
        case none
        case xs
        case sm
        case md
        case lg
    }

    static func elevation(_ level: Elevation) -> CommonViewModel.Shadow {
        switch level {
        case .none:
            return CommonViewModel.Shadow()
        case .xs:
            return CommonViewModel.Shadow(
                color: UIColor.black.withAlphaComponent(0.08),
                offset: CGSize(width: 0, height: 1),
                radius: 2,
                opacity: 1
            )
        case .sm:
            return CommonViewModel.Shadow(
                color: UIColor.black.withAlphaComponent(0.12),
                offset: CGSize(width: 0, height: 2),
                radius: 4,
                opacity: 1
            )
        case .md:
            return CommonViewModel.Shadow(
                color: UIColor.black.withAlphaComponent(0.16),
                offset: CGSize(width: 0, height: 4),
                radius: 8,
                opacity: 1
            )
        case .lg:
            return CommonViewModel.Shadow(
                color: UIColor.black.withAlphaComponent(0.20),
                offset: CGSize(width: 0, height: 8),
                radius: 16,
                opacity: 1
            )
        }
    }
}
