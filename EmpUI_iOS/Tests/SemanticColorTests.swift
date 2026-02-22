import Testing
import UIKit
@testable import EmpUI_iOS

private func resolvedHex(_ color: UIColor, style: UIUserInterfaceStyle) -> UInt32 {
    let traits = UITraitCollection(userInterfaceStyle: style)
    let resolved = color.resolvedColor(with: traits)
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    resolved.getRed(&r, green: &g, blue: &b, alpha: &a)
    return (UInt32(round(r * 255)) << 16) | (UInt32(round(g * 255)) << 8) | UInt32(round(b * 255))
}

@Suite("UIColor.Semantic")
struct SemanticColorTests {

    @Test("backgroundPrimary — white/dark", arguments: [
        (UIUserInterfaceStyle.light, UInt32(0xFFFFFF)),
        (UIUserInterfaceStyle.dark, UInt32(0x0A0A0A)),
    ])
    func backgroundPrimary(style: UIUserInterfaceStyle, expected: UInt32) {
        #expect(resolvedHex(UIColor.Semantic.backgroundPrimary, style: style) == expected)
    }

    @Test("backgroundSecondary ссылается на neutral50")
    func backgroundSecondary() {
        #expect(UIColor.Semantic.backgroundSecondary === UIColor.Base.neutral50)
    }

    @Test("backgroundTertiary ссылается на neutral100")
    func backgroundTertiary() {
        #expect(UIColor.Semantic.backgroundTertiary === UIColor.Base.neutral100)
    }

    @Test("cardLavender ссылается на lavender50")
    func cardLavender() { #expect(UIColor.Semantic.cardLavender === UIColor.Base.lavender50) }

    @Test("cardBorderLavender ссылается на lavender200")
    func cardBorderLavender() { #expect(UIColor.Semantic.cardBorderLavender === UIColor.Base.lavender200) }

    @Test("textPrimary ссылается на neutral900")
    func textPrimary() { #expect(UIColor.Semantic.textPrimary === UIColor.Base.neutral900) }

    @Test("textSecondary ссылается на neutral500")
    func textSecondary() { #expect(UIColor.Semantic.textSecondary === UIColor.Base.neutral500) }

    @Test("textAccent ссылается на lavender500")
    func textAccent() { #expect(UIColor.Semantic.textAccent === UIColor.Base.lavender500) }

    @Test("actionPrimary ссылается на lavender500")
    func actionPrimary() { #expect(UIColor.Semantic.actionPrimary === UIColor.Base.lavender500) }

    @Test("actionSuccess ссылается на mint500")
    func actionSuccess() { #expect(UIColor.Semantic.actionSuccess === UIColor.Base.mint500) }

    @Test("actionDanger ссылается на rose500")
    func actionDanger() { #expect(UIColor.Semantic.actionDanger === UIColor.Base.rose500) }
}
