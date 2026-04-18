# Design System — Architecture Notes

## Terminology

| Термин | Определение |
|---|---|
| **Design Tokens** | Именованные константы. Просто данные, без UIKit/AppKit зависимостей. Цвета, типографика, отступы и тд |
| **Base Components** | Листовые UI-элементы. Атомарны, не делятся на более мелкие части |
| **Interactions** | Поведение. Отдельный слой — не токены |

---

## Layer 1: Design Tokens

Токены живут в `Common/` директории каждого таргета (`EmpUI_iOS`, `EmpUI_macOS`). Платформенно-зависимы (`UIColor`/`NSColor`, `UIEdgeInsets`/`NSEdgeInsets`).

### Colors

Двухуровневая схема. Компоненты ссылаются **только** на semantic-токены.

**Base (primitive) палитры** — `UIColor.Base` / `NSColor.Base`:

```
Neutral:    neutral50, neutral100, neutral200, neutral300, neutral500, neutral700, neutral900
            neutralInverted900, neutralInverted500
Chromatic (7 палитр, каждая: 50, 100, 200, 300, 500):
            lavender, mint, peach, rose, sky, lemon, lilac
```

**Semantic токены** — `UIColor.Semantic` / `NSColor.Semantic`:

```
Backgrounds:    backgroundPrimary, backgroundSecondary, backgroundTertiary
Cards:          cardLavender/cardBorderLavender, cardMint/cardBorderMint,
                cardPeach/cardBorderPeach, cardRose/cardBorderRose,
                cardSky/cardBorderSky, cardLemon/cardBorderLemon,
                cardLilac/cardBorderLilac
Borders:        borderDefault (neutral200), borderSubtle (neutral100)
Text:           textPrimary (neutral900), textSecondary (neutral500),
                textTertiary (neutral300), textAccent (lavender500),
                textPrimaryInverted (neutralInverted900),
                textSecondaryInverted (neutralInverted500)
Actions:        actionPrimary (lavender500), actionSuccess (mint500),
                actionWarning (peach500), actionDanger (rose500),
                actionInfo (sky500),
                actionPrimaryHover (lavender300), actionDangerHover (rose300),
                actionPrimaryTint (lavender50), actionDangerTint (rose50),
                actionPrimaryBase (neutral100), actionPrimaryBaseHover (neutral200),
                actionDangerBase (rose50), actionDangerBaseHover (rose100)
```

### Gradients — `EmpGradient`

```swift
public struct EmpGradient: Equatable {
    public let startColor: UIColor/NSColor
    public let endColor: UIColor/NSColor
}
```

**Пресеты** — `EmpGradient.Preset`:

```
Soft (шаг 200):       lavenderToSky, skyToMint, peachToRose, roseToLilac
Saturated (шаг 300):  lavenderToLilac, lemonToPeach, lavenderToMint, skyToLavender
```

### Typography

> ⚠️ **TODO:** Продумать и реализовать токены типографики (размеры, веса, line height, text styles).

### Spacing — `EmpSpacing`

База — **4pt**.

```swift
public enum EmpSpacing: CGFloat {
    case xxs  = 4
    case xs   = 8
    case s    = 12
    case m    = 16
    case l    = 20
    case xl   = 24
    case xxl  = 32
    case xxxl = 40
}
```

Расширения: `UIEdgeInsets(top: EmpSpacing, ...)`, `NSEdgeInsets(top: EmpSpacing, ...)`.

### Shape — `CommonViewModel.Corners`

```swift
public struct Corners: Equatable {
    public let radius: CGFloat            // default: 0
    public let maskedCorners: CACornerMask // default: все 4 угла
}
```

> ⚠️ **TODO:** Добавить именованные пресеты радиусов (none, xs, sm, md, lg, xl, full).

### Shadow — `CommonViewModel.Shadow`

```swift
public struct Shadow: Equatable {
    public let color: UIColor/NSColor  // default: .clear
    public let offset: CGSize          // default: .zero
    public let radius: CGFloat         // default: 0
    public let opacity: Float          // default: 0
}
```

> ⚠️ **TODO:** Добавить именованные пресеты elevation (none, xs, sm, md, lg).

### Border — `CommonViewModel.Border`

```swift
public struct Border: Equatable {
    public let width: CGFloat          // default: 0
    public let color: UIColor/NSColor  // default: .clear
    public let style: Style            // default: .solid

    public enum Style {
        case solid
        case dashed
    }
}
```

### Control States — `ControlParameter<T>`

```swift
public enum ControlState {
    case normal
    case hover
    case highlighted
    case disabled
}

public struct ControlParameter<T> {
    public let normal: T
    public let hover: T        // default: normal
    public let highlighted: T  // default: normal
    public let disabled: T     // default: normal
}
// Доступ: parameter[.hover]
```

### Opacity

> ⚠️ **TODO:** Продумать и реализовать токены прозрачности (disabled, muted, full).

### Animation

> ⚠️ **TODO:** Продумать и реализовать токены анимации (duration, easing).

### Структура модуля токенов (текущая)

```
Common/
├── CommonViewModel.swift
├── CommonViewModel+Border.swift
├── CommonViewModel+Shadow.swift
├── CommonViewModel+Corners.swift
├── EmpSpacing.swift
├── ControlParameter.swift
├── UIView+CommonViewModel.swift          (iOS)
├── NSView+CommonViewModel.swift          (macOS)
├── UIEdgeInsets+EmpSpacing.swift          (iOS)
├── NSEdgeInsets+EmpSpacing.swift          (macOS)
├── NSEdgeInsets+Equatable.swift           (macOS)
└── Colors/
    ├── UIColor+Base.swift / NSColor+Base.swift
    ├── UIColor+Neutral.swift / NSColor+Neutral.swift
    ├── UIColor+Lavender.swift / NSColor+Lavender.swift
    ├── ... (mint, peach, rose, sky, lemon, lilac)
    ├── UIColor+Semantic.swift / NSColor+Semantic.swift
    └── EmpGradient.swift
```

---

## Layer 2: Base Components

### Платформенная стратегия

**Вариант A — общий протокол, две реализации:**

```
ComponentProtocol
    ├── UIKitComponent    (UIKit)
    └── AppKitComponent   (AppKit)
```

Поведение платформ слишком различается чтобы прятать это за `#if canImport`.

---

### Группа 1: Content Views

*Листовые узлы. Отображают данные, не имеют дочерних компонентов.*

| Компонент | Описание |
|---|---|
| `EmpText` | Одно- и многострочный текст |
| `EmpRichLabel` | Attributed text: ссылки, смешанные стили |
| `EmpIcon` | SF Symbols или кастомный SVG. Живёт в pt-сетке, принимает `color.content.*` |
| `EmpImage` | Фото, иллюстрация. Aspect ratio, не принимает color-токены |
| `EmpAnimationView` | Lottie |
| `EmpActivityIndicator` | Спиннер |
| `EmpProgressBar` | Линейный прогресс |
| `EmpDivider` | Разделитель |

> **Icon vs Image:** разные источники, разный sizing, разные токены цвета.

---

### Группа 2: Layout Containers

*Управляют расположением дочерних элементов. Сами по себе невидимы.*

| Компонент | Описание |
|---|---|
| `EmpStackContainer(axis:)` | Горизонтальный / вертикальный стек. Один компонент, ось — параметр |
| `EmpOverlayContainer` | Наложение элементов (бывший ZStack) |
| `EmpScrollContainer` | Скроллируемое содержимое |
| `EmpSpacer` | Гибкий отступ внутри стека |

---

### Группа 3: Input Views

*Принимают ввод пользователя. Имеют состояние.*

| Компонент | Описание |
|---|---|
| `EmpTextField` | Однострочный ввод |
| `EmpTextView` | Многострочный ввод |
| `EmpToggle` | Бинарное состояние (не `Switch` — коллизия с UIKit) |

---

### Группа 4: Behavioral Wrappers

*Добавляют поведение произвольному содержимому.*

| Компонент | Описание |
|---|---|
| `EmpTapContainer` | Любой контент становится интерактивным. Реализация через `UIControl` / `NSControl` |
| `EmpSelectionContainer` | Управляет selected / deselected состоянием |
| `EmpAnimationContainer` | Transition, появление, исчезновение |
| `EmpListContainer` | UICollectionView-абстракция (бывший ReuseWrapper) |
| `EmpNativeContainer` | Escape hatch для компонентов вне DS |

---

### EmpTapContainer — детально

**Interaction states:**

```swift
enum InteractionState {
    case normal
    case pressed     // UIKit: isHighlighted / AppKit: isHighlighted
    case disabled    // UIKit: isEnabled=false / AppKit: isEnabled=false
    case focused     // клавиатура, accessibility, критично для AppKit
}
```

**Протокол:**

```swift
protocol EmpTapContainerProtocol {
    var state: InteractionState { get set }
    var onTap: (() -> Void)? { get set }
    var onLongPress: (() -> Void)? { get set }
}

// UIKit
class UIKitTapContainer: UIControl { ... }

// AppKit
class AppKitTapContainer: NSControl { ... }
```

**Loading — не часть EmpTapContainer.** Компонент не знает форму и размер своего содержимого. Loading — ответственность родителя:

```swift
EmpTapContainer(state: isLoading ? .disabled : .normal) {
    if isLoading {
        EmpActivityIndicator()
    } else {
        MyContent()
    }
}
```

---

### Структура модуля компонентов

```
Components/
├── Content/
│   ├── EmpText/
│   ├── EmpRichLabel/
│   ├── EmpIcon/
│   ├── EmpImage/
│   ├── EmpAnimationView/
│   ├── EmpActivityIndicator/
│   ├── EmpProgressBar/
│   └── EmpDivider/
├── Layout/
│   ├── EmpStackContainer/
│   ├── EmpOverlayContainer/
│   ├── EmpScrollContainer/
│   └── EmpSpacer/
├── Input/
│   ├── EmpTextField/
│   ├── EmpTextView/
│   └── EmpToggle/
└── Wrappers/
    ├── EmpTapContainer/
    ├── EmpSelectionContainer/
    ├── EmpAnimationContainer/
    ├── EmpListContainer/
    └── EmpNativeContainer/
```

---

## Open Questions

- [ ] Как токены попадают в компоненты — механизм стилизации
- [ ] Структура Tuist-таргетов и зависимости между слоями
- [ ] API каждого компонента — состояния, параметры, связь с токенами
