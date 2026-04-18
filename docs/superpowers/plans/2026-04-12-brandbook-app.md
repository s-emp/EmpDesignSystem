# Brandbook App Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Превратить sandbox-приложение EmpDesignSystem в интерактивный brandbook — каталог компонентов дизайн-системы с live preview и конструктором ViewModel.

**Architecture:** Pure AppKit, используя исключительно компоненты из EmpUI_macOS. ESplitView для 3-panel layout (sidebar | preview | inspector). Inspector строит UI рекурсивно из структуры ViewModel. Центральный AppState управляет выбранным компонентом и текущим ViewModel.

**Tech Stack:** Swift 6, AppKit, EmpUI_macOS

---

## File Structure

```
EmpDesignSystem/Sources/
├── EmpDesignSystemApp.swift          — (modify) заменить SwiftUI на AppKit NSApplication
├── AppDelegate.swift                 — (create) NSApplicationDelegate, создание окна
├── MainWindowController.swift        — (create) NSWindowController, сборка ESplitView
├── Sidebar/
│   ├── SidebarBuilder.swift          — (create) построение sidebar из DS компонентов
│   └── CatalogItem.swift             — (create) модель элементов каталога
├── Preview/
│   └── PreviewBuilder.swift          — (create) построение preview области
├── Inspector/
│   ├── InspectorBuilder.swift        — (create) построение inspector из ViewModel
│   ├── PropertyRow.swift             — (create) строка label + control
│   └── ViewModelState.swift          — (create) mutable state обёртка для ViewModel
└── ComponentPages/
    └── ComponentFactory.swift        — (create) фабрика: CatalogItem → NSView + ViewModel
```

---

### Task 1: AppKit Shell — Замена SwiftUI на AppKit

**Files:**
- Modify: `EmpDesignSystem/Sources/EmpDesignSystemApp.swift`
- Create: `EmpDesignSystem/Sources/AppDelegate.swift`
- Create: `EmpDesignSystem/Sources/MainWindowController.swift`

- [ ] **Step 1: Заменить SwiftUI entry point на AppKit**

Заменить содержимое `EmpDesignSystemApp.swift`:

```swift
import Cocoa

@main
class AppMain {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}
```

- [ ] **Step 2: Создать AppDelegate**

Создать `EmpDesignSystem/Sources/AppDelegate.swift`:

```swift
import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowController: MainWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        windowController = MainWindowController()
        windowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
```

- [ ] **Step 3: Создать MainWindowController с ESplitView**

Создать `EmpDesignSystem/Sources/MainWindowController.swift`:

```swift
import Cocoa
import EmpUI_macOS

final class MainWindowController: NSWindowController {
    private let splitView = ESplitView()

    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "EmpDesignSystem — Brandbook"
        window.center()
        super.init(window: window)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        let _ = splitView.configure(with: .init(
            orientation: .horizontal,
            dividerStyle: .thin
        ))

        // Temporary placeholder panels
        let sidebar = makePanel(title: "Sidebar", color: .Semantic.backgroundSecondary)
        let preview = makePanel(title: "Preview", color: .Semantic.backgroundPrimary)
        let inspector = makePanel(title: "Inspector", color: .Semantic.backgroundSecondary)

        splitView.addPanel(sidebar, minSize: 200, maxSize: 300)
        splitView.addPanel(preview, minSize: 400, maxSize: nil)
        splitView.addPanel(inspector, minSize: 260, maxSize: 400)

        window?.contentView = splitView
    }

    private func makePanel(title: String, color: NSColor) -> NSView {
        let text = EText()
        let _ = text.configure(with: .init(
            content: .plain(.init(text: title, color: .Semantic.textSecondary)),
            alignment: .center
        ))
        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(backgroundColor: color),
            orientation: .vertical
        ))
        stack.addArrangedSubview(text)
        return stack
    }
}
```

- [ ] **Step 4: Удалить старый ContentView.swift**

Удалить `EmpDesignSystem/Sources/ContentView.swift` — больше не нужен.

- [ ] **Step 5: Собрать и проверить**

```bash
mise exec -- tuist generate --no-open
mise exec -- tuist build EmpDesignSystem
```

Ожидаем: окно с тремя панелями-заглушками.

- [ ] **Step 6: Commit**

```bash
git add EmpDesignSystem/Sources/
git commit -m "feat: заменить SwiftUI sandbox на AppKit brandbook shell"
```

---

### Task 2: Модель каталога — CatalogItem

**Files:**
- Create: `EmpDesignSystem/Sources/Sidebar/CatalogItem.swift`

- [ ] **Step 1: Создать модель каталога**

```swift
import Foundation

enum CatalogCategory: String, CaseIterable {
    case tokens = "Tokens"
    case contentViews = "Content Views"
    case inputViews = "Input Views"
    case layout = "Layout"
    case wrappers = "Wrappers"
    case composed = "Composed"
}

struct CatalogItem: Equatable {
    let id: String
    let name: String
    let category: CatalogCategory

    static let all: [CatalogItem] = [
        // Tokens
        CatalogItem(id: "typography", name: "Typography", category: .tokens),
        CatalogItem(id: "colors", name: "Colors", category: .tokens),
        CatalogItem(id: "spacing", name: "Spacing", category: .tokens),
        CatalogItem(id: "opacity", name: "Opacity", category: .tokens),
        CatalogItem(id: "shape-presets", name: "Shape Presets", category: .tokens),
        CatalogItem(id: "shadow-presets", name: "Shadow Presets", category: .tokens),

        // Content Views
        CatalogItem(id: "etext", name: "EText", category: .contentViews),
        CatalogItem(id: "eicon", name: "EIcon", category: .contentViews),
        CatalogItem(id: "erichlabel", name: "ERichLabel", category: .contentViews),
        CatalogItem(id: "eimage", name: "EImage", category: .contentViews),
        CatalogItem(id: "edivider", name: "EDivider", category: .contentViews),
        CatalogItem(id: "eprogressbar", name: "EProgressBar", category: .contentViews),
        CatalogItem(id: "eactivityindicator", name: "EActivityIndicator", category: .contentViews),
        CatalogItem(id: "eanimationview", name: "EAnimationView", category: .contentViews),

        // Input Views
        CatalogItem(id: "etextfield", name: "ETextField", category: .inputViews),
        CatalogItem(id: "etextview", name: "ETextView", category: .inputViews),
        CatalogItem(id: "etoggle", name: "EToggle", category: .inputViews),
        CatalogItem(id: "eslider", name: "ESlider", category: .inputViews),
        CatalogItem(id: "edropdown", name: "EDropdown", category: .inputViews),

        // Layout
        CatalogItem(id: "estack", name: "EStack", category: .layout),
        CatalogItem(id: "eoverlay", name: "EOverlay", category: .layout),
        CatalogItem(id: "escroll", name: "EScroll", category: .layout),
        CatalogItem(id: "espacer", name: "ESpacer", category: .layout),
        CatalogItem(id: "esplitview", name: "ESplitView", category: .layout),

        // Wrappers
        CatalogItem(id: "etapcontainer", name: "ETapContainer", category: .wrappers),
        CatalogItem(id: "eselectioncontainer", name: "ESelectionContainer", category: .wrappers),
        CatalogItem(id: "eanimationcontainer", name: "EAnimationContainer", category: .wrappers),
        CatalogItem(id: "elistcontainer", name: "EListContainer", category: .wrappers),
        CatalogItem(id: "enativecontainer", name: "ENativeContainer", category: .wrappers),
        CatalogItem(id: "edisclosure", name: "EDisclosure", category: .wrappers),

        // Composed
        CatalogItem(id: "einfocard", name: "EInfoCard", category: .composed),
        CatalogItem(id: "esegmentcontrol", name: "ESegmentControl", category: .composed),
    ]

    static func grouped() -> [(category: CatalogCategory, items: [CatalogItem])] {
        CatalogCategory.allCases.compactMap { cat in
            let items = all.filter { $0.category == cat }
            return items.isEmpty ? nil : (cat, items)
        }
    }
}
```

- [ ] **Step 2: Собрать**

```bash
mise exec -- tuist generate --no-open && mise exec -- tuist build EmpDesignSystem
```

- [ ] **Step 3: Commit**

```bash
git add EmpDesignSystem/Sources/Sidebar/CatalogItem.swift
git commit -m "feat: добавить модель каталога CatalogItem"
```

---

### Task 3: Sidebar — построение из DS компонентов

**Files:**
- Create: `EmpDesignSystem/Sources/Sidebar/SidebarBuilder.swift`
- Modify: `EmpDesignSystem/Sources/MainWindowController.swift`

- [ ] **Step 1: Создать SidebarBuilder**

```swift
import Cocoa
import EmpUI_macOS

final class SidebarBuilder {
    var onItemSelected: ((CatalogItem) -> Void)?
    private var selectedItemId: String?
    private var itemViews: [String: ETapContainer] = [:]

    func build() -> NSView {
        let scroll = EScroll()
        let _ = scroll.configure(with: .init())

        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(
                backgroundColor: .Semantic.backgroundSecondary,
                layoutMargins: NSEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            ),
            orientation: .vertical,
            spacing: 0
        ))

        for (index, group) in CatalogItem.grouped().enumerated() {
            if index > 0 {
                let divider = EDivider()
                let _ = divider.configure(with: .init(
                    common: .init(layoutMargins: NSEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
                ))
                stack.addArrangedSubview(divider)
            }

            // Category header
            let header = EText()
            let _ = header.configure(with: .init(
                common: .init(layoutMargins: NSEdgeInsets(top: 12, left: 16, bottom: 4, right: 16)),
                content: .plain(.init(
                    text: group.category.rawValue.uppercased(),
                    font: .systemFont(ofSize: 10, weight: .semibold),
                    color: .Semantic.textTertiary
                ))
            ))
            stack.addArrangedSubview(header)

            // Items
            for item in group.items {
                let row = makeRow(for: item)
                stack.addArrangedSubview(row)
            }
        }

        scroll.documentView = stack
        stack.translatesAutoresizingMaskIntoConstraints = false
        if let docView = scroll.documentView {
            NSLayoutConstraint.activate([
                docView.leadingAnchor.constraint(equalTo: scroll.contentView.leadingAnchor),
                docView.trailingAnchor.constraint(equalTo: scroll.contentView.trailingAnchor),
            ])
        }

        return scroll
    }

    func selectItem(_ itemId: String) {
        // Deselect previous
        if let prevId = selectedItemId, let prevView = itemViews[prevId] {
            prevView.contentView?.layer?.backgroundColor = NSColor.clear.cgColor
        }
        // Select new
        selectedItemId = itemId
        if let view = itemViews[itemId] {
            view.contentView?.layer?.backgroundColor = NSColor.Semantic.actionPrimaryTint.cgColor
        }
    }

    private func makeRow(for item: CatalogItem) -> NSView {
        let label = EText()
        let _ = label.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)),
            content: .plain(.init(
                text: item.name,
                font: .systemFont(ofSize: 13),
                color: .Semantic.textPrimary
            ))
        ))

        let tap = ETapContainer()
        let _ = tap.configure(with: .init(
            action: .init(id: item.id) { [weak self] in
                self?.selectItem(item.id)
                self?.onItemSelected?(item)
            }
        ))
        tap.setContent(label)

        label.wantsLayer = true
        itemViews[item.id] = tap

        return tap
    }
}
```

- [ ] **Step 2: Интегрировать sidebar в MainWindowController**

Заменить в `MainWindowController.swift` заглушку sidebar:

```swift
// Добавить свойство:
private let sidebarBuilder = SidebarBuilder()

// В setup() заменить sidebar:
let sidebar = sidebarBuilder.build()
sidebarBuilder.onItemSelected = { [weak self] item in
    self?.handleItemSelected(item)
}

// Добавить метод:
private func handleItemSelected(_ item: CatalogItem) {
    // TODO: будет реализовано в Task 5
    print("Selected: \(item.name)")
}
```

- [ ] **Step 3: Собрать и проверить**

```bash
mise exec -- tuist generate --no-open && mise exec -- tuist build EmpDesignSystem
```

- [ ] **Step 4: Commit**

```bash
git add EmpDesignSystem/Sources/
git commit -m "feat: реализовать sidebar с категориями и компонентами"
```

---

### Task 4: ComponentFactory — фабрика компонентов и ViewModel

**Files:**
- Create: `EmpDesignSystem/Sources/ComponentPages/ComponentFactory.swift`

- [ ] **Step 1: Создать фабрику**

```swift
import Cocoa
import EmpUI_macOS

enum ComponentFactory {

    struct ComponentPage {
        let component: NSView
        let defaultViewModel: Any
        let configure: (NSView, Any) -> Void
    }

    static func makePage(for item: CatalogItem) -> ComponentPage? {
        switch item.id {
        case "etext":
            let view = EText()
            let vm = EText.ViewModel(
                content: .plain(.init(text: "Hello, World!")),
                alignment: .natural
            )
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let text = v as? EText, let vm = anyVM as? EText.ViewModel else { return }
                let _ = text.configure(with: vm)
            }

        case "eicon":
            let view = EIcon()
            let vm = EIcon.ViewModel(
                source: .sfSymbol("star.fill"),
                size: 32,
                tintColor: .Semantic.actionPrimary
            )
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let icon = v as? EIcon, let vm = anyVM as? EIcon.ViewModel else { return }
                let _ = icon.configure(with: vm)
            }

        case "edivider":
            let view = EDivider()
            let vm = EDivider.ViewModel()
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let d = v as? EDivider, let vm = anyVM as? EDivider.ViewModel else { return }
                let _ = d.configure(with: vm)
            }

        case "eprogressbar":
            let view = EProgressBar()
            let vm = EProgressBar.ViewModel(progress: 0.6)
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let p = v as? EProgressBar, let vm = anyVM as? EProgressBar.ViewModel else { return }
                let _ = p.configure(with: vm)
            }

        case "etoggle":
            let view = EToggle()
            let vm = EToggle.ViewModel(isOn: true)
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let t = v as? EToggle, let vm = anyVM as? EToggle.ViewModel else { return }
                let _ = t.configure(with: vm)
            }

        case "eslider":
            let view = ESlider()
            let vm = ESlider.ViewModel(value: 0.5)
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let s = v as? ESlider, let vm = anyVM as? ESlider.ViewModel else { return }
                let _ = s.configure(with: vm)
            }

        case "edropdown":
            let view = EDropdown()
            let vm = EDropdown.ViewModel(
                items: ["Option A", "Option B", "Option C"],
                selectedIndex: 0,
                placeholder: "Select..."
            )
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let d = v as? EDropdown, let vm = anyVM as? EDropdown.ViewModel else { return }
                let _ = d.configure(with: vm)
            }

        case "etextfield":
            let view = ETextField()
            let vm = ETextField.ViewModel(placeholder: "Enter text...")
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let tf = v as? ETextField, let vm = anyVM as? ETextField.ViewModel else { return }
                let _ = tf.configure(with: vm)
            }

        case "eactivityindicator":
            let view = EActivityIndicator()
            let vm = EActivityIndicator.ViewModel(isAnimating: true)
            let _ = view.configure(with: vm)
            return ComponentPage(component: view, defaultViewModel: vm) { v, anyVM in
                guard let ai = v as? EActivityIndicator, let vm = anyVM as? EActivityIndicator.ViewModel else { return }
                let _ = ai.configure(with: vm)
            }

        // Добавить остальные компоненты по аналогии
        default:
            return nil
        }
    }
}
```

Остальные компоненты (ERichLabel, EImage, ETextView, EStack, EOverlay, EScroll, ESpacer, ESplitView, ETapContainer, ESelectionContainer, EAnimationContainer, EAnimationView, EListContainer, ENativeContainer, EDisclosure, EInfoCard, ESegmentControl) добавляются по тому же паттерну. Каждый case создаёт view + default ViewModel + configure closure.

- [ ] **Step 2: Собрать**

```bash
mise exec -- tuist generate --no-open && mise exec -- tuist build EmpDesignSystem
```

- [ ] **Step 3: Commit**

```bash
git add EmpDesignSystem/Sources/ComponentPages/
git commit -m "feat: добавить ComponentFactory — фабрика компонентов для brandbook"
```

---

### Task 5: Preview Area

**Files:**
- Create: `EmpDesignSystem/Sources/Preview/PreviewBuilder.swift`
- Modify: `EmpDesignSystem/Sources/MainWindowController.swift`

- [ ] **Step 1: Создать PreviewBuilder**

```swift
import Cocoa
import EmpUI_macOS

final class PreviewBuilder {
    private let container = EStack()
    private let titleLabel = EText()
    private let contentContainer = EStack()
    private var currentComponentView: NSView?

    func build() -> NSView {
        let _ = container.configure(with: .init(
            common: .init(backgroundColor: .Semantic.backgroundPrimary),
            orientation: .vertical,
            spacing: 0
        ))

        // Header bar
        let headerBar = EStack()
        let _ = headerBar.configure(with: .init(
            common: .init(
                backgroundColor: .Semantic.backgroundSecondary,
                layoutMargins: NSEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            ),
            orientation: .horizontal,
            spacing: 8
        ))
        let _ = titleLabel.configure(with: .init(
            content: .plain(.init(
                text: "Select a component",
                font: .systemFont(ofSize: 12),
                color: .Semantic.textSecondary
            ))
        ))
        headerBar.addArrangedSubview(titleLabel)

        let divider = EDivider()
        let _ = divider.configure(with: .init())

        // Content area — centers the component
        let _ = contentContainer.configure(with: .init(
            common: .init(backgroundColor: .Semantic.backgroundPrimary),
            orientation: .vertical
        ))

        container.addArrangedSubview(headerBar)
        container.addArrangedSubview(divider)
        container.addArrangedSubview(contentContainer)

        // Make contentContainer fill available space
        contentContainer.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentContainer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return container
    }

    func showComponent(name: String, view: NSView) {
        let _ = titleLabel.configure(with: .init(
            content: .plain(.init(
                text: "\(name) — Preview",
                font: .systemFont(ofSize: 12),
                color: .Semantic.textSecondary
            ))
        ))

        currentComponentView?.removeFromSuperview()
        currentComponentView = view

        view.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
        ])
    }
}
```

- [ ] **Step 2: Интегрировать в MainWindowController**

Добавить свойство `previewBuilder` и заменить заглушку preview в `setup()`. Реализовать `handleItemSelected`:

```swift
private let previewBuilder = PreviewBuilder()
private var currentPage: ComponentFactory.ComponentPage?

// В setup():
let preview = previewBuilder.build()

// handleItemSelected:
private func handleItemSelected(_ item: CatalogItem) {
    guard let page = ComponentFactory.makePage(for: item) else { return }
    currentPage = page
    previewBuilder.showComponent(name: item.name, view: page.component)
    // Inspector будет в Task 6
}
```

- [ ] **Step 3: Собрать и проверить**

```bash
mise exec -- tuist generate --no-open && mise exec -- tuist build EmpDesignSystem
```

- [ ] **Step 4: Commit**

```bash
git add EmpDesignSystem/Sources/
git commit -m "feat: реализовать preview область с live компонентом"
```

---

### Task 6: Inspector — PropertyRow и InspectorBuilder

**Files:**
- Create: `EmpDesignSystem/Sources/Inspector/PropertyRow.swift`
- Create: `EmpDesignSystem/Sources/Inspector/InspectorBuilder.swift`
- Create: `EmpDesignSystem/Sources/Inspector/ViewModelState.swift`

- [ ] **Step 1: Создать PropertyRow — строка label + control**

```swift
import Cocoa
import EmpUI_macOS

enum PropertyRow {

    static func textField(label: String, value: String, onChange: @escaping (String) -> Void) -> NSView {
        let row = EStack()
        let _ = row.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)),
            orientation: .vertical,
            spacing: 4
        ))

        let labelView = EText()
        let _ = labelView.configure(with: .init(
            content: .plain(.init(text: label, font: .systemFont(ofSize: 10), color: .Semantic.textTertiary))
        ))

        let field = ETextField()
        let _ = field.configure(with: .init(text: value, placeholder: label))
        field.onTextChanged = onChange

        row.addArrangedSubview(labelView)
        row.addArrangedSubview(field)
        return row
    }

    static func slider(label: String, value: Double, min: Double, max: Double, step: Double? = nil, onChange: @escaping (Double) -> Void) -> NSView {
        let row = EStack()
        let _ = row.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)),
            orientation: .vertical,
            spacing: 4
        ))

        let headerRow = EStack()
        let _ = headerRow.configure(with: .init(orientation: .horizontal, spacing: 4))

        let labelView = EText()
        let _ = labelView.configure(with: .init(
            content: .plain(.init(text: label, font: .systemFont(ofSize: 10), color: .Semantic.textTertiary))
        ))

        let valueLabel = EText()
        let _ = valueLabel.configure(with: .init(
            content: .plain(.init(text: String(format: "%.1f", value), font: .systemFont(ofSize: 10), color: .Semantic.textSecondary)),
            alignment: .right
        ))

        headerRow.addArrangedSubview(labelView)
        headerRow.addArrangedSubview(valueLabel)

        let slider = ESlider()
        let _ = slider.configure(with: .init(value: value, minimumValue: min, maximumValue: max, step: step))
        slider.onValueChanged = { newValue in
            let _ = valueLabel.configure(with: .init(
                content: .plain(.init(text: String(format: "%.1f", newValue), font: .systemFont(ofSize: 10), color: .Semantic.textSecondary)),
                alignment: .right
            ))
            onChange(newValue)
        }

        row.addArrangedSubview(headerRow)
        row.addArrangedSubview(slider)
        return row
    }

    static func toggle(label: String, value: Bool, onChange: @escaping (Bool) -> Void) -> NSView {
        let row = EStack()
        let _ = row.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)),
            orientation: .horizontal,
            spacing: 8
        ))

        let labelView = EText()
        let _ = labelView.configure(with: .init(
            content: .plain(.init(text: label, font: .systemFont(ofSize: 10), color: .Semantic.textTertiary))
        ))

        let toggle = EToggle()
        let _ = toggle.configure(with: .init(isOn: value))
        toggle.onValueChanged = onChange

        row.addArrangedSubview(labelView)
        row.addArrangedSubview(ESpacer())
        row.addArrangedSubview(toggle)
        return row
    }

    static func dropdown(label: String, options: [String], selectedIndex: Int, onChange: @escaping (Int) -> Void) -> NSView {
        let row = EStack()
        let _ = row.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)),
            orientation: .vertical,
            spacing: 4
        ))

        let labelView = EText()
        let _ = labelView.configure(with: .init(
            content: .plain(.init(text: label, font: .systemFont(ofSize: 10), color: .Semantic.textTertiary))
        ))

        let dropdown = EDropdown()
        let _ = dropdown.configure(with: .init(items: options, selectedIndex: selectedIndex, placeholder: label))
        dropdown.onSelectionChanged = onChange

        row.addArrangedSubview(labelView)
        row.addArrangedSubview(dropdown)
        return row
    }

    static func colorDropdown(label: String, selectedName: String, onChange: @escaping (String, NSColor) -> Void) -> NSView {
        let colors: [(String, NSColor)] = [
            ("textPrimary", .Semantic.textPrimary),
            ("textSecondary", .Semantic.textSecondary),
            ("textTertiary", .Semantic.textTertiary),
            ("textAccent", .Semantic.textAccent),
            ("actionPrimary", .Semantic.actionPrimary),
            ("actionSuccess", .Semantic.actionSuccess),
            ("actionWarning", .Semantic.actionWarning),
            ("actionDanger", .Semantic.actionDanger),
            ("actionInfo", .Semantic.actionInfo),
            ("clear", .clear),
        ]
        let names = colors.map(\.0)
        let selected = names.firstIndex(of: selectedName) ?? 0
        return dropdown(label: label, options: names, selectedIndex: selected) { index in
            onChange(colors[index].0, colors[index].1)
        }
    }
}
```

- [ ] **Step 2: Создать InspectorBuilder для EText (первый компонент)**

```swift
import Cocoa
import EmpUI_macOS

final class InspectorBuilder {
    var onViewModelChanged: ((Any) -> Void)?

    func build(for item: CatalogItem, viewModel: Any) -> NSView {
        let scroll = EScroll()
        let _ = scroll.configure(with: .init())

        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(
                backgroundColor: .Semantic.backgroundSecondary,
                layoutMargins: NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            ),
            orientation: .vertical,
            spacing: 4
        ))

        // Header
        let header = EText()
        let _ = header.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)),
            content: .plain(.init(text: "Inspector", font: .systemFont(ofSize: 12, weight: .semibold), color: .Semantic.textSecondary))
        ))
        stack.addArrangedSubview(header)

        let divider = EDivider()
        let _ = divider.configure(with: .init())
        stack.addArrangedSubview(divider)

        // Build property rows based on component type
        let rows = makeRows(for: item, viewModel: viewModel)
        for row in rows {
            stack.addArrangedSubview(row)
        }

        scroll.documentView = stack
        stack.translatesAutoresizingMaskIntoConstraints = false
        if let docView = scroll.documentView {
            NSLayoutConstraint.activate([
                docView.leadingAnchor.constraint(equalTo: scroll.contentView.leadingAnchor),
                docView.trailingAnchor.constraint(equalTo: scroll.contentView.trailingAnchor),
            ])
        }

        return scroll
    }

    private func makeRows(for item: CatalogItem, viewModel: Any) -> [NSView] {
        switch item.id {
        case "etext":
            return makeETextRows(viewModel as! EText.ViewModel)
        case "etoggle":
            return makeEToggleRows(viewModel as! EToggle.ViewModel)
        case "eslider":
            return makeESliderRows(viewModel as! ESlider.ViewModel)
        case "edropdown":
            return makeEDropdownRows(viewModel as! EDropdown.ViewModel)
        case "edivider":
            return makeEDividerRows(viewModel as! EDivider.ViewModel)
        case "eprogressbar":
            return makeEProgressBarRows(viewModel as! EProgressBar.ViewModel)
        case "eicon":
            return makeEIconRows(viewModel as! EIcon.ViewModel)
        case "etextfield":
            return makeETextFieldRows(viewModel as! ETextField.ViewModel)
        case "eactivityindicator":
            return makeEActivityIndicatorRows(viewModel as! EActivityIndicator.ViewModel)
        default:
            return [makeComingSoon()]
        }
    }

    private func makeComingSoon() -> NSView {
        let text = EText()
        let _ = text.configure(with: .init(
            content: .plain(.init(text: "Inspector coming soon", color: .Semantic.textTertiary)),
            alignment: .center
        ))
        return text
    }

    // MARK: - EText Inspector

    private func makeETextRows(_ vm: EText.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        // Text content (plain text only for now)
        if case let .plain(plain) = vm.content {
            rows.append(PropertyRow.textField(label: "text", value: plain.text) { [weak self] newText in
                current = EText.ViewModel(
                    common: current.common,
                    content: .plain(.init(text: newText, font: plain.font, color: plain.color)),
                    numberOfLines: current.numberOfLines,
                    alignment: current.alignment
                )
                self?.onViewModelChanged?(current)
            })
        }

        // numberOfLines
        rows.append(PropertyRow.slider(label: "numberOfLines", value: Double(vm.numberOfLines), min: 0, max: 10, step: 1) { [weak self] newVal in
            let plainContent: EText.Content
            if case let .plain(p) = current.content { plainContent = .plain(p) } else { plainContent = current.content }
            current = EText.ViewModel(
                common: current.common,
                content: plainContent,
                numberOfLines: Int(newVal),
                alignment: current.alignment
            )
            self?.onViewModelChanged?(current)
        })

        // alignment
        let alignments = ["natural", "left", "center", "right"]
        let currentAlign: Int = {
            switch vm.alignment {
            case .natural: return 0
            case .left: return 1
            case .center: return 2
            case .right: return 3
            default: return 0
            }
        }()
        rows.append(PropertyRow.dropdown(label: "alignment", options: alignments, selectedIndex: currentAlign) { [weak self] idx in
            let align: NSTextAlignment = [.natural, .left, .center, .right][idx]
            current = EText.ViewModel(
                common: current.common,
                content: current.content,
                numberOfLines: current.numberOfLines,
                alignment: align
            )
            self?.onViewModelChanged?(current)
        })

        // CommonViewModel section
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = EText.ViewModel(
                common: newCommon,
                content: current.content,
                numberOfLines: current.numberOfLines,
                alignment: current.alignment
            )
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - EToggle Inspector

    private func makeEToggleRows(_ vm: EToggle.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        rows.append(PropertyRow.toggle(label: "isOn", value: vm.isOn) { [weak self] val in
            current = EToggle.ViewModel(common: current.common, isOn: val, isEnabled: current.isEnabled)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.toggle(label: "isEnabled", value: vm.isEnabled) { [weak self] val in
            current = EToggle.ViewModel(common: current.common, isOn: current.isOn, isEnabled: val)
            self?.onViewModelChanged?(current)
        })
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = EToggle.ViewModel(common: newCommon, isOn: current.isOn, isEnabled: current.isEnabled)
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - ESlider Inspector

    private func makeESliderRows(_ vm: ESlider.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        rows.append(PropertyRow.slider(label: "value", value: vm.value, min: vm.minimumValue, max: vm.maximumValue) { [weak self] val in
            current = ESlider.ViewModel(common: current.common, value: val, minimumValue: current.minimumValue, maximumValue: current.maximumValue, step: current.step, isEnabled: current.isEnabled)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.slider(label: "minimumValue", value: vm.minimumValue, min: -100, max: 100) { [weak self] val in
            current = ESlider.ViewModel(common: current.common, value: current.value, minimumValue: val, maximumValue: current.maximumValue, step: current.step, isEnabled: current.isEnabled)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.slider(label: "maximumValue", value: vm.maximumValue, min: -100, max: 100) { [weak self] val in
            current = ESlider.ViewModel(common: current.common, value: current.value, minimumValue: current.minimumValue, maximumValue: val, step: current.step, isEnabled: current.isEnabled)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.toggle(label: "isEnabled", value: vm.isEnabled) { [weak self] val in
            current = ESlider.ViewModel(common: current.common, value: current.value, minimumValue: current.minimumValue, maximumValue: current.maximumValue, step: current.step, isEnabled: val)
            self?.onViewModelChanged?(current)
        })
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = ESlider.ViewModel(common: newCommon, value: current.value, minimumValue: current.minimumValue, maximumValue: current.maximumValue, step: current.step, isEnabled: current.isEnabled)
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - EDropdown Inspector

    private func makeEDropdownRows(_ vm: EDropdown.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        rows.append(PropertyRow.textField(label: "placeholder", value: vm.placeholder) { [weak self] val in
            current = EDropdown.ViewModel(common: current.common, items: current.items, selectedIndex: current.selectedIndex, placeholder: val)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.slider(label: "selectedIndex", value: Double(vm.selectedIndex), min: 0, max: Double(max(vm.items.count - 1, 0)), step: 1) { [weak self] val in
            current = EDropdown.ViewModel(common: current.common, items: current.items, selectedIndex: Int(val), placeholder: current.placeholder)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.toggle(label: "isEnabled", value: vm.isEnabled) { [weak self] val in
            current = EDropdown.ViewModel(common: current.common, items: current.items, selectedIndex: current.selectedIndex, placeholder: current.placeholder, isEnabled: val)
            self?.onViewModelChanged?(current)
        })
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = EDropdown.ViewModel(common: newCommon, items: current.items, selectedIndex: current.selectedIndex, placeholder: current.placeholder, isEnabled: current.isEnabled)
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - EDivider Inspector

    private func makeEDividerRows(_ vm: EDivider.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        let axes = ["horizontal", "vertical"]
        let currentAxis = vm.axis == .horizontal ? 0 : 1
        rows.append(PropertyRow.dropdown(label: "axis", options: axes, selectedIndex: currentAxis) { [weak self] idx in
            current = EDivider.ViewModel(common: current.common, axis: idx == 0 ? .horizontal : .vertical, thickness: current.thickness, color: current.color)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.slider(label: "thickness", value: Double(vm.thickness), min: 0.5, max: 10, step: 0.5) { [weak self] val in
            current = EDivider.ViewModel(common: current.common, axis: current.axis, thickness: CGFloat(val), color: current.color)
            self?.onViewModelChanged?(current)
        })
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = EDivider.ViewModel(common: newCommon, axis: current.axis, thickness: current.thickness, color: current.color)
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - EProgressBar Inspector

    private func makeEProgressBarRows(_ vm: EProgressBar.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        rows.append(PropertyRow.slider(label: "progress", value: Double(vm.progress), min: 0, max: 1, step: 0.05) { [weak self] val in
            current = EProgressBar.ViewModel(common: current.common, progress: CGFloat(val))
            self?.onViewModelChanged?(current)
        })
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = EProgressBar.ViewModel(common: newCommon, progress: current.progress)
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - EIcon Inspector

    private func makeEIconRows(_ vm: EIcon.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        let sfSymbols = ["star.fill", "heart.fill", "bell.fill", "gear", "person.fill", "house.fill", "magnifyingglass", "checkmark.circle.fill", "xmark.circle.fill", "arrow.right"]
        let currentIdx: Int = {
            if case let .sfSymbol(name) = vm.source { return sfSymbols.firstIndex(of: name) ?? 0 }
            return 0
        }()
        rows.append(PropertyRow.dropdown(label: "sfSymbol", options: sfSymbols, selectedIndex: currentIdx) { [weak self] idx in
            current = EIcon.ViewModel(common: current.common, source: .sfSymbol(sfSymbols[idx]), size: current.size, tintColor: current.tintColor)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.slider(label: "size", value: Double(vm.size), min: 8, max: 96, step: 4) { [weak self] val in
            current = EIcon.ViewModel(common: current.common, source: current.source, size: CGFloat(val), tintColor: current.tintColor)
            self?.onViewModelChanged?(current)
        })
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = EIcon.ViewModel(common: newCommon, source: current.source, size: current.size, tintColor: current.tintColor)
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - ETextField Inspector

    private func makeETextFieldRows(_ vm: ETextField.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        rows.append(PropertyRow.textField(label: "text", value: vm.text) { [weak self] val in
            current = ETextField.ViewModel(common: current.common, text: val, placeholder: current.placeholder, isEnabled: current.isEnabled, isSecure: current.isSecure)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.textField(label: "placeholder", value: vm.placeholder) { [weak self] val in
            current = ETextField.ViewModel(common: current.common, text: current.text, placeholder: val, isEnabled: current.isEnabled, isSecure: current.isSecure)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.toggle(label: "isEnabled", value: vm.isEnabled) { [weak self] val in
            current = ETextField.ViewModel(common: current.common, text: current.text, placeholder: current.placeholder, isEnabled: val, isSecure: current.isSecure)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.toggle(label: "isSecure", value: vm.isSecure) { [weak self] val in
            current = ETextField.ViewModel(common: current.common, text: current.text, placeholder: current.placeholder, isEnabled: current.isEnabled, isSecure: val)
            self?.onViewModelChanged?(current)
        })
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = ETextField.ViewModel(common: newCommon, text: current.text, placeholder: current.placeholder, isEnabled: current.isEnabled, isSecure: current.isSecure)
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - EActivityIndicator Inspector

    private func makeEActivityIndicatorRows(_ vm: EActivityIndicator.ViewModel) -> [NSView] {
        var current = vm
        var rows: [NSView] = []

        let styles = ["small", "medium", "large"]
        let currentStyle: Int = {
            switch vm.style {
            case .small: return 0
            case .medium: return 1
            case .large: return 2
            }
        }()
        rows.append(PropertyRow.dropdown(label: "style", options: styles, selectedIndex: currentStyle) { [weak self] idx in
            let style: EActivityIndicator.ViewModel.Style = [.small, .medium, .large][idx]
            current = EActivityIndicator.ViewModel(common: current.common, style: style, color: current.color, isAnimating: current.isAnimating)
            self?.onViewModelChanged?(current)
        })
        rows.append(PropertyRow.toggle(label: "isAnimating", value: vm.isAnimating) { [weak self] val in
            current = EActivityIndicator.ViewModel(common: current.common, style: current.style, color: current.color, isAnimating: val)
            self?.onViewModelChanged?(current)
        })
        rows.append(makeCommonSection(current.common) { [weak self] newCommon in
            current = EActivityIndicator.ViewModel(common: newCommon, style: current.style, color: current.color, isAnimating: current.isAnimating)
            self?.onViewModelChanged?(current)
        })

        return rows
    }

    // MARK: - CommonViewModel Section (reusable)

    func makeCommonSection(_ common: CommonViewModel, onChange: @escaping (CommonViewModel) -> Void) -> NSView {
        var current = common

        let disclosure = EDisclosure()
        let _ = disclosure.configure(with: .init(title: "common", isExpanded: false))

        let stack = EStack()
        let _ = stack.configure(with: .init(orientation: .vertical, spacing: 4))

        // backgroundColor
        stack.addArrangedSubview(PropertyRow.colorDropdown(label: "backgroundColor", selectedName: "clear") { [weak self] _, color in
            current = CommonViewModel(border: current.border, shadow: current.shadow, corners: current.corners, backgroundColor: color, layoutMargins: current.layoutMargins)
            onChange(current)
        })

        // Border disclosure
        let borderDisclosure = EDisclosure()
        let _ = borderDisclosure.configure(with: .init(title: "border", isExpanded: false))
        let borderStack = EStack()
        let _ = borderStack.configure(with: .init(orientation: .vertical, spacing: 4))
        borderStack.addArrangedSubview(PropertyRow.slider(label: "width", value: Double(common.border.width), min: 0, max: 10, step: 0.5) { val in
            current = CommonViewModel(border: .init(width: CGFloat(val), color: current.border.color, style: current.border.style), shadow: current.shadow, corners: current.corners, backgroundColor: current.backgroundColor, layoutMargins: current.layoutMargins)
            onChange(current)
        })
        borderStack.addArrangedSubview(PropertyRow.colorDropdown(label: "color", selectedName: "clear") { _, color in
            current = CommonViewModel(border: .init(width: current.border.width, color: color, style: current.border.style), shadow: current.shadow, corners: current.corners, backgroundColor: current.backgroundColor, layoutMargins: current.layoutMargins)
            onChange(current)
        })
        let borderStyles = ["solid", "dashed"]
        let currentBorderStyle = common.border.style == .solid ? 0 : 1
        borderStack.addArrangedSubview(PropertyRow.dropdown(label: "style", options: borderStyles, selectedIndex: currentBorderStyle) { idx in
            let style: CommonViewModel.Border.Style = idx == 0 ? .solid : .dashed
            current = CommonViewModel(border: .init(width: current.border.width, color: current.border.color, style: style), shadow: current.shadow, corners: current.corners, backgroundColor: current.backgroundColor, layoutMargins: current.layoutMargins)
            onChange(current)
        })
        borderDisclosure.setContent(borderStack)
        stack.addArrangedSubview(borderDisclosure)

        // Corners disclosure
        let cornersDisclosure = EDisclosure()
        let _ = cornersDisclosure.configure(with: .init(title: "corners", isExpanded: false))
        let cornersStack = EStack()
        let _ = cornersStack.configure(with: .init(orientation: .vertical, spacing: 4))
        cornersStack.addArrangedSubview(PropertyRow.slider(label: "radius", value: Double(common.corners.radius), min: 0, max: 50, step: 1) { val in
            current = CommonViewModel(border: current.border, shadow: current.shadow, corners: .init(radius: CGFloat(val)), backgroundColor: current.backgroundColor, layoutMargins: current.layoutMargins)
            onChange(current)
        })
        cornersDisclosure.setContent(cornersStack)
        stack.addArrangedSubview(cornersDisclosure)

        // Shadow disclosure
        let shadowDisclosure = EDisclosure()
        let _ = shadowDisclosure.configure(with: .init(title: "shadow", isExpanded: false))
        let shadowStack = EStack()
        let _ = shadowStack.configure(with: .init(orientation: .vertical, spacing: 4))
        shadowStack.addArrangedSubview(PropertyRow.slider(label: "radius", value: Double(common.shadow.radius), min: 0, max: 30, step: 1) { val in
            current = CommonViewModel(border: current.border, shadow: .init(color: current.shadow.color, offset: current.shadow.offset, radius: CGFloat(val), opacity: current.shadow.opacity), corners: current.corners, backgroundColor: current.backgroundColor, layoutMargins: current.layoutMargins)
            onChange(current)
        })
        shadowStack.addArrangedSubview(PropertyRow.slider(label: "opacity", value: Double(common.shadow.opacity), min: 0, max: 1, step: 0.05) { val in
            current = CommonViewModel(border: current.border, shadow: .init(color: current.shadow.color, offset: current.shadow.offset, radius: current.shadow.radius, opacity: Float(val)), corners: current.corners, backgroundColor: current.backgroundColor, layoutMargins: current.layoutMargins)
            onChange(current)
        })
        shadowDisclosure.setContent(shadowStack)
        stack.addArrangedSubview(shadowDisclosure)

        // LayoutMargins disclosure
        let marginsDisclosure = EDisclosure()
        let _ = marginsDisclosure.configure(with: .init(title: "layoutMargins", isExpanded: false))
        let marginsStack = EStack()
        let _ = marginsStack.configure(with: .init(orientation: .vertical, spacing: 4))
        for (label, keyPath) in [("top", \NSEdgeInsets.top), ("left", \NSEdgeInsets.left), ("bottom", \NSEdgeInsets.bottom), ("right", \NSEdgeInsets.right)] {
            marginsStack.addArrangedSubview(PropertyRow.slider(label: label, value: Double(common.layoutMargins[keyPath: keyPath]), min: 0, max: 40, step: 2) { val in
                var margins = current.layoutMargins
                switch label {
                case "top": margins.top = CGFloat(val)
                case "left": margins.left = CGFloat(val)
                case "bottom": margins.bottom = CGFloat(val)
                case "right": margins.right = CGFloat(val)
                default: break
                }
                current = CommonViewModel(border: current.border, shadow: current.shadow, corners: current.corners, backgroundColor: current.backgroundColor, layoutMargins: margins)
                onChange(current)
            })
        }
        marginsDisclosure.setContent(marginsStack)
        stack.addArrangedSubview(marginsDisclosure)

        disclosure.setContent(stack)
        return disclosure
    }
}
```

- [ ] **Step 3: Собрать**

```bash
mise exec -- tuist generate --no-open && mise exec -- tuist build EmpDesignSystem
```

- [ ] **Step 4: Commit**

```bash
git add EmpDesignSystem/Sources/Inspector/
git commit -m "feat: реализовать Inspector с PropertyRow и рекурсивным CommonViewModel"
```

---

### Task 7: Связать Inspector с Preview

**Files:**
- Modify: `EmpDesignSystem/Sources/MainWindowController.swift`

- [ ] **Step 1: Интегрировать inspector в MainWindowController**

Добавить `inspectorBuilder` и связать data flow:

```swift
private let inspectorBuilder = InspectorBuilder()
private var inspectorView: NSView?

// В setup() — заменить заглушку inspector:
// Inspector placeholder — будет заменён при выборе компонента
let inspectorPlaceholder = EStack()
let _ = inspectorPlaceholder.configure(with: .init(common: .init(backgroundColor: .Semantic.backgroundSecondary), orientation: .vertical))
// Сохранить ссылку на панель inspector для замены
self.inspectorPanel = inspectorPlaceholder

// handleItemSelected:
private func handleItemSelected(_ item: CatalogItem) {
    guard let page = ComponentFactory.makePage(for: item) else { return }
    currentPage = page
    sidebarBuilder.selectItem(item.id)
    previewBuilder.showComponent(name: item.name, view: page.component)

    // Build inspector
    let inspector = inspectorBuilder.build(for: item, viewModel: page.defaultViewModel)
    inspectorBuilder.onViewModelChanged = { [weak self] newVM in
        self?.currentPage?.configure(self?.currentPage?.component ?? NSView(), newVM)
    }

    // Replace inspector panel content
    replaceInspectorContent(with: inspector)
}
```

Метод `replaceInspectorContent` удаляет все subview из inspector-панели и добавляет новый контент.

- [ ] **Step 2: Собрать и проверить**

```bash
mise exec -- tuist generate --no-open && mise exec -- tuist build EmpDesignSystem
```

- [ ] **Step 3: Commit**

```bash
git add EmpDesignSystem/Sources/
git commit -m "feat: связать Inspector с Preview — live обновление ViewModel"
```

---

### Task 8: Token Pages (showcase, не конструктор)

**Files:**
- Create: `EmpDesignSystem/Sources/ComponentPages/TokenPages.swift`

- [ ] **Step 1: Создать showcase страницы для токенов**

```swift
import Cocoa
import EmpUI_macOS

enum TokenPages {

    static func typography() -> NSView {
        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)),
            orientation: .vertical,
            spacing: 12
        ))

        for typo in EmpTypography.allCases {
            let label = EText()
            let _ = label.configure(with: .init(
                content: .plain(.init(
                    text: "\(typo) — \(typo.fontSize)pt / \(typo.lineHeight)pt",
                    font: typo.font,
                    color: .Semantic.textPrimary
                ))
            ))
            stack.addArrangedSubview(label)
        }
        return stack
    }

    static func colors() -> NSView {
        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)),
            orientation: .vertical,
            spacing: 8
        ))

        let semanticColors: [(String, NSColor)] = [
            ("textPrimary", .Semantic.textPrimary),
            ("textSecondary", .Semantic.textSecondary),
            ("textTertiary", .Semantic.textTertiary),
            ("textAccent", .Semantic.textAccent),
            ("backgroundPrimary", .Semantic.backgroundPrimary),
            ("backgroundSecondary", .Semantic.backgroundSecondary),
            ("actionPrimary", .Semantic.actionPrimary),
            ("actionSuccess", .Semantic.actionSuccess),
            ("actionWarning", .Semantic.actionWarning),
            ("actionDanger", .Semantic.actionDanger),
            ("actionInfo", .Semantic.actionInfo),
            ("borderDefault", .Semantic.borderDefault),
        ]

        for (name, color) in semanticColors {
            let row = EStack()
            let _ = row.configure(with: .init(orientation: .horizontal, spacing: 12))

            let swatch = EStack()
            let _ = swatch.configure(with: .init(
                common: .init(
                    border: .init(width: 1, color: .Semantic.borderDefault),
                    corners: .init(radius: 4),
                    backgroundColor: color
                )
            ))
            swatch.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                swatch.widthAnchor.constraint(equalToConstant: 32),
                swatch.heightAnchor.constraint(equalToConstant: 32),
            ])

            let label = EText()
            let _ = label.configure(with: .init(
                content: .plain(.init(text: name, font: .systemFont(ofSize: 13), color: .Semantic.textPrimary))
            ))

            row.addArrangedSubview(swatch)
            row.addArrangedSubview(label)
            stack.addArrangedSubview(row)
        }

        return stack
    }

    static func spacing() -> NSView {
        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)),
            orientation: .vertical,
            spacing: 8
        ))

        for spacing in EmpSpacing.allCases {
            let row = EStack()
            let _ = row.configure(with: .init(orientation: .horizontal, spacing: 12))

            let bar = EStack()
            let _ = bar.configure(with: .init(
                common: .init(corners: .init(radius: 2), backgroundColor: .Semantic.actionPrimary)
            ))
            bar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bar.widthAnchor.constraint(equalToConstant: spacing.rawValue),
                bar.heightAnchor.constraint(equalToConstant: 16),
            ])

            let label = EText()
            let _ = label.configure(with: .init(
                content: .plain(.init(text: "\(spacing) — \(spacing.rawValue)pt", font: .systemFont(ofSize: 12), color: .Semantic.textSecondary))
            ))

            row.addArrangedSubview(bar)
            row.addArrangedSubview(label)
            stack.addArrangedSubview(row)
        }

        return stack
    }

    static func opacity() -> NSView {
        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)),
            orientation: .vertical,
            spacing: 8
        ))

        for opacity in EmpOpacity.allCases {
            let row = EStack()
            let _ = row.configure(with: .init(orientation: .horizontal, spacing: 12))

            let swatch = EStack()
            let _ = swatch.configure(with: .init(
                common: .init(corners: .init(radius: 4), backgroundColor: .Semantic.actionPrimary)
            ))
            swatch.alphaValue = opacity.rawValue
            swatch.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                swatch.widthAnchor.constraint(equalToConstant: 32),
                swatch.heightAnchor.constraint(equalToConstant: 32),
            ])

            let label = EText()
            let _ = label.configure(with: .init(
                content: .plain(.init(text: "\(opacity) — \(opacity.rawValue)", font: .systemFont(ofSize: 12), color: .Semantic.textSecondary))
            ))

            row.addArrangedSubview(swatch)
            row.addArrangedSubview(label)
            stack.addArrangedSubview(row)
        }

        return stack
    }
}
```

- [ ] **Step 2: Интегрировать token pages в handleItemSelected**

В `MainWindowController.handleItemSelected`, добавить обработку token items:

```swift
// Перед guard let page = ComponentFactory.makePage
if let tokenView = makeTokenPage(for: item) {
    previewBuilder.showComponent(name: item.name, view: tokenView)
    replaceInspectorContent(with: makeNoInspectorView())
    return
}

private func makeTokenPage(for item: CatalogItem) -> NSView? {
    switch item.id {
    case "typography": return TokenPages.typography()
    case "colors": return TokenPages.colors()
    case "spacing": return TokenPages.spacing()
    case "opacity": return TokenPages.opacity()
    default: return nil
    }
}

private func makeNoInspectorView() -> NSView {
    let text = EText()
    let _ = text.configure(with: .init(
        common: .init(layoutMargins: NSEdgeInsets(top: 24, left: 12, bottom: 12, right: 12)),
        content: .plain(.init(text: "Token showcase — no inspector", font: .systemFont(ofSize: 12), color: .Semantic.textTertiary)),
        alignment: .center
    ))
    return text
}
```

- [ ] **Step 3: Собрать и проверить**

```bash
mise exec -- tuist generate --no-open && mise exec -- tuist build EmpDesignSystem
```

- [ ] **Step 4: Commit**

```bash
git add EmpDesignSystem/Sources/
git commit -m "feat: добавить showcase страницы токенов (typography, colors, spacing, opacity)"
```
