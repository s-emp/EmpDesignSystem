import UIKit

public extension UIColor {

    enum Semantic {}
}

public extension UIColor.Semantic {

    // MARK: - Backgrounds

    static let backgroundPrimary = UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: 0x0A0A0A) : .white }
    static let backgroundSecondary = UIColor.Base.neutral50
    static let backgroundTertiary = UIColor.Base.neutral100

    // MARK: - Cards

    static let cardLavender = UIColor.Base.lavender50
    static let cardBorderLavender = UIColor.Base.lavender200
    static let cardMint = UIColor.Base.mint50
    static let cardBorderMint = UIColor.Base.mint200
    static let cardPeach = UIColor.Base.peach50
    static let cardBorderPeach = UIColor.Base.peach200
    static let cardRose = UIColor.Base.rose50
    static let cardBorderRose = UIColor.Base.rose200
    static let cardSky = UIColor.Base.sky50
    static let cardBorderSky = UIColor.Base.sky200
    static let cardLemon = UIColor.Base.lemon50
    static let cardBorderLemon = UIColor.Base.lemon200
    static let cardLilac = UIColor.Base.lilac50
    static let cardBorderLilac = UIColor.Base.lilac200

    // MARK: - Borders

    static let borderDefault = UIColor.Base.neutral200
    static let borderSubtle = UIColor.Base.neutral100

    // MARK: - Text

    static let textPrimary = UIColor.Base.neutral900
    static let textSecondary = UIColor.Base.neutral500
    static let textTertiary = UIColor.Base.neutral300
    static let textAccent = UIColor.Base.lavender500

    // MARK: - Actions

    static let actionPrimary = UIColor.Base.lavender500
    static let actionSuccess = UIColor.Base.mint500
    static let actionWarning = UIColor.Base.peach500
    static let actionDanger = UIColor.Base.rose500
    static let actionInfo = UIColor.Base.sky500
}
