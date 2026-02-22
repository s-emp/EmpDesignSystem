# EmpButton v2 — Конфигурируемая кнопка

## Цель

Полностью кастомная кнопка с гибким контентом, тремя стилями, двумя цветовыми вариантами, тремя размерами и четырьмя состояниями. Идентичная функциональность на iOS и macOS.

## Архитектура

- **iOS:** наследуем от `UIControl` (даёт `addTarget`, `isHighlighted`, `isEnabled`)
- **macOS:** наследуем от `NSView` + `NSTrackingArea` (mouseDown/mouseUp/mouseEntered/mouseExited)
- Внутри: UILabel/NSTextField для текста, UIImageView/NSImageView для иконок
- `ViewModel` с `common: CommonViewModel` как у всех компонентов
- Content-элементы привязаны к `layoutMarginsGuide` (iOS) / `empLayoutMarginsGuide` (macOS)

## ViewModel

```swift
public struct ViewModel {
    public let common: CommonViewModel
    public let content: Content
    public let style: Style
    public let colorVariant: ColorVariant
    public let size: Size
    public let isEnabled: Bool

    public enum Style { case filled, outlined, ghost }
    public enum ColorVariant { case primary, danger }
    public enum Size { case small, medium, large }
}
```

## Content — struct с тремя слотами

```swift
public struct Content {
    public let leading: Element?
    public let center: Element?
    public let trailing: Element?

    public enum Element {
        case icon(UIImage)                                    // NSImage on macOS
        case text(String)
        case titleSubtitle(title: String, subtitle: String)
    }
}
```

Примеры:
- `Content(center: .text("Сохранить"))` — только текст
- `Content(leading: .icon(lock), center: .text("Войти"))` — иконка + текст
- `Content(center: .text("Далее"), trailing: .icon(arrow))` — текст + иконка
- `Content(leading: .icon(user), center: .titleSubtitle(title: "Профиль", subtitle: "Настройки"))` — сложный
- `Content(center: .icon(img))` — только иконка

## Стили

| Стиль | Фон | Рамка | Текст/иконка |
|-------|-----|-------|--------------|
| Filled | цвет темы | нет | белый |
| Outlined | прозрачный | цвет темы (1pt) | цвет темы |
| Ghost | прозрачный | нет | цвет темы |

## Цветовые варианты

| Вариант | Цвет (iOS) | Цвет (macOS) |
|---------|-----------|-------------|
| Primary | UIColor.Semantic.actionPrimary (lavender500) | NSColor.Semantic.actionPrimary |
| Danger | UIColor.Semantic.actionDanger (rose500) | NSColor.Semantic.actionDanger |

## Размеры (адаптированы под платформу)

### iOS

| Size | Высота | Шрифт | Иконка | Паддинг (v/h) | Скругление | Spacing |
|------|--------|-------|--------|---------------|------------|---------|
| S | 36pt | .systemFont(12, .semibold) | 14pt | xs(8) / s(12) | 6pt | xs(8) |
| M | 44pt | .systemFont(14, .semibold) | 16pt | s(12) / m(16) | 8pt | xs(8) |
| L | 50pt | .systemFont(16, .semibold) | 20pt | m(16) / l(20) | 10pt | s(12) |

### macOS

| Size | Высота | Шрифт | Иконка | Паддинг (v/h) | Скругление | Spacing |
|------|--------|-------|--------|---------------|------------|---------|
| S | 24pt | .systemFont(11, .semibold) | 12pt | xxs(4) / xs(8) | 4pt | xxs(4) |
| M | 32pt | .systemFont(13, .semibold) | 14pt | xs(8) / s(12) | 6pt | xs(8) |
| L | 40pt | .systemFont(14, .semibold) | 16pt | s(12) / m(16) | 8pt | xs(8) |

## Состояния

| Состояние | Filled | Outlined | Ghost |
|-----------|--------|----------|-------|
| Normal | базовый вид | базовый вид | базовый вид |
| Hover (macOS) | осветление фона | добавление tint фона | добавление tint фона |
| Pressed | opacity 0.7 | opacity 0.7 | opacity 0.7 |
| Disabled | opacity 0.4 | opacity 0.4 | opacity 0.4 |

## Layout внутри кнопки

```
EmpButton (UIControl / NSView)
  └── contentStack (UIStackView / NSStackView, horizontal)
        ├── leading element (icon / text / titleSubtitle) — optional
        ├── center element — optional
        └── trailing element — optional
```

- Stack axis: horizontal, alignment: center
- Spacing между элементами: определяется Size
- Высота фиксирована по Size, ширина = intrinsic (по контенту)
- `titleSubtitle` — вертикальный вложенный стек (title сверху, subtitle снизу)

## Файловая структура

```
EmpUI_iOS/Sources/Components/EmpButton.swift              — основной класс
EmpUI_iOS/Sources/Components/EmpButton+ViewModel.swift     — ViewModel struct
EmpUI_iOS/Sources/Components/EmpButton+Content.swift       — Content struct + Element enum
EmpUI_iOS/Sources/Preview/EmpButton+Preview.swift          — #Preview

EmpUI_macOS/Sources/Components/EmpButton.swift             — основной класс
EmpUI_macOS/Sources/Components/EmpButton+ViewModel.swift   — ViewModel struct
EmpUI_macOS/Sources/Components/EmpButton+Content.swift     — Content struct + Element enum
EmpUI_macOS/Sources/Preview/EmpButton+Preview.swift        — #Preview
```
