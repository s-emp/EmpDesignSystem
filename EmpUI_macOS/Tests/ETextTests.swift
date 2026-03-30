import AppKit
import Testing
@testable import EmpUI_macOS

// MARK: - PlainText

@Suite("EText.Content.PlainText")
struct ETextPlainTextTests {
    @Test("Сохраняет все поля")
    func storesFields() {
        let font = NSFont.systemFont(ofSize: 20, weight: .bold)
        let color = NSColor.Semantic.textAccent
        let sut = EText.Content.PlainText(text: "Hello", font: font, color: color)

        #expect(sut.text == "Hello")
        #expect(sut.font == font)
        #expect(sut.color == color)
    }

    @Test("Дефолтные значения — preferredFont body, textPrimary")
    func defaultValues() {
        let sut = EText.Content.PlainText(text: "Test")

        #expect(sut.text == "Test")
        #expect(sut.font == .preferredFont(forTextStyle: .body))
        #expect(sut.color == NSColor.Semantic.textPrimary)
    }
}

// MARK: - ViewModel

@Suite("EText.ViewModel")
struct ETextViewModelTests {
    @Test("Сохраняет все поля")
    func storesFields() {
        let common = CommonViewModel(backgroundColor: .red)
        let content = EText.Content.plain(.init(text: "Hello"))
        let sut = EText.ViewModel(
            common: common,
            content: content,
            numberOfLines: 2,
            alignment: .center
        )

        #expect(sut.common == common)
        #expect(sut.numberOfLines == 2)
        #expect(sut.alignment == .center)
    }

    @Test("Дефолтные значения — numberOfLines 0, alignment natural")
    func defaultValues() {
        let sut = EText.ViewModel(content: .plain(.init(text: "Test")))

        #expect(sut.common == CommonViewModel())
        #expect(sut.numberOfLines == 0)
        #expect(sut.alignment == .natural)
    }

    @Test("Контент plain сохраняет PlainText")
    func plainContent() {
        let plain = EText.Content.PlainText(text: "Hello", font: .boldSystemFont(ofSize: 16), color: .red)
        let content = EText.Content.plain(plain)
        let sut = EText.ViewModel(content: content)

        if case let .plain(stored) = sut.content {
            #expect(stored.text == "Hello")
            #expect(stored.font == .boldSystemFont(ofSize: 16))
            #expect(stored.color == .red)
        } else {
            Issue.record("Ожидался .plain, получен .attributed")
        }
    }

    @Test("Контент attributed сохраняет NSAttributedString")
    func attributedContent() {
        let attributed = NSAttributedString(string: "Styled", attributes: [
            .font: NSFont.systemFont(ofSize: 18),
        ])
        let sut = EText.ViewModel(content: .attributed(attributed))

        if case let .attributed(stored) = sut.content {
            #expect(stored.string == "Styled")
        } else {
            Issue.record("Ожидался .attributed, получен .plain")
        }
    }
}
