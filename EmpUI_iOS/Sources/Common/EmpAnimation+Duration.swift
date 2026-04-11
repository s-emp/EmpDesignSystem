import Foundation

public extension EmpAnimation {
    enum Duration: TimeInterval, Sendable {
        case instant = 0.1
        case fast = 0.2
        case normal = 0.3
        case slow = 0.5
        case deliberate = 0.8
    }
}
