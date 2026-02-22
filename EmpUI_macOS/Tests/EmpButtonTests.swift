import AppKit
import Testing
@testable import EmpUI_macOS

// MARK: - ViewModel

@Suite("EmpButton.ViewModel")
struct EmpButtonViewModelTests {
    @Test("ViewModel сохраняет все поля")
    func storesFields() {
        let common = ControlParameter(normal: CommonViewModel())
        let content = ControlParameter(normal: EmpButton.Content(
            center: .text("Test", color: .white, font: .systemFont(ofSize: 13))
        ))

        let sut = EmpButton.ViewModel(
            common: common,
            content: content,
            height: 32,
            spacing: 8
        )

        #expect(sut.height == 32)
        #expect(sut.spacing == 8)
        #expect(sut.common.normal == CommonViewModel())
    }
}

// MARK: - Content

@Suite("EmpButton.Content")
struct EmpButtonContentTests {
    @Test("Дефолтные значения Content — все nil")
    func defaultNils() {
        let sut = EmpButton.Content()

        #expect(sut.leading == nil)
        #expect(sut.center == nil)
        #expect(sut.trailing == nil)
    }

    @Test("Element.icon сохраняет параметры")
    func iconElement() throws {
        let image = try #require(NSImage(systemSymbolName: "star", accessibilityDescription: nil))
        let element = EmpButton.Content.Element.icon(image, color: .red, size: 16)

        if case let .icon(_, color, size) = element {
            #expect(color == .red)
            #expect(size == 16)
        } else {
            Issue.record("Должен быть .icon")
        }
    }

    @Test("Element.text сохраняет параметры")
    func textElement() {
        let font = NSFont.systemFont(ofSize: 14)
        let element = EmpButton.Content.Element.text("Hello", color: .blue, font: font)

        if case let .text(string, color, f) = element {
            #expect(string == "Hello")
            #expect(color == .blue)
            #expect(f == font)
        } else {
            Issue.record("Должен быть .text")
        }
    }

    @Test("Element.titleSubtitle сохраняет параметры")
    func titleSubtitleElement() {
        let element = EmpButton.Content.Element.titleSubtitle(
            title: "Title",
            subtitle: "Sub",
            titleColor: .white,
            subtitleColor: .gray,
            titleFont: .systemFont(ofSize: 13),
            subtitleFont: .systemFont(ofSize: 11)
        )

        if case let .titleSubtitle(title, subtitle, tc, sc, _, _) = element {
            #expect(title == "Title")
            #expect(subtitle == "Sub")
            #expect(tc == .white)
            #expect(sc == .gray)
        } else {
            Issue.record("Должен быть .titleSubtitle")
        }
    }
}

// MARK: - Preset

@Suite("EmpButton.Preset")
struct EmpButtonPresetTests {
    private let layout = EmpButton.Preset.ContentLayout(center: .text("Test"))

    @Test("filled — задаёт backgroundColor и inverted текст")
    func filledPreset() {
        let sut = EmpButton.Preset.filled(.primary, content: layout)

        #expect(sut.common.normal.backgroundColor == NSColor.Semantic.actionPrimary)
        #expect(sut.common.hover.backgroundColor == NSColor.Semantic.actionPrimaryHover)

        if case let .text(_, color, _) = sut.content.normal.center {
            #expect(color == NSColor.Semantic.textPrimaryInverted)
        }
    }

    @Test("base — задаёт нейтральный фон и primary текст")
    func basePreset() {
        let sut = EmpButton.Preset.base(.primary, content: layout)

        #expect(sut.common.normal.backgroundColor == NSColor.Semantic.actionPrimaryBase)
        #expect(sut.common.hover.backgroundColor == NSColor.Semantic.actionPrimaryBaseHover)

        if case let .text(_, color, _) = sut.content.normal.center {
            #expect(color == NSColor.Semantic.textPrimary)
        }
    }

    @Test("outlined — задаёт border и текст цвета action")
    func outlinedPreset() {
        let sut = EmpButton.Preset.outlined(.primary, content: layout)

        #expect(sut.common.normal.border.width == 1)
        #expect(sut.common.normal.border.color == NSColor.Semantic.actionPrimary)
        #expect(sut.common.normal.backgroundColor == .clear)
        #expect(sut.common.hover.backgroundColor == NSColor.Semantic.actionPrimaryTint)

        if case let .text(_, color, _) = sut.content.normal.center {
            #expect(color == NSColor.Semantic.actionPrimary)
        }
    }

    @Test("ghost — без фона и border, текст primary")
    func ghostPreset() {
        let sut = EmpButton.Preset.ghost(.primary, content: layout)

        #expect(sut.common.normal.backgroundColor == .clear)
        #expect(sut.common.normal.border.width == 0)
        #expect(sut.common.hover.backgroundColor == NSColor.Semantic.actionPrimaryTint)

        if case let .text(_, color, _) = sut.content.normal.center {
            #expect(color == NSColor.Semantic.textPrimary)
        }
    }

    @Test("danger — filled использует danger цвета")
    func dangerFilled() {
        let sut = EmpButton.Preset.filled(.danger, content: layout)

        #expect(sut.common.normal.backgroundColor == NSColor.Semantic.actionDanger)
        #expect(sut.common.hover.backgroundColor == NSColor.Semantic.actionDangerHover)
    }

    @Test("danger — base использует danger цвета")
    func dangerBase() {
        let sut = EmpButton.Preset.base(.danger, content: layout)

        #expect(sut.common.normal.backgroundColor == NSColor.Semantic.actionDangerBase)

        if case let .text(_, color, _) = sut.content.normal.center {
            #expect(color == NSColor.Semantic.actionDanger)
        }
    }

    @Test("danger — outlined использует danger цвета")
    func dangerOutlined() {
        let sut = EmpButton.Preset.outlined(.danger, content: layout)

        #expect(sut.common.normal.border.color == NSColor.Semantic.actionDanger)

        if case let .text(_, color, _) = sut.content.normal.center {
            #expect(color == NSColor.Semantic.actionDanger)
        }
    }

    @Test("size small — height 24")
    func sizeSmall() {
        let sut = EmpButton.Preset.filled(.primary, content: layout, size: .small)
        #expect(sut.height == 24)
    }

    @Test("size medium — height 32")
    func sizeMedium() {
        let sut = EmpButton.Preset.filled(.primary, content: layout)
        #expect(sut.height == 32)
    }

    @Test("size large — height 40")
    func sizeLarge() {
        let sut = EmpButton.Preset.filled(.primary, content: layout, size: .large)
        #expect(sut.height == 40)
    }

    @Test("Preset применяет шрифт и iconSize из SizeConfig")
    func sizeConfigApplied() throws {
        let iconLayout = try EmpButton.Preset.ContentLayout(
            leading: .icon(#require(NSImage(systemSymbolName: "star", accessibilityDescription: nil))),
            center: .text("Label")
        )
        let sut = EmpButton.Preset.filled(.primary, content: iconLayout, size: .large)

        if case let .icon(_, _, size) = sut.content.normal.leading {
            #expect(size == 16)
        }
        if case let .text(_, _, font) = sut.content.normal.center {
            #expect(font == .systemFont(ofSize: 14, weight: .semibold))
        }
    }
}
