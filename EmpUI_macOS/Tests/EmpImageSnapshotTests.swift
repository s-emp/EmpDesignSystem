import AppKit
import SnapshotTesting
import Testing
@testable import EmpUI_macOS

@Suite("EmpImage — Snapshots")
struct EmpImageSnapshotTests {
    // MARK: - SF Symbol с tintColor

    @Test("SF Symbol — actionPrimary")
    @MainActor
    func sfSymbolPrimary() throws {
        let icon = try #require(NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            image: icon,
            tintColor: NSColor.Semantic.actionPrimary,
            size: CGSize(width: 24, height: 24)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 24, height: 24)))
    }

    @Test("SF Symbol — actionDanger")
    @MainActor
    func sfSymbolDanger() throws {
        let icon = try #require(NSImage(systemSymbolName: "heart.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            image: icon,
            tintColor: NSColor.Semantic.actionDanger,
            size: CGSize(width: 24, height: 24)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 24, height: 24)))
    }

    @Test("SF Symbol — actionSuccess")
    @MainActor
    func sfSymbolSuccess() throws {
        let icon = try #require(NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            image: icon,
            tintColor: NSColor.Semantic.actionSuccess,
            size: CGSize(width: 24, height: 24)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 24, height: 24)))
    }

    // MARK: - SF Symbol без tintColor

    @Test("SF Symbol — без tintColor")
    @MainActor
    func sfSymbolNoTint() throws {
        let icon = try #require(NSImage(systemSymbolName: "globe", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            image: icon,
            size: CGSize(width: 32, height: 32)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 32, height: 32)))
    }

    // MARK: - Размеры

    @Test("SF Symbol — маленький (16x16)")
    @MainActor
    func smallSize() throws {
        let icon = try #require(NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            image: icon,
            tintColor: NSColor.Semantic.actionPrimary,
            size: CGSize(width: 16, height: 16)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 16, height: 16)))
    }

    @Test("SF Symbol — большой (48x48)")
    @MainActor
    func largeSize() throws {
        let icon = try #require(NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            image: icon,
            tintColor: NSColor.Semantic.actionPrimary,
            size: CGSize(width: 48, height: 48)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 48, height: 48)))
    }

    // MARK: - ContentMode

    @Test("ContentMode — center")
    @MainActor
    func contentModeCenter() throws {
        let icon = try #require(NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            image: icon,
            tintColor: NSColor.Semantic.actionPrimary,
            size: CGSize(width: 40, height: 40),
            contentMode: .center
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 40, height: 40)))
    }

    @Test("ContentMode — aspectFit")
    @MainActor
    func contentModeAspectFit() throws {
        let icon = try #require(NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            image: icon,
            tintColor: NSColor.Semantic.actionPrimary,
            size: CGSize(width: 40, height: 40),
            contentMode: .aspectFit
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 40, height: 40)))
    }

    // MARK: - С CommonViewModel

    @Test("С border и padding")
    @MainActor
    func withCommonStyling() throws {
        let icon = try #require(NSImage(systemSymbolName: "person.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            common: CommonViewModel(
                border: .init(width: 1, color: NSColor.Semantic.borderDefault),
                corners: .init(radius: 8),
                backgroundColor: NSColor.Semantic.backgroundSecondary,
                layoutMargins: NSEdgeInsets(top: .xs, left: .xs, bottom: .xs, right: .xs)
            ),
            image: icon,
            tintColor: NSColor.Semantic.textPrimary,
            size: CGSize(width: 32, height: 32)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 48, height: 48)))
    }

    @Test("С круглой формой")
    @MainActor
    func circularShape() throws {
        let icon = try #require(NSImage(systemSymbolName: "person.fill", accessibilityDescription: nil))
        let view = EmpImage()
        view.configure(with: .init(
            common: CommonViewModel(
                corners: .init(radius: 24),
                backgroundColor: NSColor.Semantic.backgroundSecondary,
                layoutMargins: NSEdgeInsets(top: .xs, left: .xs, bottom: .xs, right: .xs)
            ),
            image: icon,
            tintColor: NSColor.Semantic.textSecondary,
            size: CGSize(width: 32, height: 32)
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 48, height: 48)))
    }
}
