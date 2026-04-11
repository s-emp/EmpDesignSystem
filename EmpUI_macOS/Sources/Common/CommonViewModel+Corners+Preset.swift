import AppKit

public extension CommonViewModel.Corners {
    enum Preset {
        case none
        case xs
        case sm
        case md
        case lg
        case xl
        case full

        public var radius: CGFloat {
            switch self {
            case .none: 0
            case .xs: 4
            case .sm: 8
            case .md: 12
            case .lg: 16
            case .xl: 24
            case .full: 9999
            }
        }
    }

    static func preset(
        _ preset: Preset,
        maskedCorners: CACornerMask = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
        ]
    ) -> CommonViewModel.Corners {
        CommonViewModel.Corners(
            radius: preset.radius,
            maskedCorners: maskedCorners
        )
    }
}
