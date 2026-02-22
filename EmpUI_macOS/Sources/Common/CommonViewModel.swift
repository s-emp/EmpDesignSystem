import AppKit

public struct CommonViewModel {

    // MARK: - Properties

    public let border: Border
    public let shadow: Shadow
    public let corners: Corners
    public let backgroundColor: NSColor
    public let layoutMargins: NSEdgeInsets

    // MARK: - Init

    public init(
        border: Border = Border(),
        shadow: Shadow = Shadow(),
        corners: Corners = Corners(),
        backgroundColor: NSColor = .clear,
        layoutMargins: NSEdgeInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    ) {
        self.border = border
        self.shadow = shadow
        self.corners = corners
        self.backgroundColor = backgroundColor
        self.layoutMargins = layoutMargins
    }
}

// MARK: - Border

extension CommonViewModel {

    public struct Border {
        public let width: CGFloat
        public let color: NSColor
        public let style: Style

        public enum Style {
            case solid
            case dashed
        }

        public init(
            width: CGFloat = 0,
            color: NSColor = .clear,
            style: Style = .solid
        ) {
            self.width = width
            self.color = color
            self.style = style
        }
    }
}

// MARK: - Shadow

extension CommonViewModel {

    public struct Shadow {
        public let color: NSColor
        public let offset: CGSize
        public let radius: CGFloat
        public let opacity: Float

        public init(
            color: NSColor = .clear,
            offset: CGSize = .zero,
            radius: CGFloat = 0,
            opacity: Float = 0
        ) {
            self.color = color
            self.offset = offset
            self.radius = radius
            self.opacity = opacity
        }
    }
}

// MARK: - Corners

extension CommonViewModel {

    public struct Corners {
        public let radius: CGFloat
        public let maskedCorners: CACornerMask

        public init(
            radius: CGFloat = 0,
            maskedCorners: CACornerMask = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner,
            ]
        ) {
            self.radius = radius
            self.maskedCorners = maskedCorners
        }
    }
}
