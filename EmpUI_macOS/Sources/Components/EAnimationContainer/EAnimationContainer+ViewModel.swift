import AppKit

public extension EAnimationContainer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let transition: Transition
        public let duration: TimeInterval

        public init(
            common: CommonViewModel = CommonViewModel(),
            transition: Transition,
            duration: TimeInterval
        ) {
            self.common = common
            self.transition = transition
            self.duration = duration
        }
    }
}
