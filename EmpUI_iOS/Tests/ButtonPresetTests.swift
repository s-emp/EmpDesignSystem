import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("ButtonPreset")
@MainActor
struct ButtonPresetTests {

    @Test("filled генерирует .tap case")
    func filledIsTap() {
        let button = ComponentDescriptor.ButtonPreset.filled(
            .primary,
            title: "Pay",
            action: .init(id: "pay") { _ in }
        )
        guard case .tap = button else {
            Issue.record("Expected .tap case")
            return
        }
    }

    @Test("filled генерирует структурно-консистентные состояния")
    func filledConsistency() {
        let button = ComponentDescriptor.ButtonPreset.filled(
            .primary,
            title: "Test",
            action: .init(id: "test") { _ in }
        )
        guard case let .tap(_, content) = button else {
            Issue.record("Expected .tap case")
            return
        }
        #expect(content.isStructurallyConsistent)
    }
}
