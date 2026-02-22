import UIKit

public extension UIColor.Base {

    static let lilac50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x26192E) : UIColor(hex: 0xF8F0FF) }
    static let lilac100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x33233E) : UIColor(hex: 0xEEDDFF) }
    static let lilac200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x48305C) : UIColor(hex: 0xDFC6FF) }
    static let lilac300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xA86ED8) : UIColor(hex: 0xBE8AF5) }
    static let lilac500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xB56EF5) : UIColor(hex: 0x9C52E0) }
}
