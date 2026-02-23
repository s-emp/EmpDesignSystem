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
