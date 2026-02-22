import Testing
@testable import EmpUI_macOS

@Suite("ControlParameter")
struct ControlParameterTests {
    @Test("Инициализация только с normal — все состояния равны normal")
    func normalOnly() {
        let sut = ControlParameter(normal: 42)

        #expect(sut.normal == 42)
        #expect(sut.hover == 42)
        #expect(sut.highlighted == 42)
        #expect(sut.disabled == 42)
    }

    @Test("Кастомные значения для каждого состояния")
    func customStates() {
        let sut = ControlParameter(normal: 1, hover: 2, highlighted: 3, disabled: 4)

        #expect(sut.normal == 1)
        #expect(sut.hover == 2)
        #expect(sut.highlighted == 3)
        #expect(sut.disabled == 4)
    }

    @Test("Частичная инициализация — незаданные состояния равны normal")
    func partialInit() {
        let sut = ControlParameter(normal: "base", hover: "hovered")

        #expect(sut.normal == "base")
        #expect(sut.hover == "hovered")
        #expect(sut.highlighted == "base")
        #expect(sut.disabled == "base")
    }

    @Test("Доступ по subscript ControlState")
    func subscriptAccess() {
        let sut = ControlParameter(normal: "a", hover: "b", highlighted: "c", disabled: "d")

        #expect(sut[.normal] == "a")
        #expect(sut[.hover] == "b")
        #expect(sut[.highlighted] == "c")
        #expect(sut[.disabled] == "d")
    }

    @Test("Equatable — одинаковые параметры равны")
    func equatable() {
        let a = ControlParameter(normal: 10, hover: 20)
        let b = ControlParameter(normal: 10, hover: 20)

        #expect(a == b)
    }

    @Test("Equatable — разные параметры не равны")
    func notEqual() {
        let a = ControlParameter(normal: 10)
        let b = ControlParameter(normal: 10, hover: 20)

        #expect(a != b)
    }
}
