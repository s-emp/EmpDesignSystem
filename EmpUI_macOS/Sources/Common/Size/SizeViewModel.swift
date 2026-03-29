import Foundation

public struct SizeViewModel: Equatable {
    public let width: SizeDimension
    public let height: SizeDimension

    public init(
        width: SizeDimension = .hug,
        height: SizeDimension = .hug
    ) {
        self.width = width
        self.height = height
    }
}
