import AppKit

#Preview("ESelectionContainer — Deselected") {
    let container = ESelectionContainer()
    let _ = container.configure(with: .init(isSelected: false))
    let label = NSTextField(labelWithString: "Нажми для выбора")
    let _ = label.alignment = .center
    let _ = label.backgroundColor = .controlBackgroundColor
    let _ = container.setContent(label)
    let _ = container.onSelectionChanged = { isSelected in
        label.backgroundColor = isSelected ? .selectedContentBackgroundColor : .controlBackgroundColor
        label.stringValue = isSelected ? "Выбрано" : "Нажми для выбора"
    }
    container
}

#Preview("ESelectionContainer — Selected") {
    let container = ESelectionContainer()
    let _ = container.configure(with: .init(isSelected: true))
    let label = NSTextField(labelWithString: "Выбрано")
    let _ = label.alignment = .center
    let _ = label.backgroundColor = .selectedContentBackgroundColor
    let _ = container.setContent(label)
    let _ = container.onSelectionChanged = { isSelected in
        label.backgroundColor = isSelected ? .selectedContentBackgroundColor : .controlBackgroundColor
        label.stringValue = isSelected ? "Выбрано" : "Нажми для выбора"
    }
    container
}
