import AppKit
import SnapshotTesting
import Testing
@testable import EmpUI_macOS

@Suite("EmpText — Snapshots")
struct EmpTextSnapshotTests {
    @Test("Plain текст — дефолтный стиль")
    @MainActor
    func plainDefault() {
        let view = EmpText()
        view.configure(with: .init(content: .plain(.init(text: "Hello, World!"))))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 30)))
    }

    @Test("Plain текст — жирный заголовок")
    @MainActor
    func plainBoldTitle() {
        let view = EmpText()
        view.configure(with: .init(
            content: .plain(.init(
                text: "Bold Title",
                font: .systemFont(ofSize: 24, weight: .bold),
                color: NSColor.Semantic.textPrimary
            ))
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 40)))
    }

    @Test("Plain текст — вторичный цвет")
    @MainActor
    func plainSecondaryColor() {
        let view = EmpText()
        view.configure(with: .init(
            content: .plain(.init(
                text: "Secondary text",
                color: NSColor.Semantic.textSecondary
            ))
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 30)))
    }

    @Test("Plain текст — акцентный цвет")
    @MainActor
    func plainAccentColor() {
        let view = EmpText()
        view.configure(with: .init(
            content: .plain(.init(
                text: "Accent text",
                color: NSColor.Semantic.textAccent
            ))
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 30)))
    }

    @Test("Многострочный текст")
    @MainActor
    func multiline() {
        let view = EmpText()
        view.configure(with: .init(
            content: .plain(.init(
                text: "This is a longer text that should wrap onto multiple lines within the view."
            )),
            numberOfLines: 0
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 80)))
    }

    @Test("Однострочный текст — обрезка")
    @MainActor
    func singleLine() {
        let view = EmpText()
        view.configure(with: .init(
            content: .plain(.init(text: "This is a long text that should be truncated on a single line.")),
            numberOfLines: 1
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 30)))
    }

    @Test("Выравнивание по центру")
    @MainActor
    func centerAligned() {
        let view = EmpText()
        view.configure(with: .init(
            content: .plain(.init(text: "Centered")),
            alignment: .center
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 30)))
    }

    @Test("Выравнивание по правому краю")
    @MainActor
    func rightAligned() {
        let view = EmpText()
        view.configure(with: .init(
            content: .plain(.init(text: "Right")),
            alignment: .right
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 30)))
    }

    @Test("Attributed текст")
    @MainActor
    func attributed() {
        let view = EmpText()
        let attributed = NSAttributedString(
            string: "Attributed Text",
            attributes: [
                .font: NSFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: NSColor.Semantic.textAccent,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ]
        )
        view.configure(with: .init(content: .attributed(attributed)))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 35)))
    }

    @Test("С фоном и отступами")
    @MainActor
    func withBackgroundAndMargins() {
        let view = EmpText()
        let common = CommonViewModel(
            corners: .init(radius: 8),
            backgroundColor: NSColor.Semantic.backgroundSecondary,
            layoutMargins: NSEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        )
        view.configure(with: .init(
            common: common,
            content: .plain(.init(text: "With background"))
        ))
        assertSnapshot(of: view, as: .image(size: CGSize(width: 200, height: 40)))
    }
}
