import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EmpText — Plain") {
    let view = EmpText()
    let _ = view.configure(with: .init(
        content: .plain(.init(text: "Hello, World!"))
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpText — Bold Title") {
    let view = EmpText()
    let _ = view.configure(with: .init(
        content: .plain(.init(
            text: "Bold Title",
            font: .systemFont(ofSize: 24, weight: .bold),
            color: UIColor.Semantic.textPrimary
        ))
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpText — Multiline") {
    let view = EmpText()
    let _ = view.configure(with: .init(
        content: .plain(.init(
            text: "This is a long text that should wrap to multiple lines when the view is narrow enough.",
            font: .systemFont(ofSize: 14),
            color: UIColor.Semantic.textSecondary
        )),
        numberOfLines: 0
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpText — Single Line") {
    let view = EmpText()
    let _ = view.configure(with: .init(
        content: .plain(.init(text: "This is a long text that should be truncated on a single line.")),
        numberOfLines: 1
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpText — Center Aligned") {
    let view = EmpText()
    let _ = view.configure(with: .init(
        content: .plain(.init(text: "Centered Text")),
        alignment: .center
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpText — Attributed") {
    let view = EmpText()
    let attributed = NSAttributedString(
        string: "Attributed Text",
        attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.Semantic.textAccent,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
    )
    let _ = view.configure(with: .init(content: .attributed(attributed)))
    view
}
