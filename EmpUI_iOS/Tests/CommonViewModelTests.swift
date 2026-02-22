import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("CommonViewModel")
struct CommonViewModelTests {
    @Test("Дефолтные значения совпадают с эталоном")
    func defaultInitializer() {
        let expected = CommonViewModel(
            border: .init(width: 0, color: .clear, style: .solid),
            shadow: .init(color: .clear, offset: .zero, radius: 0, opacity: 0),
            corners: .init(radius: 0, maskedCorners: [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner,
            ]),
            backgroundColor: .clear,
            layoutMargins: .zero
        )
        let sut = CommonViewModel()
        #expect(sut == expected)
    }
}
