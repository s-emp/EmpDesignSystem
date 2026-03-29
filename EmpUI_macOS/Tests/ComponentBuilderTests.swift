import Testing
import AppKit
@testable import EmpUI_macOS

@Suite("ComponentBuilder.build")
@MainActor
struct ComponentBuilderBuildTests {
    @Test("build text создаёт EText")
    func buildText() {
        let view = ComponentBuilder.build(from: .text(.init(content: .plain(.init(text: "Hi")))))
        #expect(view is EText)
    }

    @Test("build image создаёт EImage")
    func buildImage() {
        let view = ComponentBuilder.build(from: .image(.init(image: NSImage(), size: CGSize(width: 10, height: 10))))
        #expect(view is EImage)
    }

    @Test("build сохраняет viewModel через EComponent")
    func buildStoresViewModel() throws {
        let vm = EText.ViewModel(content: .plain(.init(text: "Hi")))
        let view = ComponentBuilder.build(from: .text(vm))
        let text = try #require(view as? EText)
        #expect(text.viewModel == vm)
    }
}

@Suite("ComponentBuilder.update")
@MainActor
struct ComponentBuilderUpdateTests {
    @Test("update возвращает nil когда viewModel не изменилась (skip)")
    func skipWhenEqual() {
        let descriptor = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let view = ComponentBuilder.build(from: descriptor)
        let result = ComponentBuilder.update(view: view, with: descriptor)
        #expect(result == nil)
    }

    @Test("update обновляет viewModel на месте")
    func reconfigureInPlace() throws {
        let d1 = ComponentDescriptor.text(.init(content: .plain(.init(text: "Old"))))
        let view = ComponentBuilder.build(from: d1)

        let d2 = ComponentDescriptor.text(.init(content: .plain(.init(text: "New"))))
        let result = ComponentBuilder.update(view: view, with: d2)

        #expect(result == nil)
        let text = try #require(view as? EText)
        #expect(text.viewModel.content == .plain(.init(text: "New")))
    }

    @Test("update возвращает новый view когда тип не совпадает (rebuild)")
    func rebuildWhenTypeDiffers() {
        let d1 = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let view = ComponentBuilder.build(from: d1)

        let d2 = ComponentDescriptor.image(.init(image: NSImage(), size: CGSize(width: 10, height: 10)))
        let result = ComponentBuilder.update(view: view, with: d2)

        #expect(result != nil)
        #expect(result is EImage)
    }
}

@Suite("ComponentBuilder — контейнеры")
@MainActor
struct ComponentBuilderContainerTests {
    @Test("build stack создаёт EStack с children")
    func buildStack() throws {
        let descriptor = ComponentDescriptor.stack(
            .init(orientation: .horizontal, spacing: 8),
            [
                .text(.init(content: .plain(.init(text: "A")))),
                .text(.init(content: .plain(.init(text: "B")))),
            ]
        )
        let view = ComponentBuilder.build(from: descriptor)
        let stack = try #require(view as? EStack)
        #expect(stack.views.count == 2)
        #expect(stack.spacing == 8)
        #expect(stack.orientation == .horizontal)
    }

    @Test("build tap создаёт ETapContainer с content")
    func buildTap() throws {
        let descriptor = ComponentDescriptor.tap(
            .init(action: .init(id: "test") { _ in }),
            ControlParameter(
                normal: .text(.init(content: .plain(.init(text: "Tap me"))))
            )
        )
        let view = ComponentBuilder.build(from: descriptor)
        let tap = try #require(view as? ETapContainer)
        #expect(tap.contentView is EText)
    }

    @Test("update stack — новые children добавляются в конец")
    func updateStackAddsNewChildren() throws {
        let d1 = ComponentDescriptor.stack(.init(), [
            .text(.init(content: .plain(.init(text: "A")))),
        ])
        let view = ComponentBuilder.build(from: d1)
        let stack = try #require(view as? EStack)
        #expect(stack.views.count == 1)

        let d2 = ComponentDescriptor.stack(.init(), [
            .text(.init(content: .plain(.init(text: "A")))),
            .text(.init(content: .plain(.init(text: "B")))),
            .text(.init(content: .plain(.init(text: "C")))),
        ])
        ComponentBuilder.update(view: view, with: d2)

        #expect(stack.views.count == 3)
        let textB = try #require(stack.views[1] as? EText)
        #expect(textB.viewModel.content == .plain(.init(text: "B")))
        let textC = try #require(stack.views[2] as? EText)
        #expect(textC.viewModel.content == .plain(.init(text: "C")))
    }

    @Test("update stack — лишние children удаляются")
    func updateStackRemovesExtraChildren() throws {
        let d1 = ComponentDescriptor.stack(.init(), [
            .text(.init(content: .plain(.init(text: "A")))),
            .text(.init(content: .plain(.init(text: "B")))),
            .text(.init(content: .plain(.init(text: "C")))),
        ])
        let view = ComponentBuilder.build(from: d1)
        let stack = try #require(view as? EStack)
        #expect(stack.views.count == 3)

        let d2 = ComponentDescriptor.stack(.init(), [
            .text(.init(content: .plain(.init(text: "A")))),
        ])
        ComponentBuilder.update(view: view, with: d2)

        #expect(stack.views.count == 1)
    }

    @Test("update overlay — новые children добавляются")
    func updateOverlayAddsNewChildren() throws {
        let d1 = ComponentDescriptor.overlay(.init(), [
            .text(.init(content: .plain(.init(text: "Base")))),
        ])
        let view = ComponentBuilder.build(from: d1)
        let overlay = try #require(view as? EOverlay)
        #expect(overlay.subviews.count == 1)

        let d2 = ComponentDescriptor.overlay(.init(), [
            .text(.init(content: .plain(.init(text: "Base")))),
            .text(.init(content: .plain(.init(text: "Top")))),
        ])
        ComponentBuilder.update(view: view, with: d2)

        #expect(overlay.subviews.count == 2)
    }

    @Test("update overlay — лишние children удаляются")
    func updateOverlayRemovesExtraChildren() throws {
        let d1 = ComponentDescriptor.overlay(.init(), [
            .text(.init(content: .plain(.init(text: "Base")))),
            .text(.init(content: .plain(.init(text: "Top")))),
        ])
        let view = ComponentBuilder.build(from: d1)
        let overlay = try #require(view as? EOverlay)
        #expect(overlay.subviews.count == 2)

        let d2 = ComponentDescriptor.overlay(.init(), [
            .text(.init(content: .plain(.init(text: "Base")))),
        ])
        ComponentBuilder.update(view: view, with: d2)

        #expect(overlay.subviews.count == 1)
    }

    @Test("build overlay — children привязаны к empLayoutMarginsGuide")
    func buildOverlayChildrenConstrainedToMarginsGuide() throws {
        let margins = NSEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let descriptor = ComponentDescriptor.overlay(
            .init(common: CommonViewModel(layoutMargins: margins)),
            [.text(.init(content: .plain(.init(text: "Child"))))]
        )
        let view = ComponentBuilder.build(from: descriptor)
        let overlay = try #require(view as? EOverlay)
        let child = try #require(overlay.subviews.first)
        let guide = overlay.empLayoutMarginsGuide

        let constraintsOnOverlay = overlay.constraints
        let hasTopToGuide = constraintsOnOverlay.contains(where: { c in
            (c.firstAnchor == child.topAnchor && c.secondAnchor == guide.topAnchor)
                || (c.firstAnchor == guide.topAnchor && c.secondAnchor == child.topAnchor)
        })
        #expect(hasTopToGuide, "Child top должен быть привязан к empLayoutMarginsGuide.top, а не к overlay.top")
    }

    @Test("update stack — skip неизменённые children")
    func updateStackSkipChildren() throws {
        let unchanged = ComponentDescriptor.text(.init(content: .plain(.init(text: "Static"))))
        let d1 = ComponentDescriptor.stack(.init(), [
            unchanged,
            .text(.init(content: .plain(.init(text: "Old")))),
        ])
        let view = ComponentBuilder.build(from: d1)
        let stack = try #require(view as? EStack)
        let staticView = stack.views[0]

        let d2 = ComponentDescriptor.stack(.init(), [
            unchanged,
            .text(.init(content: .plain(.init(text: "New")))),
        ])
        ComponentBuilder.update(view: view, with: d2)

        #expect(stack.views[0] === staticView)
        let updatedText = try #require(stack.views[1] as? EText)
        #expect(updatedText.viewModel.content == .plain(.init(text: "New")))
    }
}
