import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("StructureFingerprint")
struct StructureFingerprintTests {
    @Test("Одинаковая структура — одинаковый fingerprint")
    func sameStructure() {
        let a = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hello"))))
        let b = ComponentDescriptor.text(.init(content: .plain(.init(text: "World"))))
        #expect(a.fingerprint == b.fingerprint)
    }

    @Test("Разная структура — разный fingerprint")
    func differentStructure() {
        let text = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hello"))))
        let image = ComponentDescriptor.image(.init(image: UIImage(), size: .zero))
        #expect(text.fingerprint != image.fingerprint)
    }

    @Test("Leaf fingerprint — hashable")
    func leafHashable() {
        let fp = StructureFingerprint.leaf("text")
        var set = Set<StructureFingerprint>()
        set.insert(fp)
        #expect(set.contains(.leaf("text")))
        #expect(!set.contains(.leaf("image")))
    }

    @Test("Container fingerprint учитывает children")
    func containerFingerprint() {
        let a = ComponentDescriptor.stack(.init(), [.text(.init(content: .plain(.init(text: "A"))))])
        let b = ComponentDescriptor.stack(.init(), [.image(.init(image: UIImage(), size: .zero))])
        #expect(a.fingerprint != b.fingerprint)
    }

    @Test("Разное количество children — разный fingerprint")
    func differentChildCount() {
        let a = ComponentDescriptor.stack(.init(), [
            .text(.init(content: .plain(.init(text: "A")))),
        ])
        let b = ComponentDescriptor.stack(.init(), [
            .text(.init(content: .plain(.init(text: "A")))),
            .text(.init(content: .plain(.init(text: "B")))),
        ])
        #expect(a.fingerprint != b.fingerprint)
    }
}
