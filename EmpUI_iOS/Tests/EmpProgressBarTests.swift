import Testing
import UIKit
@testable import EmpUI_iOS

// MARK: - ViewModel

@Suite("EmpProgressBar.ViewModel")
struct EmpProgressBarViewModelTests {
    @Test("Дефолтные значения ViewModel")
    func defaultValues() {
        let sut = EmpProgressBar.ViewModel()

        #expect(sut.common == CommonViewModel())
        #expect(sut.progress == 0)
        #expect(sut.trackColor == UIColor.Semantic.backgroundTertiary)
        #expect(sut.fillColor == UIColor.Semantic.actionPrimary)
        #expect(sut.barHeight == 4)
    }

    @Test("ViewModel сохраняет все поля")
    func storesFields() {
        let common = CommonViewModel(backgroundColor: .red)
        let sut = EmpProgressBar.ViewModel(
            common: common,
            progress: 0.5,
            trackColor: .gray,
            fillColor: .blue,
            barHeight: 8
        )

        #expect(sut.common == common)
        #expect(sut.progress == 0.5)
        #expect(sut.trackColor == .gray)
        #expect(sut.fillColor == .blue)
        #expect(sut.barHeight == 8)
    }

    @Test("Progress clamp — значение ниже 0 становится 0")
    func progressClampBelow() {
        let sut = EmpProgressBar.ViewModel(progress: -0.5)
        #expect(sut.progress == 0)
    }

    @Test("Progress clamp — значение выше 1 становится 1")
    func progressClampAbove() {
        let sut = EmpProgressBar.ViewModel(progress: 1.5)
        #expect(sut.progress == 1)
    }

    @Test("Progress clamp — граничные значения 0 и 1")
    func progressClampBoundaries() {
        let zero = EmpProgressBar.ViewModel(progress: 0)
        let one = EmpProgressBar.ViewModel(progress: 1)
        #expect(zero.progress == 0)
        #expect(one.progress == 1)
    }
}
