import UIKit

#Preview("ENativeContainer — базовый") {
    let container = ENativeContainer()
    let _ = container.configure(with: .init(
        common: .init(
            corners: .init(radius: 8),
            backgroundColor: .systemGray6,
            layoutMargins: .init(top: 16, left: 16, bottom: 16, right: 16)
        ),
        identifier: "preview-basic"
    ))

    let label = UILabel()
    let _ = label.text = "Произвольный UIKit контент"
    let _ = label.textAlignment = .center
    let _ = container.setContent(label)

    container
}

#Preview("ENativeContainer — с вложенным UISwitch") {
    let container = ENativeContainer()
    let _ = container.configure(with: .init(
        common: .init(
            border: .init(width: 1, color: .separator),
            corners: .init(radius: 12),
            layoutMargins: .init(top: 20, left: 20, bottom: 20, right: 20)
        ),
        identifier: "preview-switch"
    ))

    let toggle = UISwitch()
    let _ = toggle.isOn = true
    let _ = container.setContent(toggle)

    container
}
