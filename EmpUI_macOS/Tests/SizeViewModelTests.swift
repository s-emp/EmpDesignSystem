@testable import EmpUI_macOS
import Testing

@Suite("SizeViewModel")
struct SizeViewModelTests {

    @Test("Инициализация по умолчанию — hug по обеим осям")
    func defaultInit() {
        let size = SizeViewModel()
        #expect(size.width == .hug)
        #expect(size.height == .hug)
    }

    @Test("Fixed хранит значение")
    func fixedValue() {
        let size = SizeViewModel(width: .fixed(100), height: .fixed(50))
        #expect(size.width == .fixed(100))
        #expect(size.height == .fixed(50))
    }

    @Test("Equatable — одинаковые значения равны")
    func equatable() {
        let a = SizeViewModel(width: .fill, height: .hug)
        let b = SizeViewModel(width: .fill, height: .hug)
        #expect(a == b)
    }

    @Test("Equatable — разные значения не равны")
    func notEqual() {
        let a = SizeViewModel(width: .fill, height: .hug)
        let b = SizeViewModel(width: .hug, height: .hug)
        #expect(a != b)
    }

    @Test("SizeDimension.fixed с разными значениями не равны")
    func fixedNotEqual() {
        #expect(SizeDimension.fixed(10) != SizeDimension.fixed(20))
    }
}
