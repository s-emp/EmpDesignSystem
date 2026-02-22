import AppKit
import Testing
@testable import EmpUI_macOS

@Suite("EmpGradient")
struct EmpGradientTests {

    @Test("Инициализация сохраняет цвета", arguments: [
        (true, NSColor.Base.lavender200),
        (false, NSColor.Base.sky200),
    ])
    func initStoresColors(isStart: Bool, expected: NSColor) {
        let gradient = EmpGradient(startColor: NSColor.Base.lavender200, endColor: NSColor.Base.sky200)
        let actual = isStart ? gradient.startColor : gradient.endColor
        #expect(actual === expected)
    }

    @Test("Equatable — одинаковые градиенты равны")
    func equatable() {
        let a = EmpGradient.Preset.lavenderToSky
        let b = EmpGradient.Preset.lavenderToSky
        #expect(a == b)
    }

    @Test("resolvedColors возвращает CGColor", arguments: [true, false])
    func resolvedColors(isStart: Bool) {
        let gradient = EmpGradient.Preset.lavenderToSky
        let appearance = NSAppearance(named: .aqua)!
        let (start, end) = gradient.resolvedColors(for: appearance)
        let color = isStart ? start : end
        #expect(color.numberOfComponents >= 3)
    }

    @Test("Пресет lavenderToSky использует правильные базовые цвета", arguments: [
        (true, NSColor.Base.lavender200),
        (false, NSColor.Base.sky200),
    ])
    func presetLavenderToSky(isStart: Bool, expected: NSColor) {
        let preset = EmpGradient.Preset.lavenderToSky
        let actual = isStart ? preset.startColor : preset.endColor
        #expect(actual === expected)
    }
}
