import AppKit
import SnapshotTesting
import Testing
@testable import EmpUI_macOS

private let snapshotSize = CGSize(width: 200, height: 32)

@Suite("EmpSegmentControl — Snapshots")
struct EmpSegmentControlSnapshotTests {
    @Test("Два сегмента — первый выбран")
    @MainActor
    func twoSegmentsFirstSelected() {
        let view = EmpSegmentControl()
        view.configure(with: EmpSegmentControl.Preset.default(segments: ["Day", "Week"]))
        assertSnapshot(of: view, as: .image(size: snapshotSize))
    }

    @Test("Два сегмента — второй выбран")
    @MainActor
    func twoSegmentsSecondSelected() {
        let view = EmpSegmentControl()
        view.configure(with: EmpSegmentControl.Preset.default(segments: ["Day", "Week"]))
        view.select(index: 1)
        assertSnapshot(of: view, as: .image(size: snapshotSize))
    }

    @Test("Три сегмента — средний выбран")
    @MainActor
    func threeSegmentsMiddleSelected() {
        let view = EmpSegmentControl()
        view.configure(with: EmpSegmentControl.Preset.default(segments: ["Day", "Week", "Month"]))
        view.select(index: 1)
        assertSnapshot(of: view, as: .image(size: CGSize(width: 280, height: 32)))
    }

    @Test("Кастомный цвет выделения")
    @MainActor
    func customTintColor() {
        let view = EmpSegmentControl()
        view.configure(with: .init(
            segments: ["On", "Off"],
            selectedSegmentTintColor: .systemBlue
        ))
        assertSnapshot(of: view, as: .image(size: snapshotSize))
    }
}
