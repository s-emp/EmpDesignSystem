import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpLabel — Title") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Title Text", style: .title))
    label
}

@available(macOS 14.0, *)
#Preview("EmpLabel — Body") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Body text goes here. This is a longer piece of text.", style: .body))
    label
}

@available(macOS 14.0, *)
#Preview("EmpLabel — Caption") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(text: "Caption text", style: .caption))
    label
}

@available(macOS 14.0, *)
#Preview("EmpLabel — With Common Styling") {
    let label = EmpLabel()
    let _ = label.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 1, color: .separatorColor, style: .dashed),
            corners: .init(radius: 8),
            backgroundColor: .controlBackgroundColor,
            layoutMargins: NSEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        ),
        text: "Styled label with padding and border",
        style: .body
    ))
    label
}
