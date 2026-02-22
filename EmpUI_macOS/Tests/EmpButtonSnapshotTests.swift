import AppKit
import SnapshotTesting
import Testing
@testable import EmpUI_macOS

// MARK: - Test Config

enum ButtonStyle: String, CaseIterable, Sendable {
    case filled, base, outlined, ghost
}

enum ButtonColor: String, CaseIterable, Sendable {
    case primary, danger

    // MARK: Internal

    var preset: EmpButton.Preset.ColorVariant {
        switch self {
        case .primary:
            .primary
        case .danger:
            .danger
        }
    }
}

enum ButtonSize: String, CaseIterable, Sendable {
    case small, medium, large

    // MARK: Internal

    var preset: EmpButton.Preset.Size {
        switch self {
        case .small:
            .small
        case .medium:
            .medium
        case .large:
            .large
        }
    }
}

struct PresetCase: Sendable, CustomTestStringConvertible {
    let style: ButtonStyle
    let color: ButtonColor
    let size: ButtonSize

    var testDescription: String {
        "\(style.rawValue)-\(color.rawValue)-\(size.rawValue)"
    }

    func makeViewModel() -> EmpButton.ViewModel {
        let layout = EmpButton.Preset.ContentLayout(center: .text("Button"))
        switch style {
        case .filled:
            return EmpButton.Preset.filled(color.preset, content: layout, size: size.preset)
        case .base:
            return EmpButton.Preset.base(color.preset, content: layout, size: size.preset)
        case .outlined:
            return EmpButton.Preset.outlined(color.preset, content: layout, size: size.preset)
        case .ghost:
            return EmpButton.Preset.ghost(color.preset, content: layout, size: size.preset)
        }
    }

    static let all: [PresetCase] = ButtonStyle.allCases.flatMap { style in
        ButtonColor.allCases.flatMap { color in
            ButtonSize.allCases.map { size in
                PresetCase(style: style, color: color, size: size)
            }
        }
    }
}

// MARK: - Tests

@Suite("EmpButton — Snapshots")
struct EmpButtonSnapshotTests {
    @Test("Пресеты", arguments: PresetCase.all)
    @MainActor
    func preset(_ config: PresetCase) {
        let viewModel = config.makeViewModel()
        let button = EmpButton()
        button.configure(with: viewModel)
        assertSnapshot(
            of: button,
            as: .image(size: CGSize(width: 200, height: viewModel.height)),
            named: config.testDescription
        )
    }

    @Test("Иконка + текст")
    @MainActor
    func iconAndText() throws {
        let icon = try #require(NSImage(systemSymbolName: "lock.fill", accessibilityDescription: nil))
        let viewModel = EmpButton.Preset.filled(.primary, content: .init(
            leading: .icon(icon),
            center: .text("Sign In")
        ))
        let button = EmpButton()
        button.configure(with: viewModel)
        assertSnapshot(of: button, as: .image(size: CGSize(width: 200, height: viewModel.height)))
    }

    @Test("Текст + иконка")
    @MainActor
    func textAndIcon() throws {
        let icon = try #require(NSImage(systemSymbolName: "arrow.right", accessibilityDescription: nil))
        let viewModel = EmpButton.Preset.filled(.primary, content: .init(
            center: .text("Next"),
            trailing: .icon(icon)
        ))
        let button = EmpButton()
        button.configure(with: viewModel)
        assertSnapshot(of: button, as: .image(size: CGSize(width: 200, height: viewModel.height)))
    }

    @Test("Только иконка")
    @MainActor
    func iconOnly() throws {
        let icon = try #require(NSImage(systemSymbolName: "plus", accessibilityDescription: nil))
        let viewModel = EmpButton.Preset.filled(.primary, content: .init(center: .icon(icon)))
        let button = EmpButton()
        button.configure(with: viewModel)
        assertSnapshot(of: button, as: .image(size: CGSize(width: 60, height: viewModel.height)))
    }

    @Test("Disabled")
    @MainActor
    func disabled() {
        let viewModel = EmpButton.Preset.filled(.primary, content: .init(center: .text("Disabled")))
        let button = EmpButton()
        button.configure(with: viewModel)
        button.isEnabled = false
        assertSnapshot(of: button, as: .image(size: CGSize(width: 200, height: viewModel.height)))
    }
}
