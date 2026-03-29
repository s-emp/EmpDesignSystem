# Справочник компонентов EmpDesignSystem

> Примеры ниже используют macOS-типы (`NSColor`, `NSFont`, `NSImage`, `NSEdgeInsets`).
> Для iOS замените на `UIColor`, `UIFont`, `UIImage`, `UIEdgeInsets`.

---

## Содержание

- [Архитектура](#архитектура)
  - [EComponent Protocol](#ecomponent-protocol)
  - [CommonViewModel](#commonviewmodel)
  - [SizeViewModel](#sizeviewmodel)
  - [ControlParameter](#controlparameter)
  - [ComponentDescriptor](#componentdescriptor)
- [Компоненты](#компоненты)
  - [EText](#etext) — Текст
  - [EImage](#eimage) — Изображение
  - [EProgressBar](#eprogressbar) — Прогресс-бар
  - [EInfoCard](#einfocard) — Информационная карточка
  - [ESegmentControl](#esegmentcontrol) — Сегментированный контрол
  - [ETapContainer](#etapcontainer) — Контейнер нажатий
  - [EStack](#estack) — Стек
  - [ESpacer](#espacer) — Спейсер
  - [EScroll](#escroll) — Скролл
  - [EOverlay](#eoverlay) — Оверлей
- [Вспомогательные типы](#вспомогательные-типы)
  - [EmpSpacing](#empspacing)
  - [EmpGradient](#empgradient)
- [Best Practices](#best-practices)

---

## Архитектура

### EComponent Protocol

Все компоненты реализуют протокол `EComponent`:

```swift
public protocol EComponent: NSView {  // UIView на iOS
    associatedtype ViewModel: ComponentViewModel
    var viewModel: ViewModel { get }

    @discardableResult
    func configure(with viewModel: ViewModel) -> Self
}
```

Протокол `ComponentViewModel` требует:

```swift
public protocol ComponentViewModel: Equatable {
    var common: CommonViewModel { get }
}
```

### CommonViewModel

Общие стили, применяемые к каждому компоненту через `apply(common:)`.

```swift
CommonViewModel(
    border: .init(width: 1, color: NSColor.Semantic.borderDefault, style: .solid),
    shadow: .init(color: .black, offset: CGSize(width: 0, height: 2), radius: 4, opacity: 0.1),
    corners: .init(radius: 8, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]),
    backgroundColor: NSColor.Semantic.backgroundSecondary,
    layoutMargins: NSEdgeInsets(top: 8, left: 12, bottom: 8, right: 12),
    size: SizeViewModel(width: .fill, height: .fixed(44))
)
```

Все поля имеют значения по умолчанию (без border, без shadow, без radius, прозрачный фон, нулевые отступы, hug-размер).

#### Border

| Свойство | Тип | По умолчанию |
|----------|-----|-------------|
| `width` | `CGFloat` | `0` |
| `color` | `NSColor` | `.clear` |
| `style` | `Style` | `.solid` |

Стили: `.solid` — сплошная линия, `.dashed` — пунктир (паттерн 6/4).

#### Shadow

| Свойство | Тип | По умолчанию |
|----------|-----|-------------|
| `color` | `NSColor` | `.clear` |
| `offset` | `CGSize` | `.zero` |
| `radius` | `CGFloat` | `0` |
| `opacity` | `Float` | `0` |

#### Corners

| Свойство | Тип | По умолчанию |
|----------|-----|-------------|
| `radius` | `CGFloat` | `0` |
| `maskedCorners` | `CACornerMask` | Все 4 угла |

Маска углов: `.layerMinXMinYCorner` (верхний левый), `.layerMaxXMinYCorner` (верхний правый), `.layerMinXMaxYCorner` (нижний левый), `.layerMaxXMaxYCorner` (нижний правый).

### SizeViewModel

Управляет размером компонента.

```swift
SizeViewModel(
    width: .fill,       // заполнить доступное пространство
    height: .fixed(44)  // фиксированная высота
)
```

| Режим | Описание |
|-------|----------|
| `.hug` | Обтягивает контент (по умолчанию). hugging=751, resistance=752 |
| `.fill` | Заполняет доступное пространство. hugging=1, resistance=752 |
| `.fixed(CGFloat)` | Фиксированный размер. Constraint priority=1000 |

### ControlParameter

Обобщённый тип для хранения значений под разные состояния контрола:

```swift
let bgColor = ControlParameter<NSColor>(
    normal: .systemBlue,
    hover: .systemBlue.withAlphaComponent(0.8),     // nil = normal
    highlighted: .systemBlue.withAlphaComponent(0.6), // nil = normal
    disabled: .systemGray                             // nil = normal
)

// Доступ по состоянию
bgColor[.normal]      // .systemBlue
bgColor[.highlighted] // .systemBlue с alpha 0.6
```

Состояния (`ControlState`): `.normal`, `.hover`, `.highlighted`, `.disabled`.

### ComponentDescriptor

Декларативное дерево компонентов — позволяет описать иерархию вью без ручного создания:

```swift
public enum ComponentDescriptor: Equatable {
    // Листовые
    case text(EText.ViewModel)
    case image(EImage.ViewModel)
    case progressBar(EProgressBar.ViewModel)

    // Составные
    case infoCard(EInfoCard.ViewModel)
    case segmentControl(ESegmentControl.ViewModel)

    // Контейнеры
    indirect case stack(EStack.ViewModel, [ComponentDescriptor])
    indirect case overlay(EOverlay.ViewModel, [ComponentDescriptor])
    case spacer(ESpacer.ViewModel)
    indirect case scroll(EScroll.ViewModel, ComponentDescriptor)
    indirect case tap(ETapContainer.ViewModel, ControlParameter<ComponentDescriptor>)
}
```

Пример использования:

```swift
let card: ComponentDescriptor = .stack(
    .init(axis: .vertical, spacing: EmpSpacing.s.rawValue),
    [
        .text(.init(content: .plain(.init(text: "Заголовок", font: .boldSystemFont(ofSize: 18))))),
        .text(.init(content: .plain(.init(text: "Описание", color: NSColor.Semantic.textSecondary)))),
        .progressBar(.init(progress: 0.7)),
    ]
)
```

---

## Компоненты

---

### EText

Текстовая метка с поддержкой plain и attributed строк.

#### ViewModel

| Свойство | Тип | По умолчанию | Обязательно |
|----------|-----|-------------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` | Нет |
| `content` | `Content` | — | **Да** |
| `numberOfLines` | `Int` | `0` (без ограничения) | Нет |
| `alignment` | `NSTextAlignment` | `.natural` | Нет |

#### Content

```swift
enum Content: Equatable {
    case plain(PlainText)
    case attributed(NSAttributedString)
}

struct PlainText: Equatable {
    let text: String           // обязательно
    let font: NSFont           // .systemFont(ofSize: 14)
    let color: NSColor         // NSColor.Semantic.textPrimary
}
```

#### Примеры

```swift
let text = EText()

// Простой текст
text.configure(with: .init(
    content: .plain(.init(text: "Привет мир"))
))

// Жирный заголовок
text.configure(with: .init(
    content: .plain(.init(
        text: "Заголовок",
        font: .boldSystemFont(ofSize: 24)
    ))
))

// Однострочный с обрезкой
text.configure(with: .init(
    content: .plain(.init(text: "Очень длинный текст...")),
    numberOfLines: 1
))

// По центру
text.configure(with: .init(
    content: .plain(.init(text: "Центр")),
    alignment: .center
))

// Attributed
let attr = NSAttributedString(string: "Подчёркнутый", attributes: [
    .underlineStyle: NSUnderlineStyle.single.rawValue
])
text.configure(with: .init(content: .attributed(attr)))
```

---

### EImage

Отображение изображений с опциональным тонированием.

#### ViewModel

| Свойство | Тип | По умолчанию | Обязательно |
|----------|-----|-------------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` | Нет |
| `image` | `NSImage` | — | **Да** |
| `tintColor` | `NSColor?` | `nil` | Нет |
| `size` | `CGSize` | — | **Да** |
| `contentMode` | `ContentMode` | `.aspectFit` | Нет |

#### ContentMode

| Режим | Описание |
|-------|----------|
| `.aspectFit` | Вписать в размер, сохраняя пропорции |
| `.aspectFill` | Заполнить размер, сохраняя пропорции |
| `.center` | По центру без масштабирования |

#### Примеры

```swift
let image = EImage()

// SF Symbol с тонированием
let icon = NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil)!
image.configure(with: .init(
    image: icon,
    tintColor: NSColor.Semantic.actionPrimary,
    size: CGSize(width: 24, height: 24)
))

// Без тонирования
image.configure(with: .init(
    image: icon,
    size: CGSize(width: 32, height: 32)
))

// С общими стилями (рамка, скругление, отступы)
image.configure(with: .init(
    common: .init(
        border: .init(width: 1, color: NSColor.Semantic.borderDefault),
        corners: .init(radius: 8),
        backgroundColor: NSColor.Semantic.backgroundSecondary,
        layoutMargins: NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    ),
    image: icon,
    tintColor: NSColor.Semantic.actionPrimary,
    size: CGSize(width: 32, height: 32)
))
```

---

### EProgressBar

Линейный прогресс-бар.

#### ViewModel

| Свойство | Тип | По умолчанию | Обязательно |
|----------|-----|-------------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` | Нет |
| `progress` | `CGFloat` | `0` | Нет |
| `trackColor` | `NSColor` | `.Semantic.backgroundTertiary` | Нет |
| `fillColor` | `NSColor` | `.Semantic.actionPrimary` | Нет |
| `barHeight` | `CGFloat` | `4` | Нет |

> `progress` автоматически clamped в диапазон [0, 1].

#### Примеры

```swift
let bar = EProgressBar()

// Базовый
bar.configure(with: .init(progress: 0.75))

// Кастомные цвета
bar.configure(with: .init(
    progress: 0.4,
    fillColor: NSColor.Semantic.actionSuccess,
    barHeight: 8
))

// Danger-стиль
bar.configure(with: .init(
    progress: 0.9,
    fillColor: NSColor.Semantic.actionDanger,
    barHeight: 6
))
```

---

### EInfoCard

Информационная карточка с подзаголовком и крупным значением. Поддерживает сплошной фон и градиент.

#### ViewModel

| Свойство | Тип | По умолчанию | Обязательно |
|----------|-----|-------------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` | Нет |
| `subtitle` | `String` | — | **Да** |
| `value` | `String` | — | **Да** |
| `subtitleColor` | `NSColor` | `.Semantic.textSecondary` | Нет |
| `subtitleFont` | `NSFont` | `.systemFont(ofSize: 11, weight: .medium)` | Нет |
| `valueColor` | `NSColor` | `.Semantic.textPrimary` | Нет |
| `valueFont` | `NSFont` | `.systemFont(ofSize: 24, weight: .bold)` | Нет |
| `background` | `Background` | `.color(.Semantic.backgroundSecondary)` | Нет |
| `spacing` | `CGFloat` | `EmpSpacing.xs` (8) | Нет |

#### Background

```swift
enum Background: Equatable {
    case color(NSColor)
    case gradient(EmpGradient)
}
```

#### Presets

```swift
// Стандартная карточка (radius: 12, margins: m)
EInfoCard.Preset.default(subtitle: "Total Time", value: "12h 15m")

// С градиентом (белый текст, radius: 12, margins: m)
EInfoCard.Preset.gradient(
    subtitle: "Sessions",
    value: "42",
    gradient: .Preset.lavenderToSky
)
```

#### Примеры

```swift
let card = EInfoCard()

// Через Preset
card.configure(with: .Preset.default(subtitle: "Total Time", value: "12h 15m"))

// С градиентом
card.configure(with: .Preset.gradient(
    subtitle: "Sessions",
    value: "42",
    gradient: .Preset.lavenderToSky
))

// Полностью кастомная
card.configure(with: .init(
    common: .init(
        corners: .init(radius: 16),
        layoutMargins: NSEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
    ),
    subtitle: "Active Apps",
    value: "5",
    subtitleColor: NSColor.Semantic.textSecondary,
    valueColor: NSColor.Semantic.actionPrimary,
    valueFont: .systemFont(ofSize: 32, weight: .bold),
    background: .color(NSColor.Semantic.cardLavender)
))
```

---

### ESegmentControl

Сегментированный контрол с переключением секций.

#### ViewModel

| Свойство | Тип | По умолчанию | Обязательно |
|----------|-----|-------------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` | Нет |
| `segments` | `[String]` | — | **Да** |
| `font` | `NSFont` | `.systemFont(ofSize: 13, weight: .medium)` | Нет |
| `selectedSegmentTintColor` | `NSColor?` | `nil` | Нет |

#### Публичный API

```swift
// Конфигурация
segmentControl.configure(with: viewModel)

// Программный выбор
segmentControl.select(index: 1)

// Текущий выбранный индекс
segmentControl.selectedIndex  // Int, read-only

// Обработка выбора
segmentControl.onSelectionChanged = { index in
    print("Выбран сегмент \(index)")
}
```

#### Preset

```swift
// Стандартный с отступами 4pt
ESegmentControl.Preset.default(segments: ["Day", "Week", "Month"])
```

#### Примеры

```swift
let segment = ESegmentControl()

// Через Preset
segment.configure(with: .Preset.default(segments: ["Day", "Week", "Month"]))

// С кастомным цветом
segment.configure(with: .init(
    segments: ["On", "Off"],
    selectedSegmentTintColor: .systemBlue
))

// Обработка выбора
segment.onSelectionChanged = { index in
    print("Selected: \(index)")
}

// Программный выбор
segment.select(index: 1)
```

---

### ETapContainer

Интерактивный контейнер с обработкой нажатий и поддержкой состояний (normal, hover, highlighted, disabled).

#### ViewModel

| Свойство | Тип | По умолчанию | Обязательно |
|----------|-----|-------------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` | Нет |
| `action` | `Action` | — | **Да** |

#### Action

```swift
public struct Action: Equatable {
    let id: String                                      // уникальный ID
    var handler: (ETapContainer.ViewModel) -> Void      // обработчик нажатия

    // Equatable по id
}
```

#### Публичный API

```swift
// Конфигурация
tapContainer.configure(with: viewModel)

// Установить контент
tapContainer.setContent(myView)

// Текущий контент
tapContainer.contentView  // NSView?, read-only

// Включение/выключение
tapContainer.isEnabled = false

// Текущее состояние
tapContainer.currentState  // ControlState

// Обработка смены состояния
tapContainer.onStateChange = { state in
    // state: .normal, .hover, .highlighted, .disabled
}
```

#### ButtonPreset

Готовый пресет для создания кнопок через `ComponentDescriptor`:

```swift
ComponentDescriptor.ButtonPreset.filled(
    _ color: ColorVariant,        // .primary, .danger
    title: String,
    icon: UIImage? = nil,
    size: Size = .medium,         // .small, .medium, .large
    action: ETapContainer.ViewModel.Action
) -> ComponentDescriptor
```

Размеры кнопок:

| Размер | Высота | Шрифт | Иконка | Radius | Отступы |
|--------|--------|-------|--------|--------|---------|
| `.small` | 36 | 12pt medium | 16×16 | 6 | xs/s |
| `.medium` | 44 | 14pt medium | 20×20 | 8 | s/m |
| `.large` | 50 | 16pt medium | 24×24 | 10 | m/l |

Цвета: `.primary` (actionPrimary), `.danger` (actionDanger).

Пример:

```swift
let buttonDescriptor = ComponentDescriptor.ButtonPreset.filled(
    .primary,
    title: "Сохранить",
    icon: NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil),
    size: .medium,
    action: .init(id: "save") { _ in print("Saved!") }
)
```

---

### EStack

Контейнер для горизонтальной или вертикальной укладки дочерних вью.

#### ViewModel

| Свойство | Тип (macOS) | Тип (iOS) | По умолчанию |
|----------|-------------|-----------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel` | `CommonViewModel()` |
| `orientation` / `axis` | `NSUserInterfaceLayoutOrientation` | `NSLayoutConstraint.Axis` | `.horizontal` |
| `spacing` | `CGFloat` | `CGFloat` | `0` |
| `alignment` | `NSLayoutConstraint.Attribute` | `UIStackView.Alignment` | `.centerY` / `.fill` |
| `distribution` | `NSStackView.Distribution` | `UIStackView.Distribution` | `.fill` |

#### Примеры

```swift
let stack = EStack()

// Горизонтальный стек
stack.configure(with: .init(
    orientation: .horizontal,  // .axis на iOS
    spacing: EmpSpacing.s.rawValue,
    alignment: .centerY        // .center на iOS
))

// Вертикальный стек с отступами
stack.configure(with: .init(
    common: .init(
        layoutMargins: NSEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
    ),
    orientation: .vertical,
    spacing: EmpSpacing.m.rawValue
))
```

---

### ESpacer

Пустое пространство — фиксированное или гибкое.

#### ViewModel

| Свойство | Тип (macOS) | По умолчанию |
|----------|-------------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` |
| `length` | `CGFloat?` | `nil` (гибкий) |
| `orientation` / `axis` | `NSUserInterfaceLayoutOrientation` / `NSLayoutConstraint.Axis` | `.horizontal` |

#### Примеры

```swift
let spacer = ESpacer()

// Гибкий (растянется на доступное пространство)
spacer.configure(with: .init())

// Фиксированный
spacer.configure(with: .init(length: 20))
```

---

### EScroll

Скролл-контейнер.

#### ViewModel

| Свойство | Тип (macOS) | По умолчанию |
|----------|-------------|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` |
| `orientation` / `axis` | `NSUserInterfaceLayoutOrientation` / `NSLayoutConstraint.Axis` | `.vertical` |
| `showsIndicators` | `Bool` | `true` |

#### Примеры

```swift
let scroll = EScroll()

// Вертикальный скролл (по умолчанию)
scroll.configure(with: .init())

// Горизонтальный без индикаторов
scroll.configure(with: .init(
    orientation: .horizontal,
    showsIndicators: false
))
```

---

### EOverlay

Контейнер для наложения дочерних вью друг на друга (Z-стек).

#### ViewModel

| Свойство | Тип | По умолчанию |
|----------|-----|-------------|
| `common` | `CommonViewModel` | `CommonViewModel()` |

#### Пример

```swift
let overlay = EOverlay()
overlay.configure(with: .init(
    common: .init(corners: .init(radius: 12))
))
```

---

## Вспомогательные типы

### EmpSpacing

Дизайн-токены для отступов:

```swift
public enum EmpSpacing: CGFloat {
    case xxs = 4
    case xs = 8
    case s = 12
    case m = 16
    case l = 20
    case xl = 24
    case xxl = 32
    case xxxl = 40
}
```

Удобный инициализатор для `NSEdgeInsets`:

```swift
NSEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)  // все по 16
NSEdgeInsets(top: .xs, left: .s, bottom: .xs, right: .s) // 8, 12, 8, 12
```

### EmpGradient

Пары цветов для градиентов:

```swift
public struct EmpGradient: Equatable {
    let startColor: NSColor
    let endColor: NSColor

    func resolvedColors(for appearance: NSAppearance) -> (start: CGColor, end: CGColor)
    // iOS: resolvedColors(for traitCollection: UITraitCollection)
}
```

#### Готовые градиенты

**Мягкие (step 200):**
- `.Preset.lavenderToSky`
- `.Preset.skyToMint`
- `.Preset.peachToRose`
- `.Preset.roseToLilac`

**Насыщенные (step 300):**
- `.Preset.lavenderToLilac`
- `.Preset.lemonToPeach`
- `.Preset.lavenderToMint`
- `.Preset.skyToLavender`

---

## Best Practices

### 1. Используйте Presets когда возможно

Presets инкапсулируют рекомендованные комбинации стилей:

```swift
// Хорошо — Preset задаёт правильные отступы, скругления и цвета
card.configure(with: .Preset.default(subtitle: "Time", value: "5h"))

// Плохо — ручная конфигурация, легко забыть radius или margins
card.configure(with: .init(subtitle: "Time", value: "5h"))
```

### 2. CommonViewModel — только для стилей оболочки

`CommonViewModel` управляет border, shadow, corners, background и margins самого вью. Контент настраивается через остальные поля ViewModel:

```swift
// Хорошо — стили оболочки в common, контент отдельно
EText.ViewModel(
    common: .init(
        backgroundColor: NSColor.Semantic.backgroundSecondary,
        layoutMargins: NSEdgeInsets(top: .xs, left: .s, bottom: .xs, right: .s)
    ),
    content: .plain(.init(text: "Hello", font: .boldSystemFont(ofSize: 18)))
)
```

### 3. Используйте EmpSpacing для консистентности

Всегда используйте токены `EmpSpacing` вместо магических чисел:

```swift
// Хорошо
NSEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
EStack.ViewModel(spacing: EmpSpacing.s.rawValue)

// Плохо
NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
EStack.ViewModel(spacing: 12)
```

### 4. Используйте семантические цвета

Семантические цвета автоматически адаптируются к тёмной/светлой теме:

```swift
// Хорошо — адаптируется к теме
NSColor.Semantic.textPrimary
NSColor.Semantic.backgroundSecondary
NSColor.Semantic.actionPrimary

// Плохо — не адаптируется к теме
NSColor.black
NSColor.white
NSColor.systemBlue
```

### 5. SizeViewModel для управления размером

Используйте `SizeViewModel` вместо ручных constraints:

```swift
// Хорошо — размер через ViewModel
CommonViewModel(size: SizeViewModel(width: .fill, height: .fixed(44)))

// Плохо — ручные constraints
view.widthAnchor.constraint(equalTo: superview.widthAnchor)
view.heightAnchor.constraint(equalToConstant: 44)
```

### 6. ComponentDescriptor для сложных иерархий

Для построения деревьев компонентов используйте `ComponentDescriptor` вместо ручной композиции:

```swift
// Хорошо — декларативное описание
let row: ComponentDescriptor = .stack(
    .init(orientation: .horizontal, spacing: EmpSpacing.s.rawValue, alignment: .centerY),
    [
        .image(.init(image: icon, tintColor: NSColor.Semantic.actionPrimary, size: CGSize(width: 20, height: 20))),
        .text(.init(content: .plain(.init(text: "Название")))),
        .spacer(.init()),
        .text(.init(content: .plain(.init(text: "Значение", color: NSColor.Semantic.textSecondary)))),
    ]
)
```

### 7. #Preview с UIKit/AppKit

В `#Preview` макросе обязательно оборачивайте `configure(with:)` через `let _ =`:

```swift
#Preview("EText — Bold") {
    let text = EText()
    let _ = text.configure(with: .init(
        content: .plain(.init(text: "Bold", font: .boldSystemFont(ofSize: 24)))
    ))
    text
}
```

Не используйте `return` — result builders его запрещают.

### 8. ControlParameter для интерактивных состояний

При работе с `ETapContainer` используйте `ControlParameter` для описания вариантов под разные состояния:

```swift
let descriptor: ComponentDescriptor = .tap(
    .init(action: .init(id: "my-action") { _ in }),
    ControlParameter(
        normal: .text(.init(content: .plain(.init(text: "Кнопка", color: .systemBlue)))),
        highlighted: .text(.init(content: .plain(.init(text: "Кнопка", color: .systemBlue.withAlphaComponent(0.5))))),
        disabled: .text(.init(content: .plain(.init(text: "Кнопка", color: .systemGray))))
    )
)
```

Если hover/highlighted/disabled не указаны — используется `normal`.

### 9. Один компонент — один configure()

Не вызывайте `configure(with:)` повторно без необходимости. Каждый вызов полностью пересоздаёт внутреннее состояние:

```swift
// Хорошо — один раз собрали ViewModel, один раз сконфигурировали
let viewModel = EText.ViewModel(content: .plain(.init(text: "Hello")))
text.configure(with: viewModel)

// Плохо — множественные вызовы configure
text.configure(with: .init(content: .plain(.init(text: "Hello"))))
text.configure(with: .init(content: .plain(.init(text: "Hello", font: .boldSystemFont(ofSize: 18)))))
```

### 10. Контент привязан к layoutMarginsGuide

Содержимое компонентов всегда привязано к `layoutMarginsGuide` (iOS) или `empLayoutMarginsGuide` (macOS), а не к краям вью. Отступы управляются через `CommonViewModel.layoutMargins`.
