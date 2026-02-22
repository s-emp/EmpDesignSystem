import UIKit

public extension UIColor.Base {

    static let lemon50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E2A17) : UIColor(hex: 0xFFFCEB) }
    static let lemon100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3E3820) : UIColor(hex: 0xFFF5CC) }
    static let lemon200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x5C4F2C) : UIColor(hex: 0xFFEBA5) }
    static let lemon300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xD4B648) : UIColor(hex: 0xF5D160) }
    static let lemon500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xF0C838) : UIColor(hex: 0xE8B420) }
}
