import UIKit

#Preview("ESelectionContainer — Deselected") {
    let container = ESelectionContainer()
    let _ = container.configure(with: .init(isSelected: false))
    let label = UILabel()
    let _ = label.text = "Нажми для выбора"
    let _ = label.textAlignment = .center
    let _ = label.backgroundColor = .systemGray6
    let _ = container.setContent(label)
    let _ = container.onSelectionChanged = { isSelected in
        label.backgroundColor = isSelected ? .systemBlue.withAlphaComponent(0.2) : .systemGray6
        label.text = isSelected ? "Выбрано" : "Нажми для выбора"
    }
    container
}

#Preview("ESelectionContainer — Selected") {
    let container = ESelectionContainer()
    let _ = container.configure(with: .init(isSelected: true))
    let label = UILabel()
    let _ = label.text = "Выбрано"
    let _ = label.textAlignment = .center
    let _ = label.backgroundColor = .systemBlue.withAlphaComponent(0.2)
    let _ = container.setContent(label)
    let _ = container.onSelectionChanged = { isSelected in
        label.backgroundColor = isSelected ? .systemBlue.withAlphaComponent(0.2) : .systemGray6
        label.text = isSelected ? "Выбрано" : "Нажми для выбора"
    }
    container
}
