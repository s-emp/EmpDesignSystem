import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("EScroll")
@MainActor
struct EScrollTests {
    @Test("vertical — показывает только вертикальный индикатор")
    func verticalShowsOnlyVerticalIndicator() {
        let scroll = EScroll()
        scroll.configure(with: .init(axis: .vertical, showsIndicators: true))
        #expect(scroll.showsVerticalScrollIndicator == true)
        #expect(scroll.showsHorizontalScrollIndicator == false)
    }

    @Test("horizontal — показывает только горизонтальный индикатор")
    func horizontalShowsOnlyHorizontalIndicator() {
        let scroll = EScroll()
        scroll.configure(with: .init(axis: .horizontal, showsIndicators: true))
        #expect(scroll.showsVerticalScrollIndicator == false)
        #expect(scroll.showsHorizontalScrollIndicator == true)
    }

    @Test("showsIndicators false — индикаторы скрыты для обеих осей")
    func noIndicatorsWhenDisabled() {
        let scroll = EScroll()
        scroll.configure(with: .init(axis: .vertical, showsIndicators: false))
        #expect(scroll.showsVerticalScrollIndicator == false)
        #expect(scroll.showsHorizontalScrollIndicator == false)
    }
}
