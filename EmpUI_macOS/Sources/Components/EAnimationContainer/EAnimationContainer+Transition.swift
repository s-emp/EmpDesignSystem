import Foundation

public extension EAnimationContainer.ViewModel {
    enum Transition: Equatable {
        case fade
        case scale(from: CGFloat)
        case slide(edge: Edge)

        public enum Edge: Equatable {
            case top, bottom, leading, trailing
        }
    }
}
