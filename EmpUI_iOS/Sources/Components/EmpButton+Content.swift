import UIKit

public extension EmpButton {
    struct Content {
        public let leading: Element?
        public let center: Element?
        public let trailing: Element?

        public init(
            leading: Element? = nil,
            center: Element? = nil,
            trailing: Element? = nil
        ) {
            self.leading = leading
            self.center = center
            self.trailing = trailing
        }

        // swiftlint:disable enum_case_associated_values_count
        public enum Element {
            case icon(UIImage, color: UIColor, size: CGFloat)
            case text(String, color: UIColor, font: UIFont)
            case titleSubtitle(
                title: String,
                subtitle: String,
                titleColor: UIColor,
                subtitleColor: UIColor,
                titleFont: UIFont,
                subtitleFont: UIFont
            )
        }
        // swiftlint:enable enum_case_associated_values_count
    }
}
