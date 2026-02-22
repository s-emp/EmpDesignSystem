import UIKit

public extension UIColor.Base {

    static let lavender50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x1E1F32) : UIColor(hex: 0xF0F1FF) }
    static let lavender100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2A2C48) : UIColor(hex: 0xE2E3FF) }
    static let lavender200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3F4170) : UIColor(hex: 0xC9C8FD) }
    static let lavender300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x7D79DB) : UIColor(hex: 0x9B97F5) }
    static let lavender500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x8B84FF) : UIColor(hex: 0x6C63FF) }
}
