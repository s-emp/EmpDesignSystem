import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("ERichLabel -- Plain Attributed") {
    let view = ERichLabel()
    let text = NSAttributedString(
        string: "Hello, Rich Label!",
        attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.Semantic.textPrimary,
        ]
    )
    let _ = view.configure(with: .init(attributedText: text))
    view
}

@available(iOS 17.0, *)
#Preview("ERichLabel -- Mixed Styles") {
    let view = ERichLabel()
    let text = NSMutableAttributedString()
    let _ = text.append(NSAttributedString(
        string: "Bold ",
        attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.Semantic.textPrimary,
        ]
    ))
    let _ = text.append(NSAttributedString(
        string: "and ",
        attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.Semantic.textPrimary,
        ]
    ))
    let _ = text.append(NSAttributedString(
        string: "colored",
        attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.Semantic.actionPrimary,
        ]
    ))
    let _ = view.configure(with: .init(attributedText: text))
    view
}

@available(iOS 17.0, *)
#Preview("ERichLabel -- With Link") {
    let view = ERichLabel()
    let text = NSMutableAttributedString(
        string: "Visit ",
        attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.Semantic.textPrimary,
        ]
    )
    let _ = text.append(NSAttributedString(
        string: "Apple",
        attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.Semantic.actionPrimary,
            .link: URL(string: "https://apple.com")! as NSURL,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
    ))
    let _ = text.append(NSAttributedString(
        string: " for more info.",
        attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.Semantic.textPrimary,
        ]
    ))
    let _ = view.configure(with: .init(attributedText: text))
    view
}

@available(iOS 17.0, *)
#Preview("ERichLabel -- Single Line") {
    let view = ERichLabel()
    let text = NSAttributedString(
        string: "This is a very long attributed text that should be truncated on a single line.",
        attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.Semantic.textSecondary,
        ]
    )
    let _ = view.configure(with: .init(attributedText: text, numberOfLines: 1))
    view
}
