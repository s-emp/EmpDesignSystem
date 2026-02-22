import AppKit
import Testing
@testable import EmpUI_macOS

// MARK: - Helper

private func resolvedHex(_ color: NSColor, dark: Bool) -> UInt32 {
    let saved = NSAppearance.current
    NSAppearance.current = NSAppearance(named: dark ? .darkAqua : .aqua)!
    defer { NSAppearance.current = saved }

    let resolved = color.usingColorSpace(.sRGB)!
    let r = UInt32(round(resolved.redComponent * 255))
    let g = UInt32(round(resolved.greenComponent * 255))
    let b = UInt32(round(resolved.blueComponent * 255))
    return (r << 16) | (g << 8) | b
}

// MARK: - NSAppearance+isDark

@Suite("NSAppearance+isDark")
struct NSAppearanceIsDarkTests {
    @Test("aqua — не dark")
    func aquaIsNotDark() throws {
        let appearance = try #require(NSAppearance(named: .aqua))
        #expect(!appearance.isDark)
    }

    @Test("darkAqua — dark")
    func darkAquaIsDark() throws {
        let appearance = try #require(NSAppearance(named: .darkAqua))
        #expect(appearance.isDark)
    }
}

// MARK: - Lavender

@Suite("NSColor.Base — Lavender")
struct BaseLavenderTests {
    @Test("Lavender light mode", arguments: [
        (NSColor.Base.lavender50, UInt32(0xF0F1FF)),
        (NSColor.Base.lavender100, UInt32(0xE2E3FF)),
        (NSColor.Base.lavender200, UInt32(0xC9C8FD)),
        (NSColor.Base.lavender300, UInt32(0x9B97F5)),
        (NSColor.Base.lavender500, UInt32(0x6C63FF)),
    ])
    func lavenderLight(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: false) == expected)
    }

    @Test("Lavender dark mode", arguments: [
        (NSColor.Base.lavender50, UInt32(0x1E1F32)),
        (NSColor.Base.lavender100, UInt32(0x2A2C48)),
        (NSColor.Base.lavender200, UInt32(0x3F4170)),
        (NSColor.Base.lavender300, UInt32(0x7D79DB)),
        (NSColor.Base.lavender500, UInt32(0x8B84FF)),
    ])
    func lavenderDark(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: true) == expected)
    }
}

// MARK: - Mint

@Suite("NSColor.Base — Mint")
struct BaseMintTests {
    @Test("Mint light mode", arguments: [
        (NSColor.Base.mint50, UInt32(0xEDFCF8)),
        (NSColor.Base.mint100, UInt32(0xD4F5EA)),
        (NSColor.Base.mint200, UInt32(0xB0ECDA)),
        (NSColor.Base.mint300, UInt32(0x6DD4BC)),
        (NSColor.Base.mint500, UInt32(0x2FB894)),
    ])
    func mintLight(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: false) == expected)
    }

    @Test("Mint dark mode", arguments: [
        (NSColor.Base.mint50, UInt32(0x192E28)),
        (NSColor.Base.mint100, UInt32(0x223E34)),
        (NSColor.Base.mint200, UInt32(0x2E5A4C)),
        (NSColor.Base.mint300, UInt32(0x52BEA4)),
        (NSColor.Base.mint500, UInt32(0x3ED4AE)),
    ])
    func mintDark(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: true) == expected)
    }
}

// MARK: - Peach

@Suite("NSColor.Base — Peach")
struct BasePeachTests {
    @Test("Peach light mode", arguments: [
        (NSColor.Base.peach50, UInt32(0xFFF7EC)),
        (NSColor.Base.peach100, UInt32(0xFFECD3)),
        (NSColor.Base.peach200, UInt32(0xFFDBB4)),
        (NSColor.Base.peach300, UInt32(0xF5B078)),
        (NSColor.Base.peach500, UInt32(0xF08C42)),
    ])
    func peachLight(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: false) == expected)
    }

    @Test("Peach dark mode", arguments: [
        (NSColor.Base.peach50, UInt32(0x2E2519)),
        (NSColor.Base.peach100, UInt32(0x3E3223)),
        (NSColor.Base.peach200, UInt32(0x5C482F)),
        (NSColor.Base.peach300, UInt32(0xD49560)),
        (NSColor.Base.peach500, UInt32(0xF5A05A)),
    ])
    func peachDark(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: true) == expected)
    }
}

// MARK: - Rose

@Suite("NSColor.Base — Rose")
struct BaseRoseTests {
    @Test("Rose light mode", arguments: [
        (NSColor.Base.rose50, UInt32(0xFFF0F1)),
        (NSColor.Base.rose100, UInt32(0xFFDEE2)),
        (NSColor.Base.rose200, UInt32(0xFFC8CF)),
        (NSColor.Base.rose300, UInt32(0xF58C99)),
        (NSColor.Base.rose500, UInt32(0xE85468)),
    ])
    func roseLight(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: false) == expected)
    }

    @Test("Rose dark mode", arguments: [
        (NSColor.Base.rose50, UInt32(0x2E191E)),
        (NSColor.Base.rose100, UInt32(0x3E2328)),
        (NSColor.Base.rose200, UInt32(0x5C303B)),
        (NSColor.Base.rose300, UInt32(0xD86E7C)),
        (NSColor.Base.rose500, UInt32(0xF07080)),
    ])
    func roseDark(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: true) == expected)
    }
}

// MARK: - Sky

@Suite("NSColor.Base — Sky")
struct BaseSkyTests {
    @Test("Sky light mode", arguments: [
        (NSColor.Base.sky50, UInt32(0xEDF6FF)),
        (NSColor.Base.sky100, UInt32(0xDAEDFF)),
        (NSColor.Base.sky200, UInt32(0xB5DCFF)),
        (NSColor.Base.sky300, UInt32(0x70BCF5)),
        (NSColor.Base.sky500, UInt32(0x3698F0)),
    ])
    func skyLight(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: false) == expected)
    }

    @Test("Sky dark mode", arguments: [
        (NSColor.Base.sky50, UInt32(0x192535)),
        (NSColor.Base.sky100, UInt32(0x22334C)),
        (NSColor.Base.sky200, UInt32(0x2E4A6E)),
        (NSColor.Base.sky300, UInt32(0x58A8DB)),
        (NSColor.Base.sky500, UInt32(0x4EB0F5)),
    ])
    func skyDark(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: true) == expected)
    }
}

// MARK: - Lemon

@Suite("NSColor.Base — Lemon")
struct BaseLemonTests {
    @Test("Lemon light mode", arguments: [
        (NSColor.Base.lemon50, UInt32(0xFFFCEB)),
        (NSColor.Base.lemon100, UInt32(0xFFF5CC)),
        (NSColor.Base.lemon200, UInt32(0xFFEBA5)),
        (NSColor.Base.lemon300, UInt32(0xF5D160)),
        (NSColor.Base.lemon500, UInt32(0xE8B420)),
    ])
    func lemonLight(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: false) == expected)
    }

    @Test("Lemon dark mode", arguments: [
        (NSColor.Base.lemon50, UInt32(0x2E2A17)),
        (NSColor.Base.lemon100, UInt32(0x3E3820)),
        (NSColor.Base.lemon200, UInt32(0x5C4F2C)),
        (NSColor.Base.lemon300, UInt32(0xD4B648)),
        (NSColor.Base.lemon500, UInt32(0xF0C838)),
    ])
    func lemonDark(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: true) == expected)
    }
}

// MARK: - Lilac

@Suite("NSColor.Base — Lilac")
struct BaseLilacTests {
    @Test("Lilac light mode", arguments: [
        (NSColor.Base.lilac50, UInt32(0xF8F0FF)),
        (NSColor.Base.lilac100, UInt32(0xEEDDFF)),
        (NSColor.Base.lilac200, UInt32(0xDFC6FF)),
        (NSColor.Base.lilac300, UInt32(0xBE8AF5)),
        (NSColor.Base.lilac500, UInt32(0x9C52E0)),
    ])
    func lilacLight(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: false) == expected)
    }

    @Test("Lilac dark mode", arguments: [
        (NSColor.Base.lilac50, UInt32(0x26192E)),
        (NSColor.Base.lilac100, UInt32(0x33233E)),
        (NSColor.Base.lilac200, UInt32(0x48305C)),
        (NSColor.Base.lilac300, UInt32(0xA86ED8)),
        (NSColor.Base.lilac500, UInt32(0xB56EF5)),
    ])
    func lilacDark(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: true) == expected)
    }
}

// MARK: - Neutral

@Suite("NSColor.Base — Neutral")
struct BaseNeutralTests {
    @Test("Neutral light mode", arguments: [
        (NSColor.Base.neutral50, UInt32(0xFAFAFA)),
        (NSColor.Base.neutral100, UInt32(0xF5F5F5)),
        (NSColor.Base.neutral200, UInt32(0xE5E5E5)),
        (NSColor.Base.neutral300, UInt32(0xD4D4D4)),
        (NSColor.Base.neutral500, UInt32(0x737373)),
        (NSColor.Base.neutral700, UInt32(0x404040)),
        (NSColor.Base.neutral900, UInt32(0x171717)),
    ])
    func neutralLight(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: false) == expected)
    }

    @Test("Neutral dark mode", arguments: [
        (NSColor.Base.neutral50, UInt32(0x171717)),
        (NSColor.Base.neutral100, UInt32(0x262626)),
        (NSColor.Base.neutral200, UInt32(0x404040)),
        (NSColor.Base.neutral300, UInt32(0x525252)),
        (NSColor.Base.neutral500, UInt32(0xA3A3A3)),
        (NSColor.Base.neutral700, UInt32(0xD4D4D4)),
        (NSColor.Base.neutral900, UInt32(0xFAFAFA)),
    ])
    func neutralDark(color: NSColor, expected: UInt32) {
        #expect(resolvedHex(color, dark: true) == expected)
    }
}
