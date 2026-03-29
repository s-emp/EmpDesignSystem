import AppKit

public extension EInfoCard {
    enum Background: Equatable {
        case color(NSColor)
        case gradient(EmpGradient)
    }
}
