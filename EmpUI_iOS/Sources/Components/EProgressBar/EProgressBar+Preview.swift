import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EProgressBar — 0%") {
    let view = EProgressBar()
    let _ = view.configure(with: .init(progress: 0))
    view
}

@available(iOS 17.0, *)
#Preview("EProgressBar — 25%") {
    let view = EProgressBar()
    let _ = view.configure(with: .init(progress: 0.25))
    view
}

@available(iOS 17.0, *)
#Preview("EProgressBar — 50%") {
    let view = EProgressBar()
    let _ = view.configure(with: .init(progress: 0.5))
    view
}

@available(iOS 17.0, *)
#Preview("EProgressBar — 75%") {
    let view = EProgressBar()
    let _ = view.configure(with: .init(progress: 0.75))
    view
}

@available(iOS 17.0, *)
#Preview("EProgressBar — 100%") {
    let view = EProgressBar()
    let _ = view.configure(with: .init(progress: 1.0))
    view
}

@available(iOS 17.0, *)
#Preview("EProgressBar — Толстая полоса") {
    let view = EProgressBar()
    let _ = view.configure(with: .init(
        progress: 0.6,
        barHeight: 12
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EProgressBar — Кастомные цвета") {
    let view = EProgressBar()
    let _ = view.configure(with: .init(
        progress: 0.4,
        fillColor: UIColor.Semantic.actionSuccess,
        barHeight: 8
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EProgressBar — Danger") {
    let view = EProgressBar()
    let _ = view.configure(with: .init(
        progress: 0.9,
        fillColor: UIColor.Semantic.actionDanger,
        barHeight: 6
    ))
    view
}
