import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EIcon — SF Symbol") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        source: .sfSymbol("star.fill"),
        size: 24,
        tintColor: UIColor.Semantic.actionPrimary
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EIcon — SF Symbol Large") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        source: .sfSymbol("heart.fill"),
        size: 48,
        tintColor: UIColor.Semantic.actionDanger
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EIcon — SF Symbol No Custom Tint") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        source: .sfSymbol("globe"),
        size: 32
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EIcon — With Common Styling") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 1, color: UIColor.Semantic.borderDefault),
            corners: .init(radius: 8),
            backgroundColor: UIColor.Semantic.backgroundSecondary,
            layoutMargins: UIEdgeInsets(top: .xs, left: .xs, bottom: .xs, right: .xs)
        ),
        source: .sfSymbol("person.fill"),
        size: 32,
        tintColor: UIColor.Semantic.textPrimary
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EIcon — Small 16pt") {
    let view = EIcon()
    let _ = view.configure(with: .init(
        source: .sfSymbol("bell.fill"),
        size: 16,
        tintColor: UIColor.Semantic.actionPrimary
    ))
    view
}
