import Testing
import AppKit
@testable import EmpUI_macOS

@Suite("DescriptorBuilder")
@MainActor
struct DescriptorBuilderTests {

    @Test("stack builder создаёт правильную структуру")
    func stackBuilder() {
        let descriptor: ComponentDescriptor = .stack(.init(orientation: .vertical, spacing: 8)) {
            ComponentDescriptor.text(.init(content: .plain(.init(text: "A"))))
            ComponentDescriptor.text(.init(content: .plain(.init(text: "B"))))
        }
        guard case let .stack(vm, children) = descriptor else {
            Issue.record("Expected .stack")
            return
        }
        #expect(vm.orientation == .vertical)
        #expect(vm.spacing == 8)
        #expect(children.count == 2)
    }

    @Test("builder поддерживает if/else")
    func conditionalBuilder() {
        let showImage = true
        let descriptor: ComponentDescriptor = .stack(.init()) {
            ComponentDescriptor.text(.init(content: .plain(.init(text: "A"))))
            if showImage {
                ComponentDescriptor.image(.init(image: NSImage(), size: CGSize(width: 10, height: 10)))
            }
        }
        guard case let .stack(_, children) = descriptor else {
            Issue.record("Expected .stack")
            return
        }
        #expect(children.count == 2)
    }

    @Test("builder поддерживает for-in")
    func forInBuilder() {
        let names = ["A", "B", "C"]
        let descriptor: ComponentDescriptor = .stack(.init()) {
            for name in names {
                ComponentDescriptor.text(.init(content: .plain(.init(text: name))))
            }
        }
        guard case let .stack(_, children) = descriptor else {
            Issue.record("Expected .stack")
            return
        }
        #expect(children.count == 3)
    }
}
