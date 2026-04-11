import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EToggle — Выключен") {
    let view = EToggle()
    let _ = view.configure(with: .init(isOn: false))
    view
}

@available(iOS 17.0, *)
#Preview("EToggle — Включён") {
    let view = EToggle()
    let _ = view.configure(with: .init(isOn: true))
    view
}

@available(iOS 17.0, *)
#Preview("EToggle — Выключен (disabled)") {
    let view = EToggle()
    let _ = view.configure(with: .init(isOn: false, isEnabled: false))
    view
}

@available(iOS 17.0, *)
#Preview("EToggle — Включён (disabled)") {
    let view = EToggle()
    let _ = view.configure(with: .init(isOn: true, isEnabled: false))
    view
}

@available(iOS 17.0, *)
#Preview("EToggle — Кастомный цвет") {
    let view = EToggle()
    let _ = view.configure(with: .init(
        isOn: true,
        onTintColor: UIColor.Semantic.actionSuccess
    ))
    view
}
