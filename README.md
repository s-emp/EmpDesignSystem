# EmpDesignSystem

Библиотека переиспользуемых UI-компонентов для iOS (UIKit) и macOS (AppKit).

## Установка

### Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/s-emp/EmpDesignSystem.git", from: "0.1.0")
]

// Target dependency:
.product(name: "EmpUI_iOS", package: "EmpDesignSystem")   // для iOS
.product(name: "EmpUI_macOS", package: "EmpDesignSystem")  // для macOS
```

### Tuist

```swift
// Tuist/Package.swift
.package(url: "https://github.com/s-emp/EmpDesignSystem.git", from: "0.1.0")

// Project.swift target dependency:
.external(name: "EmpUI_iOS")   // для iOS
.external(name: "EmpUI_macOS") // для macOS
```

### Xcode

File > Add Package Dependencies > `https://github.com/s-emp/EmpDesignSystem.git`

## Быстрый старт

```swift
import EmpUI_macOS  // или EmpUI_iOS

// Текст
let label = EText()
label.configure(with: .init(content: .plain(.init(text: "Hello"))))

// Кнопка (через ComponentDescriptor)
let button = ETapContainer()
let descriptor = ComponentDescriptor.ButtonPreset.filled(
    .primary,
    title: "Нажми",
    action: .init(id: "tap") { _ in print("tapped") }
)

// Прогресс-бар
let progress = EProgressBar()
progress.configure(with: .init(progress: 0.75, fillColor: NSColor.Semantic.actionSuccess))

// Картинка
let image = EImage()
let icon = NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil)!
image.configure(with: .init(
    image: icon,
    tintColor: NSColor.Semantic.actionPrimary,
    size: CGSize(width: 24, height: 24)
))
```

## Компоненты

| Компонент | Описание | Интерактивный |
|-----------|----------|---------------|
| [`EText`](docs/COMPONENTS.md#etext) | Текстовая метка (plain / attributed) | Нет |
| [`EImage`](docs/COMPONENTS.md#eimage) | Изображение с тонированием | Нет |
| [`EProgressBar`](docs/COMPONENTS.md#eprogressbar) | Линейный прогресс-бар (0–100%) | Нет |
| [`EInfoCard`](docs/COMPONENTS.md#einfocard) | Карточка с заголовком и значением | Нет |
| [`ESegmentControl`](docs/COMPONENTS.md#esegmentcontrol) | Сегментированный контрол | Да |
| [`ETapContainer`](docs/COMPONENTS.md#etapcontainer) | Контейнер с обработкой нажатий | Да |
| [`EStack`](docs/COMPONENTS.md#estack) | Стек-контейнер (горизонтальный/вертикальный) | Нет |
| [`ESpacer`](docs/COMPONENTS.md#espacer) | Пустое пространство | Нет |
| [`EScroll`](docs/COMPONENTS.md#escroll) | Скролл-контейнер | Нет |
| [`EOverlay`](docs/COMPONENTS.md#eoverlay) | Наложение вью друг на друга | Нет |

Полная документация по каждому компоненту: **[docs/COMPONENTS.md](docs/COMPONENTS.md)**

## Паттерн API

Каждый компонент следует единому паттерну:

```swift
let view = EComponent()
view.configure(with: .init(common: CommonViewModel(...), ...))
```

- `configure(with:)` — единственный публичный метод конфигурации
- Каждый ViewModel содержит `common: CommonViewModel` первым полем
- `CommonViewModel` управляет border, shadow, corners, background и layout margins
- `configure(with:)` возвращает `Self` — поддерживает цепочки вызовов

## Семантические цвета

Используйте `NSColor.Semantic.*` (macOS) или `UIColor.Semantic.*` (iOS):

| Группа | Токены |
|--------|--------|
| **Text** | `textPrimary`, `textSecondary`, `textTertiary`, `textAccent`, `textPrimaryInverted`, `textSecondaryInverted` |
| **Background** | `backgroundPrimary`, `backgroundSecondary`, `backgroundTertiary` |
| **Actions** | `actionPrimary`, `actionSuccess`, `actionWarning`, `actionDanger`, `actionInfo` |
| **Actions Hover** | `actionPrimaryHover`, `actionDangerHover` |
| **Actions Tint** | `actionPrimaryTint`, `actionDangerTint` |
| **Actions Base** | `actionPrimaryBase`, `actionPrimaryBaseHover`, `actionDangerBase`, `actionDangerBaseHover` |
| **Borders** | `borderDefault`, `borderSubtle` |
| **Cards** | `cardLavender`, `cardBorderLavender`, `cardMint`, `cardBorderMint`, `cardPeach`, `cardBorderPeach`, `cardRose`, `cardBorderRose`, `cardSky`, `cardBorderSky`, `cardLemon`, `cardBorderLemon`, `cardLilac`, `cardBorderLilac` |

## Токены отступов

`EmpSpacing` — enum с фиксированными значениями:

| Токен | Значение |
|-------|----------|
| `xxs` | 4 |
| `xs` | 8 |
| `s` | 12 |
| `m` | 16 |
| `l` | 20 |
| `xl` | 24 |
| `xxl` | 32 |
| `xxxl` | 40 |

## Различия платформ

| Аспект | macOS | iOS |
|--------|-------|-----|
| Import | `import EmpUI_macOS` | `import EmpUI_iOS` |
| Color | `NSColor.Semantic.*` | `UIColor.Semantic.*` |
| Image | `NSImage` | `UIImage` |
| Font | `NSFont` | `UIFont` |
| Margins | `NSEdgeInsets` | `UIEdgeInsets` |
| Stack Axis | `NSUserInterfaceLayoutOrientation` | `NSLayoutConstraint.Axis` |
| Stack Alignment | `NSLayoutConstraint.Attribute` | `UIStackView.Alignment` |

API компонентов идентичен на обеих платформах.
