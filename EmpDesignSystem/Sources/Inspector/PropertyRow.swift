import Cocoa
import EmpUI_macOS

@MainActor
enum PropertyRow {

    // MARK: - Text Field

    static func textField(
        label: String,
        value: String,
        onChange: @escaping (String) -> Void
    ) -> NSView {
        let stack = EStack()
        let _ = stack.configure(with: .init(
            orientation: .vertical,
            spacing: 4,
            alignment: .leading
        ))

        let labelView = makeLabel(label)
        let field = ETextField()
        let _ = field.configure(with: .init(text: value))
        field.onTextChanged = onChange

        stack.addArrangedSubview(labelView)
        stack.addArrangedSubview(field)

        field.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            field.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            field.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
        ])

        return stack
    }

    // MARK: - Slider

    static func slider(
        label: String,
        value: Double,
        min: Double,
        max: Double,
        step: Double? = nil,
        onChange: @escaping (Double) -> Void
    ) -> NSView {
        let outerStack = EStack()
        let _ = outerStack.configure(with: .init(
            orientation: .vertical,
            spacing: 4,
            alignment: .leading
        ))

        let headerStack = EStack()
        let _ = headerStack.configure(with: .init(
            orientation: .horizontal,
            spacing: 0,
            alignment: .centerY
        ))

        let labelView = makeLabel(label)
        let valueLabel = EText()
        let _ = valueLabel.configure(with: .init(
            content: .plain(.init(
                text: formatValue(value),
                font: .monospacedDigitSystemFont(ofSize: 11, weight: .regular),
                color: .Semantic.textSecondary
            ))
        ))

        let spacer = ESpacer()
        let _ = spacer.configure(with: .init())

        headerStack.addArrangedSubview(labelView)
        headerStack.addArrangedSubview(spacer)
        headerStack.addArrangedSubview(valueLabel)

        let slider = ESlider()
        let _ = slider.configure(with: .init(
            value: value,
            minimumValue: min,
            maximumValue: max,
            step: step
        ))
        slider.onValueChanged = { newValue in
            let _ = valueLabel.configure(with: .init(
                content: .plain(.init(
                    text: formatValue(newValue),
                    font: .monospacedDigitSystemFont(ofSize: 11, weight: .regular),
                    color: .Semantic.textSecondary
                ))
            ))
            onChange(newValue)
        }

        outerStack.addArrangedSubview(headerStack)
        outerStack.addArrangedSubview(slider)

        headerStack.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStack.leadingAnchor.constraint(equalTo: outerStack.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: outerStack.trailingAnchor),
            slider.leadingAnchor.constraint(equalTo: outerStack.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: outerStack.trailingAnchor),
        ])

        return outerStack
    }

    // MARK: - Toggle

    static func toggle(
        label: String,
        value: Bool,
        onChange: @escaping (Bool) -> Void
    ) -> NSView {
        let stack = EStack()
        let _ = stack.configure(with: .init(
            orientation: .horizontal,
            spacing: 0,
            alignment: .centerY
        ))

        let labelView = makeLabel(label)
        let spacer = ESpacer()
        let _ = spacer.configure(with: .init())
        let toggle = EToggle()
        let _ = toggle.configure(with: .init(isOn: value))
        toggle.onValueChanged = onChange

        stack.addArrangedSubview(labelView)
        stack.addArrangedSubview(spacer)
        stack.addArrangedSubview(toggle)

        return stack
    }

    // MARK: - Dropdown

    static func dropdown(
        label: String,
        options: [String],
        selectedIndex: Int,
        onChange: @escaping (Int) -> Void
    ) -> NSView {
        let stack = EStack()
        let _ = stack.configure(with: .init(
            orientation: .vertical,
            spacing: 4,
            alignment: .leading
        ))

        let labelView = makeLabel(label)
        let dropdown = EDropdown()
        let _ = dropdown.configure(with: .init(
            items: options,
            selectedIndex: selectedIndex
        ))
        dropdown.onSelectionChanged = onChange

        stack.addArrangedSubview(labelView)
        stack.addArrangedSubview(dropdown)

        dropdown.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dropdown.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            dropdown.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
        ])

        return stack
    }

    // MARK: - Color Dropdown

    static let semanticColorNames: [String] = [
        "clear",
        "textPrimary",
        "textSecondary",
        "textTertiary",
        "textAccent",
        "backgroundPrimary",
        "backgroundSecondary",
        "backgroundTertiary",
        "borderDefault",
        "borderSubtle",
        "actionPrimary",
        "actionSuccess",
        "actionWarning",
        "actionDanger",
        "actionInfo",
        "cardLavender",
        "cardMint",
        "cardPeach",
        "cardRose",
        "cardSky",
        "cardLemon",
        "cardLilac",
    ]

    static func colorForName(_ name: String) -> NSColor {
        switch name {
        case "clear": return .clear
        case "textPrimary": return .Semantic.textPrimary
        case "textSecondary": return .Semantic.textSecondary
        case "textTertiary": return .Semantic.textTertiary
        case "textAccent": return .Semantic.textAccent
        case "backgroundPrimary": return .Semantic.backgroundPrimary
        case "backgroundSecondary": return .Semantic.backgroundSecondary
        case "backgroundTertiary": return .Semantic.backgroundTertiary
        case "borderDefault": return .Semantic.borderDefault
        case "borderSubtle": return .Semantic.borderSubtle
        case "actionPrimary": return .Semantic.actionPrimary
        case "actionSuccess": return .Semantic.actionSuccess
        case "actionWarning": return .Semantic.actionWarning
        case "actionDanger": return .Semantic.actionDanger
        case "actionInfo": return .Semantic.actionInfo
        case "cardLavender": return .Semantic.cardLavender
        case "cardMint": return .Semantic.cardMint
        case "cardPeach": return .Semantic.cardPeach
        case "cardRose": return .Semantic.cardRose
        case "cardSky": return .Semantic.cardSky
        case "cardLemon": return .Semantic.cardLemon
        case "cardLilac": return .Semantic.cardLilac
        default: return .clear
        }
    }

    static func nameForColor(_ color: NSColor) -> String {
        // Best-effort match by comparing resolved catalog colors
        for name in semanticColorNames {
            let candidate = colorForName(name)
            if candidate == color { return name }
        }
        return "clear"
    }

    static func colorDropdown(
        label: String,
        selectedName: String,
        onChange: @escaping (String) -> Void
    ) -> NSView {
        let index = semanticColorNames.firstIndex(of: selectedName) ?? 0
        return dropdown(label: label, options: semanticColorNames, selectedIndex: index) { idx in
            let name = semanticColorNames[idx]
            onChange(name)
        }
    }

    // MARK: - Helpers

    private static func makeLabel(_ text: String) -> EText {
        let label = EText()
        let _ = label.configure(with: .init(
            content: .plain(.init(
                text: text,
                font: .systemFont(ofSize: 11, weight: .medium),
                color: .Semantic.textSecondary
            ))
        ))
        return label
    }

    private static func formatValue(_ value: Double) -> String {
        if value == value.rounded() {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }
}
