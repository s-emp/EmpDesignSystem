import AppKit

#Preview("ENativeContainer — базовый") {
    let container = ENativeContainer()
    let _ = container.configure(with: .init(
        common: .init(
            corners: .init(radius: 8),
            backgroundColor: .windowBackgroundColor,
            layoutMargins: .init(top: 16, left: 16, bottom: 16, right: 16)
        ),
        identifier: "preview-basic"
    ))

    let textField = NSTextField(labelWithString: "Произвольный AppKit контент")
    let _ = textField.alignment = .center
    let _ = container.setContent(textField)

    container
}

#Preview("ENativeContainer — с вложенным NSButton") {
    let container = ENativeContainer()
    let _ = container.configure(with: .init(
        common: .init(
            border: .init(width: 1, color: .separatorColor),
            corners: .init(radius: 12),
            layoutMargins: .init(top: 20, left: 20, bottom: 20, right: 20)
        ),
        identifier: "preview-button"
    ))

    let button = NSButton(title: "Нативная кнопка", target: nil, action: nil)
    let _ = container.setContent(button)

    container
}
