import AppKit
import QuartzCore

public extension EmpAnimation {
    enum Easing: Sendable {
        case easeIn
        case easeOut
        case easeInOut
        case spring(damping: CGFloat, velocity: CGFloat)

        public var timingFunction: CAMediaTimingFunction {
            switch self {
            case .easeIn:
                return CAMediaTimingFunction(name: .easeIn)
            case .easeOut:
                return CAMediaTimingFunction(name: .easeOut)
            case .easeInOut:
                return CAMediaTimingFunction(name: .easeInEaseOut)
            case .spring:
                return CAMediaTimingFunction(name: .easeInEaseOut)
            }
        }

        @MainActor
        public func animate(
            duration: Duration,
            animations: @escaping @Sendable () -> Void,
            completion: (@Sendable () -> Void)? = nil
        ) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = duration.rawValue
                context.timingFunction = timingFunction
                context.allowsImplicitAnimation = true
                animations()
            } completionHandler: {
                completion?()
            }
        }
    }
}
