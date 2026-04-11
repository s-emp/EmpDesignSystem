import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EIcon — SF Symbol") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        source: .sfSymbol("star.fill"),
        size: 24,
        tintColor: NSColor.Semantic.actionPrimary
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EIcon — SF Symbol Large") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        source: .sfSymbol("heart.fill"),
        size: 48,
        tintColor: NSColor.Semantic.actionDanger
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EIcon — SF Symbol No Custom Tint") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        source: .sfSymbol("globe"),
        size: 32
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EIcon — With Common Styling") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 1, color: NSColor.Semantic.borderDefault),
            corners: .init(radius: 8),
            backgroundColor: NSColor.Semantic.backgroundSecondary,
            layoutMargins: NSEdgeInsets(top: .xs, left: .xs, bottom: .xs, right: .xs)
        ),
        source: .sfSymbol("person.fill"),
        size: 32,
        tintColor: NSColor.Semantic.textPrimary
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EIcon — Small 16pt") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        source: .sfSymbol("bell.fill"),
        size: 16,
        tintColor: NSColor.Semantic.actionPrimary
    ))
    view
}
