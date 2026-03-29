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
