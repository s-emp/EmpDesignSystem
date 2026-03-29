import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EText — Plain") {
    let view = EText()
    let _ = view.configure(with: .init(
        content: .plain(.init(text: "Hello, World!"))
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EText — Bold Title") {
    let view = EText()
    let _ = view.configure(with: .init(
        content: .plain(.init(
            text: "Bold Title",
            font: .systemFont(ofSize: 24, weight: .bold),
            color: NSColor.Semantic.textPrimary
        ))
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EText — Multiline") {
    let view = EText()
    let _ = view.configure(with: .init(
        content: .plain(.init(
            text: "This is a long text that should wrap to multiple lines when the view is narrow enough.",
            font: .systemFont(ofSize: 14),
            color: NSColor.Semantic.textSecondary
        )),
        numberOfLines: 0
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EText — Single Line") {
    let view = EText()
    let _ = view.configure(with: .init(
        content: .plain(.init(text: "This is a long text that should be truncated on a single line.")),
        numberOfLines: 1
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EText — Center Aligned") {
    let view = EText()
    let _ = view.configure(with: .init(
        content: .plain(.init(text: "Centered Text")),
        alignment: .center
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EText — Attributed") {
    let view = EText()
    let attributed = NSAttributedString(
        string: "Attributed Text",
        attributes: [
            .font: NSFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: NSColor.Semantic.textAccent,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
    )
    let _ = view.configure(with: .init(content: .attributed(attributed)))
    view
}
