import Foundation

public struct EItem: Hashable {
    public let id: AnyHashable
    public let descriptor: ComponentDescriptor

    public init(id: some Hashable, descriptor: ComponentDescriptor) {
        self.id = AnyHashable(id)
        self.descriptor = descriptor
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.descriptor == rhs.descriptor
    }
}
