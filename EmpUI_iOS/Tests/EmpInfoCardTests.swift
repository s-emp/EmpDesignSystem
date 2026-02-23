import Testing
import UIKit
@testable import EmpUI_iOS

// MARK: - ViewModel

@Suite("EmpInfoCard.ViewModel")
struct EmpInfoCardViewModelTests {
    @Test("Сохраняет все поля")
    func storesFields() {
        let common = CommonViewModel(backgroundColor: .red)
        let sut = EmpInfoCard.ViewModel(
            common: common,
            subtitle: "Total Time",
            value: "12h 15m",
            subtitleColor: .blue,
            subtitleFont: .systemFont(ofSize: 13, weight: .bold),
            valueColor: .green,
            valueFont: .systemFont(ofSize: 28, weight: .heavy),
            background: .color(.yellow),
            spacing: 12
        )

        #expect(sut.common == common)
        #expect(sut.subtitle == "Total Time")
        #expect(sut.value == "12h 15m")
        #expect(sut.subtitleColor == .blue)
        #expect(sut.subtitleFont == .systemFont(ofSize: 13, weight: .bold))
        #expect(sut.valueColor == .green)
        #expect(sut.valueFont == .systemFont(ofSize: 28, weight: .heavy))
        #expect(sut.spacing == 12)
    }

    @Test("Дефолтные значения")
    func defaultValues() {
        let sut = EmpInfoCard.ViewModel(subtitle: "Label", value: "42")

        #expect(sut.common == CommonViewModel())
        #expect(sut.subtitle == "Label")
        #expect(sut.value == "42")
        #expect(sut.subtitleColor == UIColor.Semantic.textSecondary)
        #expect(sut.subtitleFont == .systemFont(ofSize: 11, weight: .medium))
        #expect(sut.valueColor == UIColor.Semantic.textPrimary)
        #expect(sut.valueFont == .systemFont(ofSize: 24, weight: .bold))
        #expect(sut.spacing == EmpSpacing.xs.rawValue)
    }
}

// MARK: - Background

@Suite("EmpInfoCard.Background")
struct EmpInfoCardBackgroundTests {
    @Test("Background.color сохраняет цвет")
    func colorCase() {
        let bg = EmpInfoCard.Background.color(.red)
        if case let .color(color) = bg {
            #expect(color == .red)
        } else {
            Issue.record("Ожидался .color, получен .gradient")
        }
    }

    @Test("Background.gradient сохраняет градиент")
    func gradientCase() {
        let gradient = EmpGradient(startColor: .red, endColor: .blue)
        let bg = EmpInfoCard.Background.gradient(gradient)
        if case let .gradient(stored) = bg {
            #expect(stored == gradient)
        } else {
            Issue.record("Ожидался .gradient, получен .color")
        }
    }
}

// MARK: - Preset

@Suite("EmpInfoCard.Preset")
struct EmpInfoCardPresetTests {
    @Test("default — задаёт дефолтные цвета и backgroundSecondary")
    func defaultPreset() {
        let sut = EmpInfoCard.Preset.default(subtitle: "Total Time", value: "12h 15m")

        #expect(sut.subtitle == "Total Time")
        #expect(sut.value == "12h 15m")
        #expect(sut.subtitleColor == UIColor.Semantic.textSecondary)
        #expect(sut.valueColor == UIColor.Semantic.textPrimary)
        #expect(sut.common.corners.radius == 12)
        #expect(sut.common.layoutMargins == UIEdgeInsets(
            top: EmpSpacing.m.rawValue,
            left: EmpSpacing.m.rawValue,
            bottom: EmpSpacing.m.rawValue,
            right: EmpSpacing.m.rawValue
        ))
        if case let .color(color) = sut.background {
            #expect(color == UIColor.Semantic.backgroundSecondary)
        } else {
            Issue.record("Ожидался .color, получен .gradient")
        }
    }

    @Test("gradient — задаёт белый текст и градиентный фон")
    func gradientPreset() {
        let gradient = EmpGradient.Preset.lavenderToSky
        let sut = EmpInfoCard.Preset.gradient(subtitle: "Session", value: "1h 47m", gradient: gradient)

        #expect(sut.subtitle == "Session")
        #expect(sut.value == "1h 47m")
        #expect(sut.subtitleColor == .white.withAlphaComponent(0.7))
        #expect(sut.valueColor == .white)
        #expect(sut.common.corners.radius == 12)
        if case let .gradient(stored) = sut.background {
            #expect(stored == gradient)
        } else {
            Issue.record("Ожидался .gradient, получен .color")
        }
    }
}
