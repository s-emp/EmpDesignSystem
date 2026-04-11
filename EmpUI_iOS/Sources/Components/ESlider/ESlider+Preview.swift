import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("ESlider — По умолчанию") {
    let view = ESlider()
    let _ = view.configure(with: .init(value: 0.5))
    view
}

@available(iOS 17.0, *)
#Preview("ESlider — Минимум") {
    let view = ESlider()
    let _ = view.configure(with: .init(value: 0))
    view
}

@available(iOS 17.0, *)
#Preview("ESlider — Максимум") {
    let view = ESlider()
    let _ = view.configure(with: .init(value: 1))
    view
}

@available(iOS 17.0, *)
#Preview("ESlider — С шагом") {
    let view = ESlider()
    let _ = view.configure(with: .init(
        value: 50,
        minimumValue: 0,
        maximumValue: 100,
        step: 10
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ESlider — Выключен") {
    let view = ESlider()
    let _ = view.configure(with: .init(
        value: 0.3,
        isEnabled: false
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ESlider — Кастомные цвета") {
    let view = ESlider()
    let _ = view.configure(with: .init(
        value: 0.6,
        minimumTrackColor: UIColor.Semantic.actionSuccess,
        maximumTrackColor: UIColor.Semantic.backgroundSecondary
    ))
    view
}
