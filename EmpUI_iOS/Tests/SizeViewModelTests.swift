@testable import EmpUI_iOS
import UIKit
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

    @Test("fixed width constraint имеет идентификатор 'EDS.fixed.width'")
    @MainActor
    func fixedWidthConstraintIdentifier() {
        let view = UIView()
        view.apply(common: CommonViewModel(size: .init(width: .fixed(100))))

        let constraint = view.constraints.first(where: {
            $0.firstAttribute == .width && $0.secondItem == nil
        })
        #expect(constraint?.identifier == "EDS.fixed.width")
    }

    @Test("fixed height constraint имеет идентификатор 'EDS.fixed.height'")
    @MainActor
    func fixedHeightConstraintIdentifier() {
        let view = UIView()
        view.apply(common: CommonViewModel(size: .init(height: .fixed(50))))

        let constraint = view.constraints.first(where: {
            $0.firstAttribute == .height && $0.secondItem == nil
        })
        #expect(constraint?.identifier == "EDS.fixed.height")
    }
}
