import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpButton — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: .init(title: "Primary Action", style: .primary))
    button
}

@available(macOS 14.0, *)
#Preview("EmpButton — Secondary") {
    let button = EmpButton()
    let _ = button.configure(with: .init(title: "Secondary Action", style: .secondary))
    button
}

@available(macOS 14.0, *)
#Preview("EmpButton — With Common Styling") {
    let button = EmpButton()
    let _ = button.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 2, color: .controlAccentColor, style: .solid),
            shadow: .init(color: .black, offset: CGSize(width: 0, height: 2), radius: 4, opacity: 0.2),
            corners: .init(radius: 12),
            backgroundColor: .windowBackgroundColor,
            layoutMargins: NSEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        ),
        title: "Styled Button",
        style: .primary
    ))
    button
}
