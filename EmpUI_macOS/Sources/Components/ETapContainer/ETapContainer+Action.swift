import Foundation

public extension ETapContainer.ViewModel {
    struct Action: Equatable {
        public let id: String
        public var handler: (ETapContainer.ViewModel) -> Void

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }

        public init(id: String, handler: @escaping (ETapContainer.ViewModel) -> Void) {
            self.id = id
            self.handler = handler
        }
    }
}
