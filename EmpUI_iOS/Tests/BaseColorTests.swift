import Testing
import UIKit
@testable import EmpUI_iOS

// MARK: - Helper

private func resolvedHex(_ color: UIColor, style: UIUserInterfaceStyle) -> UInt32 {
    let traits = UITraitCollection(userInterfaceStyle: style)
    let resolved = color.resolvedColor(with: traits)
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    resolved.getRed(&r, green: &g, blue: &b, alpha: &a)
    return (UInt32(round(r * 255)) << 16) | (UInt32(round(g * 255)) << 8) | UInt32(round(b * 255))
}

// MARK: - Lavender

@Suite("UIColor.Base — Lavender")
struct BaseLavenderTests {

    @Test("Lavender light mode", arguments: [
        (UIColor.Base.lavender50, UInt32(0xF0F1FF)),
        (UIColor.Base.lavender100, UInt32(0xE2E3FF)),
        (UIColor.Base.lavender200, UInt32(0xC9C8FD)),
        (UIColor.Base.lavender300, UInt32(0x9B97F5)),
        (UIColor.Base.lavender500, UInt32(0x6C63FF)),
    ])
    func lavenderLight(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .light) == expected)
    }

    @Test("Lavender dark mode", arguments: [
        (UIColor.Base.lavender50, UInt32(0x1E1F32)),
        (UIColor.Base.lavender100, UInt32(0x2A2C48)),
        (UIColor.Base.lavender200, UInt32(0x3F4170)),
        (UIColor.Base.lavender300, UInt32(0x7D79DB)),
        (UIColor.Base.lavender500, UInt32(0x8B84FF)),
    ])
    func lavenderDark(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .dark) == expected)
    }
}

// MARK: - Mint

@Suite("UIColor.Base — Mint")
struct BaseMintTests {

    @Test("Mint light mode", arguments: [
        (UIColor.Base.mint50, UInt32(0xEDFCF8)),
        (UIColor.Base.mint100, UInt32(0xD4F5EA)),
        (UIColor.Base.mint200, UInt32(0xB0ECDA)),
        (UIColor.Base.mint300, UInt32(0x6DD4BC)),
        (UIColor.Base.mint500, UInt32(0x2FB894)),
    ])
    func mintLight(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .light) == expected)
    }

    @Test("Mint dark mode", arguments: [
        (UIColor.Base.mint50, UInt32(0x192E28)),
        (UIColor.Base.mint100, UInt32(0x223E34)),
        (UIColor.Base.mint200, UInt32(0x2E5A4C)),
        (UIColor.Base.mint300, UInt32(0x52BEA4)),
        (UIColor.Base.mint500, UInt32(0x3ED4AE)),
    ])
    func mintDark(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .dark) == expected)
    }
}

// MARK: - Peach

@Suite("UIColor.Base — Peach")
struct BasePeachTests {

    @Test("Peach light mode", arguments: [
        (UIColor.Base.peach50, UInt32(0xFFF7EC)),
        (UIColor.Base.peach100, UInt32(0xFFECD3)),
        (UIColor.Base.peach200, UInt32(0xFFDBB4)),
        (UIColor.Base.peach300, UInt32(0xF5B078)),
        (UIColor.Base.peach500, UInt32(0xF08C42)),
    ])
    func peachLight(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .light) == expected)
    }

    @Test("Peach dark mode", arguments: [
        (UIColor.Base.peach50, UInt32(0x2E2519)),
        (UIColor.Base.peach100, UInt32(0x3E3223)),
        (UIColor.Base.peach200, UInt32(0x5C482F)),
        (UIColor.Base.peach300, UInt32(0xD49560)),
        (UIColor.Base.peach500, UInt32(0xF5A05A)),
    ])
    func peachDark(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .dark) == expected)
    }
}

// MARK: - Rose

@Suite("UIColor.Base — Rose")
struct BaseRoseTests {

    @Test("Rose light mode", arguments: [
        (UIColor.Base.rose50, UInt32(0xFFF0F1)),
        (UIColor.Base.rose100, UInt32(0xFFDEE2)),
        (UIColor.Base.rose200, UInt32(0xFFC8CF)),
        (UIColor.Base.rose300, UInt32(0xF58C99)),
        (UIColor.Base.rose500, UInt32(0xE85468)),
    ])
    func roseLight(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .light) == expected)
    }

    @Test("Rose dark mode", arguments: [
        (UIColor.Base.rose50, UInt32(0x2E191E)),
        (UIColor.Base.rose100, UInt32(0x3E2328)),
        (UIColor.Base.rose200, UInt32(0x5C303B)),
        (UIColor.Base.rose300, UInt32(0xD86E7C)),
        (UIColor.Base.rose500, UInt32(0xF07080)),
    ])
    func roseDark(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .dark) == expected)
    }
}

// MARK: - Sky

@Suite("UIColor.Base — Sky")
struct BaseSkyTests {

    @Test("Sky light mode", arguments: [
        (UIColor.Base.sky50, UInt32(0xEDF6FF)),
        (UIColor.Base.sky100, UInt32(0xDAEDFF)),
        (UIColor.Base.sky200, UInt32(0xB5DCFF)),
        (UIColor.Base.sky300, UInt32(0x70BCF5)),
        (UIColor.Base.sky500, UInt32(0x3698F0)),
    ])
    func skyLight(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .light) == expected)
    }

    @Test("Sky dark mode", arguments: [
        (UIColor.Base.sky50, UInt32(0x192535)),
        (UIColor.Base.sky100, UInt32(0x22334C)),
        (UIColor.Base.sky200, UInt32(0x2E4A6E)),
        (UIColor.Base.sky300, UInt32(0x58A8DB)),
        (UIColor.Base.sky500, UInt32(0x4EB0F5)),
    ])
    func skyDark(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .dark) == expected)
    }
}

// MARK: - Lemon

@Suite("UIColor.Base — Lemon")
struct BaseLemonTests {

    @Test("Lemon light mode", arguments: [
        (UIColor.Base.lemon50, UInt32(0xFFFCEB)),
        (UIColor.Base.lemon100, UInt32(0xFFF5CC)),
        (UIColor.Base.lemon200, UInt32(0xFFEBA5)),
        (UIColor.Base.lemon300, UInt32(0xF5D160)),
        (UIColor.Base.lemon500, UInt32(0xE8B420)),
    ])
    func lemonLight(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .light) == expected)
    }

    @Test("Lemon dark mode", arguments: [
        (UIColor.Base.lemon50, UInt32(0x2E2A17)),
        (UIColor.Base.lemon100, UInt32(0x3E3820)),
        (UIColor.Base.lemon200, UInt32(0x5C4F2C)),
        (UIColor.Base.lemon300, UInt32(0xD4B648)),
        (UIColor.Base.lemon500, UInt32(0xF0C838)),
    ])
    func lemonDark(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .dark) == expected)
    }
}

// MARK: - Lilac

@Suite("UIColor.Base — Lilac")
struct BaseLilacTests {

    @Test("Lilac light mode", arguments: [
        (UIColor.Base.lilac50, UInt32(0xF8F0FF)),
        (UIColor.Base.lilac100, UInt32(0xEEDDFF)),
        (UIColor.Base.lilac200, UInt32(0xDFC6FF)),
        (UIColor.Base.lilac300, UInt32(0xBE8AF5)),
        (UIColor.Base.lilac500, UInt32(0x9C52E0)),
    ])
    func lilacLight(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .light) == expected)
    }

    @Test("Lilac dark mode", arguments: [
        (UIColor.Base.lilac50, UInt32(0x26192E)),
        (UIColor.Base.lilac100, UInt32(0x33233E)),
        (UIColor.Base.lilac200, UInt32(0x48305C)),
        (UIColor.Base.lilac300, UInt32(0xA86ED8)),
        (UIColor.Base.lilac500, UInt32(0xB56EF5)),
    ])
    func lilacDark(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .dark) == expected)
    }
}

// MARK: - Neutral

@Suite("UIColor.Base — Neutral")
struct BaseNeutralTests {

    @Test("Neutral light mode", arguments: [
        (UIColor.Base.neutral50, UInt32(0xFAFAFA)),
        (UIColor.Base.neutral100, UInt32(0xF5F5F5)),
        (UIColor.Base.neutral200, UInt32(0xE5E5E5)),
        (UIColor.Base.neutral300, UInt32(0xD4D4D4)),
        (UIColor.Base.neutral500, UInt32(0x737373)),
        (UIColor.Base.neutral700, UInt32(0x404040)),
        (UIColor.Base.neutral900, UInt32(0x171717)),
    ])
    func neutralLight(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .light) == expected)
    }

    @Test("Neutral dark mode", arguments: [
        (UIColor.Base.neutral50, UInt32(0x171717)),
        (UIColor.Base.neutral100, UInt32(0x262626)),
        (UIColor.Base.neutral200, UInt32(0x404040)),
        (UIColor.Base.neutral300, UInt32(0x525252)),
        (UIColor.Base.neutral500, UInt32(0xA3A3A3)),
        (UIColor.Base.neutral700, UInt32(0xD4D4D4)),
        (UIColor.Base.neutral900, UInt32(0xFAFAFA)),
    ])
    func neutralDark(color: UIColor, expected: UInt32) {
        #expect(resolvedHex(color, style: .dark) == expected)
    }
}
