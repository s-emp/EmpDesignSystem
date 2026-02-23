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
            center: .text(EmpText.ViewModel(
                content: .plain(.init(text: "Test", font: .systemFont(ofSize: 13), color: .white))
            ))
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
        let viewModel = EmpImage.ViewModel(image: image, tintColor: .red, size: CGSize(width: 16, height: 16))
        let element = EmpButton.Content.Element.icon(viewModel)

        if case let .icon(vm) = element {
            #expect(vm.tintColor == .red)
            #expect(vm.size == CGSize(width: 16, height: 16))
        } else {
            Issue.record("Должен быть .icon")
        }
    }

    @Test("Element.text сохраняет параметры")
    func textElement() {
        let font = NSFont.systemFont(ofSize: 14)
        let viewModel = EmpText.ViewModel(
            content: .plain(.init(text: "Hello", font: font, color: .blue))
        )
        let element = EmpButton.Content.Element.text(viewModel)

        if case let .text(vm) = element {
            if case let .plain(plain) = vm.content {
                #expect(plain.text == "Hello")
                #expect(plain.color == .blue)
                #expect(plain.font == font)
            } else {
                Issue.record("Должен быть .plain")
            }
        } else {
            Issue.record("Должен быть .text")
        }
    }

    @Test("Element.titleSubtitle сохраняет параметры")
    func titleSubtitleElement() {
        let titleVM = EmpText.ViewModel(
            content: .plain(.init(text: "Title", font: .systemFont(ofSize: 13), color: .white))
        )
        let subtitleVM = EmpText.ViewModel(
            content: .plain(.init(text: "Sub", font: .systemFont(ofSize: 11), color: .gray))
        )
        let element = EmpButton.Content.Element.titleSubtitle(title: titleVM, subtitle: subtitleVM)

        if case let .titleSubtitle(title, subtitle) = element {
            if case let .plain(titlePlain) = title.content {
                #expect(titlePlain.text == "Title")
                #expect(titlePlain.color == .white)
            }
            if case let .plain(subtitlePlain) = subtitle.content {
                #expect(subtitlePlain.text == "Sub")
                #expect(subtitlePlain.color == .gray)
            }
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

        if case let .text(vm) = sut.content.normal.center,
           case let .plain(plain) = vm.content {
            #expect(plain.color == NSColor.Semantic.textPrimaryInverted)
        }
    }

    @Test("base — задаёт нейтральный фон и primary текст")
    func basePreset() {
        let sut = EmpButton.Preset.base(.primary, content: layout)

        #expect(sut.common.normal.backgroundColor == NSColor.Semantic.actionPrimaryBase)
        #expect(sut.common.hover.backgroundColor == NSColor.Semantic.actionPrimaryBaseHover)

        if case let .text(vm) = sut.content.normal.center,
           case let .plain(plain) = vm.content {
            #expect(plain.color == NSColor.Semantic.textPrimary)
        }
    }

    @Test("outlined — задаёт border и текст цвета action")
    func outlinedPreset() {
        let sut = EmpButton.Preset.outlined(.primary, content: layout)

        #expect(sut.common.normal.border.width == 1)
        #expect(sut.common.normal.border.color == NSColor.Semantic.actionPrimary)
        #expect(sut.common.normal.backgroundColor == .clear)
        #expect(sut.common.hover.backgroundColor == NSColor.Semantic.actionPrimaryTint)

        if case let .text(vm) = sut.content.normal.center,
           case let .plain(plain) = vm.content {
            #expect(plain.color == NSColor.Semantic.actionPrimary)
        }
    }

    @Test("ghost — без фона и border, текст primary")
    func ghostPreset() {
        let sut = EmpButton.Preset.ghost(.primary, content: layout)

        #expect(sut.common.normal.backgroundColor == .clear)
        #expect(sut.common.normal.border.width == 0)
        #expect(sut.common.hover.backgroundColor == NSColor.Semantic.actionPrimaryTint)

        if case let .text(vm) = sut.content.normal.center,
           case let .plain(plain) = vm.content {
            #expect(plain.color == NSColor.Semantic.textPrimary)
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

        if case let .text(vm) = sut.content.normal.center,
           case let .plain(plain) = vm.content {
            #expect(plain.color == NSColor.Semantic.actionDanger)
        }
    }

    @Test("danger — outlined использует danger цвета")
    func dangerOutlined() {
        let sut = EmpButton.Preset.outlined(.danger, content: layout)

        #expect(sut.common.normal.border.color == NSColor.Semantic.actionDanger)

        if case let .text(vm) = sut.content.normal.center,
           case let .plain(plain) = vm.content {
            #expect(plain.color == NSColor.Semantic.actionDanger)
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

        if case let .icon(vm) = sut.content.normal.leading {
            #expect(vm.size == CGSize(width: 16, height: 16))
        }
        if case let .text(vm) = sut.content.normal.center,
           case let .plain(plain) = vm.content {
            #expect(plain.font == .systemFont(ofSize: 14, weight: .semibold))
        }
    }
}
