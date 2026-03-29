import Testing
import AppKit
@testable import EmpUI_macOS

@Suite("EScroll")
@MainActor
struct EScrollTests {
    @Test("vertical — показывает только вертикальный скроллер")
    func verticalShowsOnlyVerticalScroller() {
        let scroll = EScroll()
        scroll.configure(with: .init(orientation: .vertical, showsIndicators: true))
        #expect(scroll.hasVerticalScroller == true)
        #expect(scroll.hasHorizontalScroller == false)
    }

    @Test("horizontal — показывает только горизонтальный скроллер")
    func horizontalShowsOnlyHorizontalScroller() {
        let scroll = EScroll()
        scroll.configure(with: .init(orientation: .horizontal, showsIndicators: true))
        #expect(scroll.hasVerticalScroller == false)
        #expect(scroll.hasHorizontalScroller == true)
    }

    @Test("showsIndicators false — скроллеры скрыты для обеих осей")
    func noScrollersWhenDisabled() {
        let scroll = EScroll()
        scroll.configure(with: .init(orientation: .vertical, showsIndicators: false))
        #expect(scroll.hasVerticalScroller == false)
        #expect(scroll.hasHorizontalScroller == false)
    }
}
