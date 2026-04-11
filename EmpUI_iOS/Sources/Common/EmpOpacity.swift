import CoreGraphics

public enum EmpOpacity: CGFloat, Sendable {
    case full = 1.0
    case high = 0.8
    case medium = 0.6
    case muted = 0.4
    case disabled = 0.3
    case faint = 0.15
    case none = 0.0
}
