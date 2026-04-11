import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EDisclosure — Collapsed") {
    let view = EDisclosure()
    let _ = view.configure(with: .init(title: "Section Title"))
    let content = NSTextField(labelWithString: "Content inside disclosure")
    let _ = view.setContent(content)
    view
}

@available(macOS 14.0, *)
#Preview("EDisclosure — Expanded") {
    let view = EDisclosure()
    let _ = view.configure(with: .init(
        title: "Expanded Section",
        isExpanded: true
    ))
    let content = NSTextField(labelWithString: "This content is visible when the disclosure is expanded.")
    let _ = view.setContent(content)
    view
}

@available(macOS 14.0, *)
#Preview("EDisclosure — With Margins") {
    let view = EDisclosure()
    let _ = view.configure(with: .init(
        common: CommonViewModel(layoutMargins: NSEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)),
        title: "Section With Margins",
        isExpanded: true
    ))
    let content = NSTextField(labelWithString: "Content with margins applied.")
    let _ = view.setContent(content)
    view
}
