import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("ETapContainer")
@MainActor
struct ETapContainerTests {

    @Test("Action equatable по id")
    func actionEquatable() {
        let a = ETapContainer.ViewModel.Action(id: "x") { _ in }
        let b = ETapContainer.ViewModel.Action(id: "x") { _ in }
        let c = ETapContainer.ViewModel.Action(id: "y") { _ in }
        #expect(a == b)
        #expect(a != c)
    }

    @Test("configure сохраняет viewModel")
    func configureStoresViewModel() {
        let tap = ETapContainer()
        let vm = ETapContainer.ViewModel(action: .init(id: "test") { _ in })
        tap.configure(with: vm)
        #expect(tap.viewModel.action.id == "test")
    }

    @Test("Action handler получает текущую ViewModel")
    func actionReceivesViewModel() {
        var receivedID: String?
        let vm = ETapContainer.ViewModel(
            action: .init(id: "pay") { vm in
                receivedID = vm.action.id
            }
        )
        let tap = ETapContainer()
        tap.configure(with: vm)
        tap.viewModel.action.handler(tap.viewModel)
        #expect(receivedID == "pay")
    }
}
