import AppKit
import Testing
@testable import EmpUI_macOS

// MARK: - ViewModel

@Suite("ESegmentControl.ViewModel")
struct ESegmentControlViewModelTests {
    @Test("Сохраняет все поля")
    func storesFields() {
        let common = CommonViewModel(backgroundColor: .red)
        let sut = ESegmentControl.ViewModel(
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
        let sut = ESegmentControl.ViewModel(segments: ["Day", "Week"])

        #expect(sut.common == CommonViewModel())
        #expect(sut.segments == ["Day", "Week"])
        #expect(sut.font == .systemFont(ofSize: 13, weight: .medium))
        #expect(sut.selectedSegmentTintColor == nil)
    }
}

// MARK: - Preset

@Suite("ESegmentControl.Preset")
struct ESegmentControlPresetTests {
    @Test("default — задаёт только layoutMargins")
    func defaultPreset() {
        let sut = ESegmentControl.Preset.default(segments: ["Day", "Week"])

        #expect(sut.segments == ["Day", "Week"])
        #expect(sut.common.corners.radius == 0)
        #expect(sut.common.backgroundColor == .clear)
        #expect(sut.common.layoutMargins == NSEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        #expect(sut.selectedSegmentTintColor == nil)
    }
}

// MARK: - Selection

@Suite("ESegmentControl — Selection")
struct ESegmentControlSelectionTests {
    @Test("Начальный selectedIndex равен 0")
    @MainActor
    func initialSelectedIndex() {
        let control = ESegmentControl()
        control.configure(with: .init(segments: ["A", "B"]))

        #expect(control.selectedIndex == 0)
    }

    @Test("select(index:) меняет selectedIndex")
    @MainActor
    func selectChangesIndex() {
        let control = ESegmentControl()
        control.configure(with: .init(segments: ["A", "B", "C"]))
        control.select(index: 2)

        #expect(control.selectedIndex == 2)
    }

    @Test("select(index:) игнорирует невалидный индекс")
    @MainActor
    func selectIgnoresInvalidIndex() {
        let control = ESegmentControl()
        control.configure(with: .init(segments: ["A", "B"]))
        control.select(index: 5)

        #expect(control.selectedIndex == 0)
    }

    @Test("select(index:) игнорирует текущий индекс")
    @MainActor
    func selectIgnoresSameIndex() {
        let control = ESegmentControl()
        control.configure(with: .init(segments: ["A", "B"]))
        control.select(index: 0)

        #expect(control.selectedIndex == 0)
    }
}
