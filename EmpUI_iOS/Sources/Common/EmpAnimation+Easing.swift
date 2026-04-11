import UIKit

public extension EmpAnimation {
    enum Easing: Sendable {
        case easeIn
        case easeOut
        case easeInOut
        case spring(damping: CGFloat, velocity: CGFloat)

        public var animationOptions: UIView.AnimationOptions {
            switch self {
            case .easeIn: return .curveEaseIn
            case .easeOut: return .curveEaseOut
            case .easeInOut: return .curveEaseInOut
            case .spring: return []
            }
        }

        @MainActor
        public func animate(
            duration: Duration,
            animations: @escaping @Sendable () -> Void,
            completion: (@Sendable (Bool) -> Void)? = nil
        ) {
            switch self {
            case .spring(let damping, let velocity):
                UIView.animate(
                    withDuration: duration.rawValue,
                    delay: 0,
                    usingSpringWithDamping: damping,
                    initialSpringVelocity: velocity,
                    options: [],
                    animations: animations,
                    completion: completion
                )
            default:
                UIView.animate(
                    withDuration: duration.rawValue,
                    delay: 0,
                    options: animationOptions,
                    animations: animations,
                    completion: completion
                )
            }
        }
    }
}
