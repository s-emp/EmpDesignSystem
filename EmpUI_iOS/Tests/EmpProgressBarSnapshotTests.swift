import SnapshotTesting
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("EmpProgressBar — Snapshots")
struct EmpProgressBarSnapshotTests {
    @Test("Прогресс 0%")
    @MainActor
    func progress0() {
        let view = EmpProgressBar()
        view.configure(with: .init(progress: 0))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 20)))
    }

    @Test("Прогресс 25%")
    @MainActor
    func progress25() {
        let view = EmpProgressBar()
        view.configure(with: .init(progress: 0.25))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 20)))
    }

    @Test("Прогресс 50%")
    @MainActor
    func progress50() {
        let view = EmpProgressBar()
        view.configure(with: .init(progress: 0.5))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 20)))
    }

    @Test("Прогресс 75%")
    @MainActor
    func progress75() {
        let view = EmpProgressBar()
        view.configure(with: .init(progress: 0.75))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 20)))
    }

    @Test("Прогресс 100%")
    @MainActor
    func progress100() {
        let view = EmpProgressBar()
        view.configure(with: .init(progress: 1.0))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 20)))
    }

    @Test("Толстая полоса (barHeight 12)")
    @MainActor
    func thickBar() {
        let view = EmpProgressBar()
        view.configure(with: .init(progress: 0.6, barHeight: 12))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 28)))
    }

    @Test("Кастомные цвета — success")
    @MainActor
    func customColorSuccess() {
        let view = EmpProgressBar()
        view.configure(with: .init(
            progress: 0.7,
            fillColor: UIColor.Semantic.actionSuccess,
            barHeight: 8
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 24)))
    }

    @Test("Кастомные цвета — danger")
    @MainActor
    func customColorDanger() {
        let view = EmpProgressBar()
        view.configure(with: .init(
            progress: 0.9,
            fillColor: UIColor.Semantic.actionDanger,
            barHeight: 6
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 22)))
    }

    @Test("С отступами через CommonViewModel")
    @MainActor
    func withMargins() {
        let view = EmpProgressBar()
        let common = CommonViewModel(
            layoutMargins: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        )
        view.configure(with: .init(
            common: common,
            progress: 0.5,
            barHeight: 6
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 22)))
    }
}
