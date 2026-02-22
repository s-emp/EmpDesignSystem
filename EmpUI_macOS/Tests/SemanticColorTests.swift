import AppKit
import Testing
@testable import EmpUI_macOS

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
    func textPrimary() { #expect(NSColor.Semantic.textPrimary === NSColor.Base.neutral900) }

    @Test("actionPrimary ссылается на lavender500")
    func actionPrimary() { #expect(NSColor.Semantic.actionPrimary === NSColor.Base.lavender500) }

    @Test("backgroundTertiary ссылается на neutral100")
    func backgroundTertiary() {
        #expect(NSColor.Semantic.backgroundTertiary === NSColor.Base.neutral100)
    }

    // MARK: - Cards

    @Test("cardLavender ссылается на lavender50")
    func cardLavender() { #expect(NSColor.Semantic.cardLavender === NSColor.Base.lavender50) }

    @Test("cardBorderLavender ссылается на lavender200")
    func cardBorderLavender() { #expect(NSColor.Semantic.cardBorderLavender === NSColor.Base.lavender200) }

    // MARK: - Text

    @Test("textSecondary ссылается на neutral500")
    func textSecondary() { #expect(NSColor.Semantic.textSecondary === NSColor.Base.neutral500) }

    @Test("textAccent ссылается на lavender500")
    func textAccent() { #expect(NSColor.Semantic.textAccent === NSColor.Base.lavender500) }

    // MARK: - Actions

    @Test("actionSuccess ссылается на mint500")
    func actionSuccess() { #expect(NSColor.Semantic.actionSuccess === NSColor.Base.mint500) }

    @Test("actionDanger ссылается на rose500")
    func actionDanger() { #expect(NSColor.Semantic.actionDanger === NSColor.Base.rose500) }
}
