import UIKit

public extension UIColor.Base {

    static let rose50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E191E) : UIColor(hex: 0xFFF0F1) }
    static let rose100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3E2328) : UIColor(hex: 0xFFDEE2) }
    static let rose200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x5C303B) : UIColor(hex: 0xFFC8CF) }
    static let rose300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xD86E7C) : UIColor(hex: 0xF58C99) }
    static let rose500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0xF07080) : UIColor(hex: 0xE85468) }
}
