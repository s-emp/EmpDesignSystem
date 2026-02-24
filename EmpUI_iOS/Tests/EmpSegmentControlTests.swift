import Testing
import UIKit
@testable import EmpUI_iOS

// MARK: - ViewModel

@Suite("EmpSegmentControl.ViewModel")
struct EmpSegmentControlViewModelTests {
    @Test("Сохраняет все поля")
    func storesFields() {
        let common = CommonViewModel(backgroundColor: .red)
        let sut = EmpSegmentControl.ViewModel(
            common: common,
            segments: ["A", "B", "C"],
            font: .systemFont(ofSize: 15, weight: .bold),
            selectedSegmentTintColor: .blue
        )

        #expect(sut.common == common)
        #expect(sut.segments == ["A", "B", "C"])
        #expect(sut.font == .systemFont(ofSize: 15, weight: .bold))
        #expect(sut.selectedSegmentTintColor == .blue)
    }

    @Test("Дефолтные значения")
    func defaultValues() {
        let sut = EmpSegmentControl.ViewModel(segments: ["Day", "Week"])

        #expect(sut.common == CommonViewModel())
        #expect(sut.segments == ["Day", "Week"])
        #expect(sut.font == .systemFont(ofSize: 13, weight: .medium))
        #expect(sut.selectedSegmentTintColor == nil)
    }
}

// MARK: - Preset

@Suite("EmpSegmentControl.Preset")
struct EmpSegmentControlPresetTests {
    @Test("default — задаёт только layoutMargins")
    func defaultPreset() {
        let sut = EmpSegmentControl.Preset.default(segments: ["Day", "Week"])

        #expect(sut.segments == ["Day", "Week"])
        #expect(sut.common.corners.radius == 0)
        #expect(sut.common.backgroundColor == .clear)
        #expect(sut.common.layoutMargins == UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        #expect(sut.selectedSegmentTintColor == nil)
    }
}

// MARK: - Selection

@Suite("EmpSegmentControl — Selection")
struct EmpSegmentControlSelectionTests {
    @Test("Начальный selectedIndex равен 0")
    @MainActor
    func initialSelectedIndex() {
        let control = EmpSegmentControl()
        control.configure(with: .init(segments: ["A", "B"]))

        #expect(control.selectedIndex == 0)
    }

    @Test("select(index:) меняет selectedIndex")
    @MainActor
    func selectChangesIndex() {
        let control = EmpSegmentControl()
        control.configure(with: .init(segments: ["A", "B", "C"]))
        control.select(index: 2)

        #expect(control.selectedIndex == 2)
    }

    @Test("select(index:) игнорирует невалидный индекс")
    @MainActor
    func selectIgnoresInvalidIndex() {
        let control = EmpSegmentControl()
        control.configure(with: .init(segments: ["A", "B"]))
        control.select(index: 5)

        #expect(control.selectedIndex == 0)
    }

    @Test("select(index:) игнорирует текущий индекс")
    @MainActor
    func selectIgnoresSameIndex() {
        let control = EmpSegmentControl()
        control.configure(with: .init(segments: ["A", "B"]))
        control.select(index: 0)

        #expect(control.selectedIndex == 0)
    }
}
