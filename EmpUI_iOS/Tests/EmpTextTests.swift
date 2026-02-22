import Testing
import UIKit
@testable import EmpUI_iOS

// MARK: - PlainText

@Suite("EmpText.Content.PlainText")
struct EmpTextPlainTextTests {
    @Test("Сохраняет все поля")
    func storesFields() {
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let color = UIColor.Semantic.textAccent
        let sut = EmpText.Content.PlainText(text: "Hello", font: font, color: color)

        #expect(sut.text == "Hello")
        #expect(sut.font == font)
        #expect(sut.color == color)
    }

    @Test("Дефолтные значения — systemFont 14, textPrimary")
    func defaultValues() {
        let sut = EmpText.Content.PlainText(text: "Test")

        #expect(sut.text == "Test")
        #expect(sut.font == .systemFont(ofSize: 14))
        #expect(sut.color == UIColor.Semantic.textPrimary)
    }
}

// MARK: - ViewModel

@Suite("EmpText.ViewModel")
struct EmpTextViewModelTests {
    @Test("Сохраняет все поля")
    func storesFields() {
        let common = CommonViewModel(backgroundColor: .red)
        let content = EmpText.Content.plain(.init(text: "Hello"))
        let sut = EmpText.ViewModel(
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
        let sut = EmpText.ViewModel(content: .plain(.init(text: "Test")))

        #expect(sut.common == CommonViewModel())
        #expect(sut.numberOfLines == 0)
        #expect(sut.alignment == .natural)
    }

    @Test("Контент plain сохраняет PlainText")
    func plainContent() {
        let plain = EmpText.Content.PlainText(text: "Hello", font: .boldSystemFont(ofSize: 16), color: .red)
        let content = EmpText.Content.plain(plain)
        let sut = EmpText.ViewModel(content: content)

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
            .font: UIFont.systemFont(ofSize: 18),
        ])
        let sut = EmpText.ViewModel(content: .attributed(attributed))

        if case let .attributed(stored) = sut.content {
            #expect(stored.string == "Styled")
        } else {
            Issue.record("Ожидался .attributed, получен .plain")
        }
    }
}
