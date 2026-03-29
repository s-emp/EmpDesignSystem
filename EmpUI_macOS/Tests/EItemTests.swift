import Testing
import AppKit
@testable import EmpUI_macOS

@Suite("EItem")
struct EItemTests {

    @Test("Hashable — одинаковый id, одинаковый hash")
    func hashableById() {
        let a = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        let b = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "B")))))
        #expect(a.hashValue == b.hashValue)
    }

    @Test("Equatable — одинаковый id + одинаковые данные → равны")
    func equalSameIdSameData() {
        let a = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        let b = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        #expect(a == b)
    }

    @Test("Equatable — одинаковый id + разные данные → не равны")
    func notEqualSameIdDifferentData() {
        let a = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        let b = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "B")))))
        #expect(a != b)
    }

    @Test("Equatable — разный id → не равны")
    func notEqualDifferentId() {
        let a = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        let b = EItem(id: "2", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        #expect(a != b)
    }
}
