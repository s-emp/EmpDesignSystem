import UIKit

public extension CommonViewModel {
    struct Border: Equatable {
        public let width: CGFloat
        public let color: UIColor
        public let style: Style

        public enum Style {
            case solid
            case dashed
        }

        public init(
            width: CGFloat = 0,
            color: UIColor = .clear,
            style: Style = .solid
        ) {
            self.width = width
            self.color = color
            self.style = style
        }
    }
}
