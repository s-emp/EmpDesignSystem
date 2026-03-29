import Testing
import AppKit
@testable import EmpUI_macOS

@Suite("ComponentDescriptor")
struct ComponentDescriptorTests {
    @Test("Equatable — одинаковые text дескрипторы равны")
    func textEqual() {
        let a = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let b = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        #expect(a == b)
    }

    @Test("Equatable — разные text дескрипторы не равны")
    func textNotEqual() {
        let a = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let b = ComponentDescriptor.text(.init(content: .plain(.init(text: "Bye"))))
        #expect(a != b)
    }

    @Test("Equatable — разные типы не равны")
    func differentTypes() {
        let text = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let image = ComponentDescriptor.image(.init(image: NSImage(), size: .zero))
        #expect(text != image)
    }
}
