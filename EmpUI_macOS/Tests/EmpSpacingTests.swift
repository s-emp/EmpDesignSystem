import AppKit
import Testing
@testable import EmpUI_macOS

@Suite("EmpSpacing")
struct EmpSpacingTests {
    @Test("Все токены соответствуют ожидаемым значениям", arguments: [
        (EmpSpacing.xxs, 4.0),
        (EmpSpacing.xs, 8.0),
        (EmpSpacing.s, 12.0),
        (EmpSpacing.m, 16.0),
        (EmpSpacing.l, 20.0),
        (EmpSpacing.xl, 24.0),
        (EmpSpacing.xxl, 32.0),
        (EmpSpacing.xxxl, 40.0),
    ] as [(EmpSpacing, Double)])
    func tokenValues(token: EmpSpacing, expected: Double) {
        #expect(token.rawValue == CGFloat(expected))
    }

    @Test("Все токены кратны 4")
    func allMultiplesOfFour() {
        for token in [EmpSpacing.xxs, .xs, .s, .m, .l, .xl, .xxl, .xxxl] {
            #expect(token.rawValue.truncatingRemainder(dividingBy: 4) == 0)
        }
    }

    @Test("NSEdgeInsets init корректно передаёт значения")
    func edgeInsetsInit() {
        let insets = NSEdgeInsets(top: .xs, left: .m, bottom: .s, right: .xl)
        #expect(insets == NSEdgeInsets(top: 8, left: 16, bottom: 12, right: 24))
    }

    @Test("NSEdgeInsets init с одинаковыми значениями")
    func edgeInsetsUniform() {
        let insets = NSEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
        #expect(insets == NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
}
