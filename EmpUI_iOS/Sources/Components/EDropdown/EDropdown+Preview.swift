import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EDropdown — Плейсхолдер") {
    let dropdown = EDropdown()
    let _ = dropdown.configure(with: .init(
        items: ["Первый", "Второй", "Третий"],
        placeholder: "Выберите..."
    ))
    dropdown
}

@available(iOS 17.0, *)
#Preview("EDropdown — Выбран элемент") {
    let dropdown = EDropdown()
    let _ = dropdown.configure(with: .init(
        items: ["Яблоко", "Банан", "Вишня"],
        selectedIndex: 1,
        placeholder: "Выберите фрукт"
    ))
    dropdown
}

@available(iOS 17.0, *)
#Preview("EDropdown — Отключён") {
    let dropdown = EDropdown()
    let _ = dropdown.configure(with: .init(
        items: ["Один", "Два"],
        selectedIndex: 0,
        placeholder: "Выберите",
        isEnabled: false
    ))
    dropdown
}
