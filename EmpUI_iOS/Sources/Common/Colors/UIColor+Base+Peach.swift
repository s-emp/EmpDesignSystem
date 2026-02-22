import UIKit

public extension UIColor.Base {

    static let peach50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E2519) : UIColor(hex: 0xFFF7EC) }
    static let peach100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3E3223) : UIColor(hex: 0xFFECD3) }
    static let peach200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x5C482F) : UIColor(hex: 0xFFDBB4) }
    static let peach300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xD49560) : UIColor(hex: 0xF5B078) }
    static let peach500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xF5A05A) : UIColor(hex: 0xF08C42) }
}
