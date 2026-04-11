import UIKit

public extension EAnimationView {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let animationName: String
        public let loopMode: LoopMode
        public let contentMode: ContentMode
        public let size: CGSize

        public enum LoopMode: Equatable {
            case playOnce
            case loop
            case autoReverse
        }

        public enum ContentMode: Equatable {
            case fit
            case fill
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            animationName: String,
            loopMode: LoopMode = .playOnce,
            contentMode: ContentMode = .fit,
            size: CGSize
        ) {
            self.common = common
            self.animationName = animationName
            self.loopMode = loopMode
            self.contentMode = contentMode
            self.size = size
        }
    }
}
