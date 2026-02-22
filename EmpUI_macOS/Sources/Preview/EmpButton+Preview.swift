import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpButton — Primary") {
    let button = EmpButton()
    button.configure(with: .init(title: "Primary Action", style: .primary))
    button
}

@available(macOS 14.0, *)
#Preview("EmpButton — Secondary") {
    let button = EmpButton()
    button.configure(with: .init(title: "Secondary Action", style: .secondary))
    button
}
