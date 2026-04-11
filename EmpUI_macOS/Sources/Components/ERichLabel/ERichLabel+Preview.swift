import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("ERichLabel -- Plain Attributed") {
    let view = ERichLabel()
    let text = NSAttributedString(
        string: "Hello, Rich Label!",
        attributes: [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.Semantic.textPrimary,
        ]
    )
    let _ = view.configure(with: .init(attributedText: text))
    view
}

@available(macOS 14.0, *)
#Preview("ERichLabel -- Mixed Styles") {
    let view = ERichLabel()
    let text = NSMutableAttributedString()
    let _ = text.append(NSAttributedString(
        string: "Bold ",
        attributes: [
            .font: NSFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: NSColor.Semantic.textPrimary,
        ]
    ))
    let _ = text.append(NSAttributedString(
        string: "and ",
        attributes: [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.Semantic.textPrimary,
        ]
    ))
    let _ = text.append(NSAttributedString(
        string: "colored",
        attributes: [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.Semantic.actionPrimary,
        ]
    ))
    let _ = view.configure(with: .init(attributedText: text))
    view
}

@available(macOS 14.0, *)
#Preview("ERichLabel -- With Link") {
    let view = ERichLabel()
    let text = NSMutableAttributedString(
        string: "Visit ",
        attributes: [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.Semantic.textPrimary,
        ]
    )
    let _ = text.append(NSAttributedString(
        string: "Apple",
        attributes: [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.Semantic.actionPrimary,
            .link: URL(string: "https://apple.com")! as NSURL,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
    ))
    let _ = text.append(NSAttributedString(
        string: " for more info.",
        attributes: [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.Semantic.textPrimary,
        ]
    ))
    let _ = view.configure(with: .init(attributedText: text))
    view
}

@available(macOS 14.0, *)
#Preview("ERichLabel -- Single Line") {
    let view = ERichLabel()
    let text = NSAttributedString(
        string: "This is a very long attributed text that should be truncated on a single line.",
        attributes: [
            .font: NSFont.systemFont(ofSize: 14),
            .foregroundColor: NSColor.Semantic.textSecondary,
        ]
    )
    let _ = view.configure(with: .init(attributedText: text, numberOfLines: 1))
    view
}
