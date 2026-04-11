import AppKit

public extension EActivityIndicator.ViewModel {
    enum Style: Equatable {
        case small
        case medium
        case large

        var controlSize: NSControl.ControlSize {
            switch self {
            case .small:  return .small
            case .medium: return .regular
            case .large:  return .large
            }
        }

        var size: CGFloat {
            switch self {
            case .small:  return 16
            case .medium: return 32
            case .large:  return 64
            }
        }
    }
}
