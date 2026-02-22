import UIKit

public extension UIColor.Base {

    static let sky50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x192535) : UIColor(hex: 0xEDF6FF) }
    static let sky100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x22334C) : UIColor(hex: 0xDAEDFF) }
    static let sky200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E4A6E) : UIColor(hex: 0xB5DCFF) }
    static let sky300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x58A8DB) : UIColor(hex: 0x70BCF5) }
    static let sky500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x4EB0F5) : UIColor(hex: 0x3698F0) }
}
