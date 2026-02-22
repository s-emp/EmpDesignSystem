import AppKit
import Testing
@testable import EmpUI_macOS

// swiftlint:disable force_unwrapping
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

// swiftlint:enable force_unwrapping

@Suite("NSColor.Semantic")
struct SemanticColorTests {
    @Test("backgroundPrimary — white/dark", arguments: [
        (false, UInt32(0xFFFFFF)),
        (true, UInt32(0x0A0A0A)),
    ])
    func backgroundPrimary(dark: Bool, expected: UInt32) {
        #expect(resolvedHex(NSColor.Semantic.backgroundPrimary, dark: dark) == expected)
    }

    @Test("backgroundSecondary ссылается на neutral50")
    func backgroundSecondary() {
        #expect(NSColor.Semantic.backgroundSecondary === NSColor.Base.neutral50)
    }

    @Test("textPrimary ссылается на neutral900")
    func textPrimary() {
        #expect(NSColor.Semantic.textPrimary === NSColor.Base.neutral900)
    }

    @Test("actionPrimary ссылается на lavender500")
    func actionPrimary() {
        #expect(NSColor.Semantic.actionPrimary === NSColor.Base.lavender500)
    }

    @Test("backgroundTertiary ссылается на neutral100")
    func backgroundTertiary() {
        #expect(NSColor.Semantic.backgroundTertiary === NSColor.Base.neutral100)
    }

    // MARK: - Cards

    @Test("cardLavender ссылается на lavender50")
    func cardLavender() {
        #expect(NSColor.Semantic.cardLavender === NSColor.Base.lavender50)
    }

    @Test("cardBorderLavender ссылается на lavender200")
    func cardBorderLavender() {
        #expect(NSColor.Semantic.cardBorderLavender === NSColor.Base.lavender200)
    }

    // MARK: - Text

    @Test("textSecondary ссылается на neutral500")
    func textSecondary() {
        #expect(NSColor.Semantic.textSecondary === NSColor.Base.neutral500)
    }

    @Test("textAccent ссылается на lavender500")
    func textAccent() {
        #expect(NSColor.Semantic.textAccent === NSColor.Base.lavender500)
    }

    // MARK: - Actions

    @Test("actionSuccess ссылается на mint500")
    func actionSuccess() {
        #expect(NSColor.Semantic.actionSuccess === NSColor.Base.mint500)
    }

    @Test("actionDanger ссылается на rose500")
    func actionDanger() {
        #expect(NSColor.Semantic.actionDanger === NSColor.Base.rose500)
    }
<<<<<<< HEAD

    // MARK: - Actions — Hover

    @Test("actionPrimaryHover ссылается на lavender300")
    func actionPrimaryHover() {
        #expect(NSColor.Semantic.actionPrimaryHover === NSColor.Base.lavender300)
    }

    @Test("actionDangerHover ссылается на rose300")
    func actionDangerHover() {
        #expect(NSColor.Semantic.actionDangerHover === NSColor.Base.rose300)
    }

    // MARK: - Actions — Tint

    @Test("actionPrimaryTint ссылается на lavender50")
    func actionPrimaryTint() {
        #expect(NSColor.Semantic.actionPrimaryTint === NSColor.Base.lavender50)
    }

    @Test("actionDangerTint ссылается на rose50")
    func actionDangerTint() {
        #expect(NSColor.Semantic.actionDangerTint === NSColor.Base.rose50)
    }

    // MARK: - Actions — Base

    @Test("actionPrimaryBase ссылается на neutral100")
    func actionPrimaryBase() {
        #expect(NSColor.Semantic.actionPrimaryBase === NSColor.Base.neutral100)
    }

    @Test("actionPrimaryBaseHover ссылается на neutral200")
    func actionPrimaryBaseHover() {
        #expect(NSColor.Semantic.actionPrimaryBaseHover === NSColor.Base.neutral200)
    }

    @Test("actionDangerBase ссылается на rose50")
    func actionDangerBase() {
        #expect(NSColor.Semantic.actionDangerBase === NSColor.Base.rose50)
    }

    @Test("actionDangerBaseHover ссылается на rose100")
    func actionDangerBaseHover() {
        #expect(NSColor.Semantic.actionDangerBaseHover === NSColor.Base.rose100)
    }

    // MARK: - Text — Inverted

    @Test("textPrimaryInverted ссылается на neutralInverted900")
    func textPrimaryInverted() {
        #expect(NSColor.Semantic.textPrimaryInverted === NSColor.Base.neutralInverted900)
    }

    @Test("textSecondaryInverted ссылается на neutralInverted500")
    func textSecondaryInverted() {
        #expect(NSColor.Semantic.textSecondaryInverted === NSColor.Base.neutralInverted500)
    }
=======
>>>>>>> feature/emp-image
}
