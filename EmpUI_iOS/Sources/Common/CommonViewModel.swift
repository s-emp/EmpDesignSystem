import UIKit

public struct CommonViewModel: Equatable {
    // MARK: - Properties

    public let border: Border
    public let shadow: Shadow
    public let corners: Corners
    public let backgroundColor: UIColor
    public let layoutMargins: UIEdgeInsets

    // MARK: - Init

    public init(
        border: Border = Border(),
        shadow: Shadow = Shadow(),
        corners: Corners = Corners(),
        backgroundColor: UIColor = .clear,
        layoutMargins: UIEdgeInsets = .zero
    ) {
        self.border = border
        self.shadow = shadow
        self.corners = corners
        self.backgroundColor = backgroundColor
        self.layoutMargins = layoutMargins
    }
}
