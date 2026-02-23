import AppKit
import SnapshotTesting
import Testing
@testable import EmpUI_macOS

private let snapshotSize = CGSize(width: 200, height: 90)

@Suite("EmpInfoCard — Snapshots")
struct EmpInfoCardSnapshotTests {
    private var cardCommon: CommonViewModel {
        CommonViewModel(
            corners: .init(radius: 12),
            layoutMargins: NSEdgeInsets(
                top: EmpSpacing.m.rawValue,
                left: EmpSpacing.m.rawValue,
                bottom: EmpSpacing.m.rawValue,
                right: EmpSpacing.m.rawValue
            )
        )
    }

    @Test("Дефолтная карточка")
    @MainActor
    func defaultCard() {
        let view = EmpInfoCard()
        view.configure(with: .init(
            common: cardCommon,
            subtitle: "Total Time",
            value: "12h 15m"
        ))
        assertSnapshot(of: view, as: .image(size: snapshotSize))
    }

    @Test("Карточка с цветным фоном")
    @MainActor
    func colorBackground() {
        let view = EmpInfoCard()
        view.configure(with: .init(
            common: cardCommon,
            subtitle: "Active Time",
            value: "8h 34m",
            background: .color(NSColor.Semantic.cardLavender)
        ))
        assertSnapshot(of: view, as: .image(size: snapshotSize))
    }

    @Test("Карточка с градиентом")
    @MainActor
    func gradientBackground() {
        let view = EmpInfoCard()
        view.configure(with: .init(
            common: cardCommon,
            subtitle: "Longest Session",
            value: "1h 47m",
            subtitleColor: .white.withAlphaComponent(0.7),
            valueColor: .white,
            background: .gradient(EmpGradient.Preset.lavenderToSky)
        ))
        assertSnapshot(of: view, as: .image(size: snapshotSize))
    }

    @Test("Короткое значение")
    @MainActor
    func shortValue() {
        let view = EmpInfoCard()
        view.configure(with: .init(
            common: cardCommon,
            subtitle: "Apps Used",
            value: "10"
        ))
        assertSnapshot(of: view, as: .image(size: snapshotSize))
    }

    @Test("Кастомные шрифты и цвета")
    @MainActor
    func customFontsAndColors() {
        let view = EmpInfoCard()
        view.configure(with: .init(
            common: cardCommon,
            subtitle: "Revenue",
            value: "$1,234",
            subtitleColor: NSColor.Semantic.textTertiary,
            subtitleFont: .systemFont(ofSize: 9, weight: .regular),
            valueColor: NSColor.Semantic.actionPrimary,
            valueFont: .systemFont(ofSize: 32, weight: .heavy)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 100)))
    }

    @Test("Карточка с бордером")
    @MainActor
    func withBorder() {
        let common = CommonViewModel(
            border: .init(width: 1, color: NSColor.Semantic.borderDefault),
            corners: .init(radius: 12),
            layoutMargins: NSEdgeInsets(
                top: EmpSpacing.m.rawValue,
                left: EmpSpacing.m.rawValue,
                bottom: EmpSpacing.m.rawValue,
                right: EmpSpacing.m.rawValue
            )
        )
        let view = EmpInfoCard()
        view.configure(with: .init(
            common: common,
            subtitle: "Sessions",
            value: "42",
            background: .color(.clear)
        ))
        assertSnapshot(of: view, as: .image(size: snapshotSize))
    }
}
