import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EActivityIndicator — Small") {
    let view = EActivityIndicator()
    let _ = view.configure(with: .init(style: .small))
    view
}

@available(iOS 17.0, *)
#Preview("EActivityIndicator — Medium") {
    let view = EActivityIndicator()
    let _ = view.configure(with: .init(style: .medium))
    view
}

@available(iOS 17.0, *)
#Preview("EActivityIndicator — Large") {
    let view = EActivityIndicator()
    let _ = view.configure(with: .init(style: .large))
    view
}

@available(iOS 17.0, *)
#Preview("EActivityIndicator — Остановлен") {
    let view = EActivityIndicator()
    let _ = view.configure(with: .init(isAnimating: false))
    view
}

@available(iOS 17.0, *)
#Preview("EActivityIndicator — Кастомный цвет") {
    let view = EActivityIndicator()
    let _ = view.configure(with: .init(
        style: .large,
        color: UIColor.Semantic.actionPrimary
    ))
    view
}
