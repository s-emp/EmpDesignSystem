import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("EmpGradient")
struct EmpGradientTests {

    @Test("Инициализация сохраняет цвета", arguments: [
        (true, UIColor.Base.lavender200),
        (false, UIColor.Base.sky200),
    ])
    func initStoresColors(isStart: Bool, expected: UIColor) {
        let gradient = EmpGradient(startColor: UIColor.Base.lavender200, endColor: UIColor.Base.sky200)
        let actual = isStart ? gradient.startColor : gradient.endColor
        #expect(actual === expected)
    }

    @Test("Equatable — одинаковые градиенты равны")
    func equatable() {
        let a = EmpGradient.Preset.lavenderToSky
        let b = EmpGradient.Preset.lavenderToSky
        #expect(a == b)
    }

    @Test("resolvedColors возвращает CGColor для light mode", arguments: [true, false])
    func resolvedColorsLight(isStart: Bool) {
        let gradient = EmpGradient.Preset.lavenderToSky
        let traits = UITraitCollection(userInterfaceStyle: .light)
        let (start, end) = gradient.resolvedColors(for: traits)
        let color = isStart ? start : end
        #expect(color.numberOfComponents >= 3)
    }

    @Test("Пресет lavenderToSky использует правильные базовые цвета", arguments: [
        (true, UIColor.Base.lavender200),
        (false, UIColor.Base.sky200),
    ])
    func presetLavenderToSky(isStart: Bool, expected: UIColor) {
        let preset = EmpGradient.Preset.lavenderToSky
        let actual = isStart ? preset.startColor : preset.endColor
        #expect(actual === expected)
    }
}
