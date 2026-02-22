import UIKit

public extension UIColor.Base {
    static let mint50 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x192E28) : UIColor(hex: 0xEDFCF8) }
    static let mint100 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x223E34) : UIColor(hex: 0xD4F5EA) }
    static let mint200 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x2E5A4C) : UIColor(hex: 0xB0ECDA) }
    static let mint300 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x52BEA4) : UIColor(hex: 0x6DD4BC) }
    static let mint500 = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x3ED4AE) : UIColor(hex: 0x2FB894) }
}
