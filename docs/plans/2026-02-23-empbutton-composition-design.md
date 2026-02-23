# EmpButton: композиция через EmpText/EmpImage

## Цель

Рефакторинг EmpButton для использования EmpText и EmpImage компонентов вместо прямого создания UILabel/UIImageView. Две задачи:

1. **Единообразие API** — Content.Element использует EmpText.ViewModel / EmpImage.ViewModel вместо дублирования параметров (color, font, size)
2. **Физическая композиция** — внутри contentStack лежат реальные EmpText/EmpImage экземпляры

## Новый Content.Element

```swift
enum Element: Equatable {
    case text(EmpText.ViewModel)
    case icon(EmpImage.ViewModel)
    case titleSubtitle(title: EmpText.ViewModel, subtitle: EmpText.ViewModel)
}
```

### Было → Стало

| Было | Стало |
|------|-------|
| `.text(String, color: UIColor, font: UIFont)` | `.text(EmpText.ViewModel)` |
| `.icon(UIImage, color: UIColor, size: CGFloat)` | `.icon(EmpImage.ViewModel)` |
| `.titleSubtitle(title:subtitle:titleColor:subtitleColor:titleFont:subtitleFont:)` | `.titleSubtitle(title: EmpText.ViewModel, subtitle: EmpText.ViewModel)` |

## Физическая композиция

```
EmpButton (UIView/NSView)
    └── contentStack (UIStackView/NSStackView) → layoutMarginsGuide
        ├── leading:  EmpText / EmpImage / VStack(EmpText, EmpText) / nil
        ├── center:   EmpText / EmpImage / VStack(EmpText, EmpText) / nil
        └── trailing: EmpText / EmpImage / VStack(EmpText, EmpText) / nil
```

EmpButton при `configure(with:)` создаёт view из Element:

```swift
private func makeView(for element: Content.Element) -> UIView {
    switch element {
    case .text(let viewModel):
        let empText = EmpText()
        empText.configure(with: viewModel)
        return empText

    case .icon(let viewModel):
        let empImage = EmpImage()
        empImage.configure(with: viewModel)
        return empImage

    case .titleSubtitle(let titleVM, let subtitleVM):
        let stack = UIStackView()  // vertical
        let titleText = EmpText()
        titleText.configure(with: titleVM)
        let subtitleText = EmpText()
        subtitleText.configure(with: subtitleVM)
        stack.addArrangedSubview(titleText)
        stack.addArrangedSubview(subtitleText)
        return stack
    }
}
```

CommonViewModel в EmpText/EmpImage ViewModel'ах — дефолтный (`.init()`), без border/shadow/margins.

## Preset'ы

Стили (filled, base, outlined, ghost), цветовые варианты (primary, danger), размеры (S/M/L) — без изменений. Меняется только способ создания Content:

```swift
// Текст
.text(EmpText.ViewModel(
    content: .plain(.init(text: "Title", font: sizeConfig.font, color: colors.textColor)),
    numberOfLines: 1,
    alignment: .center
))

// Иконка
.icon(EmpImage.ViewModel(
    image: image,
    tintColor: colors.iconColor,
    size: CGSize(width: sizeConfig.iconSize, height: sizeConfig.iconSize),
    contentMode: .center
))
```

## ControlParameter

`content` остаётся `ControlParameter<Content>` — для каждого состояния свой Content с EmpText/EmpImage ViewModel'ами.

## Scope изменений

### Меняются:
- `EmpButton+Content.swift` (iOS + macOS) — Element enum
- `EmpButton.swift` (iOS + macOS) — makeView создаёт EmpText/EmpImage
- `EmpButton+Preset.swift` (iOS + macOS) — создание ViewModel'ей
- Preview файлы (iOS + macOS) — обновить ручные ViewModel'и

### Не меняются:
- `EmpButton+ViewModel.swift` — структура ViewModel без изменений
- `EmpText.swift`, `EmpImage.swift` — компоненты не трогаем
- `CommonViewModel`, `ControlParameter` — без изменений

## Платформы

iOS и macOS обновляются одновременно.
