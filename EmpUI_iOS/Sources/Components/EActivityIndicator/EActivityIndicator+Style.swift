import UIKit

public extension EActivityIndicator.ViewModel {
    enum Style: Equatable {
        case small
        case medium
        case large

        var uiStyle: UIActivityIndicatorView.Style {
            switch self {
            case .small:  return .medium
            case .medium: return .medium
            case .large:  return .large
            }
        }

        var size: CGFloat {
            switch self {
            case .small:  return 20
            case .medium: return 37
            case .large:  return 37
            }
        }
    }
}
