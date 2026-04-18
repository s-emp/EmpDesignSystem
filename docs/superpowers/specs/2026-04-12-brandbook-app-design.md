# Brandbook App — Design Spec

## Цель
Превратить sandbox-приложение EmpDesignSystem в интерактивный brandbook — каталог всех компонентов дизайн-системы с live preview и конструктором ViewModel.

## Ключевые решения
- **Таргет:** существующий `EmpDesignSystem` (macOS app)
- **Технология:** чистый AppKit, только компоненты из EmpUI_macOS
- **Layout:** Sidebar | Preview | Inspector (горизонтальный split, Xcode-style)
- **Inspector depth:** полная рекурсия ViewModel (все вложенные типы раскрываются)

## Архитектура

### Layout (ESplitView, 3 панели)

```
ESplitView(horizontal)
├── Panel 1: Sidebar (220pt min)
├── Panel 2: Preview (flexible)
└── Panel 3: Inspector (280pt min)
```

### Sidebar
```
EScroll
└── EStack(vertical)
    ├── EText("TOKENS") — section header
    ├── ETapContainer → EText("Typography")
    ├── ETapContainer → EText("Colors")
    ├── ...
    ├── EDivider
    ├── EText("CONTENT VIEWS") — section header
    ├── ETapContainer → EText("EText")  [selected state via ESelectionContainer]
    ├── ...
```

### Preview
```
EStack(vertical)
├── EStack(horizontal) — header bar
│   ├── EText("EText — Preview")
│   └── ESpacer
└── Center area — компонент с текущим ViewModel
```

### Inspector
```
EScroll
└── EStack(vertical)
    ├── EText("Inspector") — header
    ├── PropertyRow(label: "text", control: ETextField)
    ├── PropertyRow(label: "numberOfLines", control: ESlider)
    ├── PropertyRow(label: "textColor", control: EDropdown)
    ├── EDisclosure("common")
    │   ├── EDisclosure("border")
    │   │   ├── PropertyRow("width", ESlider)
    │   │   ├── PropertyRow("color", EDropdown)
    │   │   └── PropertyRow("style", EDropdown)
    │   ├── EDisclosure("shadow")
    │   ├── EDisclosure("corners")
    │   ├── PropertyRow("backgroundColor", EDropdown)
    │   └── EDisclosure("layoutMargins")
    └── ...
```

### Data Flow
1. Sidebar tap → selectedComponent меняется
2. Inspector перестраивается из дефолтного ViewModel выбранного компонента
3. Изменение в Inspector → callback обновляет ViewModel
4. Новый ViewModel → configure(with:) → Preview обновляется
5. Центральный AppState хранит: selectedComponent + текущий ViewModel

## Категории Sidebar

| Категория | Элементы |
|---|---|
| Tokens | Typography, Colors, Spacing, Opacity, Shape Presets, Shadow Presets |
| Content Views | EText, EIcon, ERichLabel, EImage, EDivider, EProgressBar, EActivityIndicator, EAnimationView |
| Input Views | ETextField, ETextView, EToggle, ESlider, EDropdown |
| Layout | EStack, EOverlay, EScroll, ESpacer, ESplitView |
| Wrappers | ETapContainer, ESelectionContainer, EAnimationContainer, EListContainer, ENativeContainer, EDisclosure |
| Composed | EInfoCard, ESegmentControl |

## Inspector: маппинг типов на контролы

| Тип свойства | Контрол |
|---|---|
| String | ETextField |
| CGFloat / Double | ESlider + ETextField (для точного ввода) |
| Bool | EToggle |
| Enum (любой) | EDropdown |
| NSColor (semantic) | EDropdown с семантическими цветами |
| Вложенный struct | EDisclosure → рекурсия |
| NSEdgeInsets | EDisclosure → 4x ESlider (top/left/bottom/right) |

## Компоненты DS используемые в приложении

**Shell:** ESplitView
**Sidebar:** EScroll, EStack, ETapContainer, ESelectionContainer, EText, EDivider, ESpacer
**Preview:** EStack, EText, ESpacer
**Inspector:** EScroll, EStack, EText, EDisclosure, ETextField, ESlider, EToggle, EDropdown, EDivider

## Вне скоупа
- Токены-страницы (Typography, Colors и т.д.) — покажем простой showcase, не конструктор
- Экспорт/импорт ViewModel
- Drag & drop
- Undo/Redo
