import AppKit
import Testing
@testable import EmpUI_macOS

@Suite("CommonViewModel")
struct CommonViewModelTests {

    @Test("Дефолтные значения совпадают с эталоном")
    func defaultInitializer() {
        let expected = CommonViewModel(
            border: .init(width: 0, color: .clear, style: .solid),
            shadow: .init(color: .clear, offset: .zero, radius: 0, opacity: 0),
            corners: .init(radius: 0, maskedCorners: [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner
            ]),
            backgroundColor: .clear,
            layoutMargins: NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        let sut = CommonViewModel()
        #expect(sut == expected)
    }
}
