import UIKit

public struct EmpGradient: Equatable, @unchecked Sendable {
    public let startColor: UIColor
    public let endColor: UIColor

    public init(startColor: UIColor, endColor: UIColor) {
        self.startColor = startColor
        self.endColor = endColor
    }

    public func resolvedColors(for traitCollection: UITraitCollection) -> (start: CGColor, end: CGColor) {
        (
            startColor.resolvedColor(with: traitCollection).cgColor,
            endColor.resolvedColor(with: traitCollection).cgColor
        )
    }
}
