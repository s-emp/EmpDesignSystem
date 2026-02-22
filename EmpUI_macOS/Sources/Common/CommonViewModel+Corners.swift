import AppKit

extension CommonViewModel {

    public struct Corners: Equatable {
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
