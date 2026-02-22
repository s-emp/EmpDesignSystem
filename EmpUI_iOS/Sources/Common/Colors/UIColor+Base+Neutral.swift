import UIKit

public extension UIColor.Base {
    static let neutral50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x171717) : UIColor(hex: 0xFAFAFA) }
    static let neutral100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x262626) : UIColor(hex: 0xF5F5F5) }
    static let neutral200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x404040) : UIColor(hex: 0xE5E5E5) }
    static let neutral300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x525252) : UIColor(hex: 0xD4D4D4) }
    static let neutral500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xA3A3A3) : UIColor(hex: 0x737373) }
    static let neutral700 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xD4D4D4) : UIColor(hex: 0x404040) }
    static let neutral900 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xFAFAFA) : UIColor(hex: 0x171717) }
}
