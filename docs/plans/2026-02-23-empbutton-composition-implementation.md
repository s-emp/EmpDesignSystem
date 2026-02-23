# EmpButton Composition Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Рефакторинг EmpButton для использования EmpText/EmpImage как subview вместо прямого создания UILabel/UIImageView, а в Content.Element — EmpText.ViewModel/EmpImage.ViewModel вместо примитивов.

**Architecture:** Content.Element хранит ViewModel'и компонентов. EmpButton при configure/updateContent создаёт или обновляет EmpText/EmpImage экземпляры внутри contentStack. Preset API (ContentLayout) не меняется — изменения только во внутренней трансформации в Content.

**Tech Stack:** Swift, UIKit (iOS), AppKit (macOS), Tuist

---

### Task 1: Обновить EmpButton+Content.swift (iOS)

**Files:**
- Modify: `EmpUI_iOS/Sources/Components/EmpButton+Content.swift`

**Step 1: Заменить Content.Element**

Заменить содержимое файла:

```swift
import UIKit

public extension EmpButton {
    struct Content {
        public let leading: Element?
        public let center: Element?
        public let trailing: Element?

        public init(
            leading: Element? = nil,
            center: Element? = nil,
            trailing: Element? = nil
        ) {
            self.leading = leading
            self.center = center
            self.trailing = trailing
        }

        public enum Element {
            case text(EmpText.ViewModel)
            case icon(EmpImage.ViewModel)
            case titleSubtitle(title: EmpText.ViewModel, subtitle: EmpText.ViewModel)
        }
    }
}
```

Удалены swiftlint disable комментарии — больше не нужны (у новых кейсов мало associated values).

---

### Task 2: Обновить makeElementView и updateContent в EmpButton.swift (iOS)

**Files:**
- Modify: `EmpUI_iOS/Sources/Components/EmpButton.swift` (строки 113-190)

**Step 1: Заменить makeElementView**

Заменить метод `makeElementView(_:)` (строки 113-155):

```swift
    private func makeElementView(_ element: Content.Element) -> UIView {
        switch element {
        case let .text(viewModel):
            let empText = EmpText()
            empText.configure(with: viewModel)
            return empText

        case let .icon(viewModel):
            let empImage = EmpImage()
            empImage.configure(with: viewModel)
            return empImage

        case let .titleSubtitle(titleVM, subtitleVM):
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .leading
            stack.spacing = 2

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

**Step 2: Заменить updateContent**

Заменить метод `updateContent(_:)` (строки 157-190):

```swift
    private func updateContent(_ content: Content) {
        let elements: [Content.Element] = [content.leading, content.center, content.trailing].compactMap { $0 }

        guard contentStack.arrangedSubviews.count == elements.count else {
            rebuildContent(content)
            return
        }

        for (view, element) in zip(contentStack.arrangedSubviews, elements) {
            switch element {
            case let .text(viewModel):
                (view as? EmpText)?.configure(with: viewModel)

            case let .icon(viewModel):
                (view as? EmpImage)?.configure(with: viewModel)

            case let .titleSubtitle(titleVM, subtitleVM):
                if let stack = view as? UIStackView {
                    (stack.arrangedSubviews.first as? EmpText)?.configure(with: titleVM)
                    if stack.arrangedSubviews.count > 1 {
                        (stack.arrangedSubviews[1] as? EmpText)?.configure(with: subtitleVM)
                    }
                }
            }
        }
    }
```

---

### Task 3: Обновить styledElement в EmpButton+Preset.swift (iOS)

**Files:**
- Modify: `EmpUI_iOS/Sources/Components/EmpButton+Preset.swift` (строки 193-214)

**Step 1: Заменить styledElement**

Заменить метод `styledElement(_:primaryColor:secondaryColor:config:)`:

```swift
        private static func styledElement(
            _ element: ContentLayout.ElementLayout,
            primaryColor: UIColor,
            secondaryColor: UIColor,
            config: SizeConfig
        ) -> Content.Element {
            switch element {
            case let .icon(image):
                return .icon(EmpImage.ViewModel(
                    image: image,
                    tintColor: primaryColor,
                    size: CGSize(width: config.iconSize, height: config.iconSize),
                    contentMode: .center
                ))
            case let .text(string):
                return .text(EmpText.ViewModel(
                    content: .plain(.init(
                        text: string,
                        font: config.font,
                        color: primaryColor
                    )),
                    numberOfLines: 1,
                    alignment: .center
                ))
            case let .titleSubtitle(title, subtitle):
                return .titleSubtitle(
                    title: EmpText.ViewModel(
                        content: .plain(.init(
                            text: title,
                            font: config.font,
                            color: primaryColor
                        )),
                        numberOfLines: 1,
                        alignment: .leading
                    ),
                    subtitle: EmpText.ViewModel(
                        content: .plain(.init(
                            text: subtitle,
                            font: config.secondaryFont,
                            color: secondaryColor
                        )),
                        numberOfLines: 1,
                        alignment: .leading
                    )
                )
            }
        }
```

---

### Task 4: Собрать и проверить iOS

**Step 1: Сгенерировать проект**

Run: `mise exec -- tuist generate --no-open`

**Step 2: Собрать iOS фреймворк**

Run: `mise exec -- tuist build EmpUI_iOS`
Expected: BUILD SUCCEEDED

---

### Task 5: Обновить EmpButton+Content.swift (macOS)

**Files:**
- Modify: `EmpUI_macOS/Sources/Components/EmpButton+Content.swift`

**Step 1: Заменить Content.Element**

Заменить содержимое файла:

```swift
import AppKit

public extension EmpButton {
    struct Content {
        public let leading: Element?
        public let center: Element?
        public let trailing: Element?

        public init(
            leading: Element? = nil,
            center: Element? = nil,
            trailing: Element? = nil
        ) {
            self.leading = leading
            self.center = center
            self.trailing = trailing
        }

        public enum Element {
            case text(EmpText.ViewModel)
            case icon(EmpImage.ViewModel)
            case titleSubtitle(title: EmpText.ViewModel, subtitle: EmpText.ViewModel)
        }
    }
}
```

---

### Task 6: Обновить makeElementView и updateContent в EmpButton.swift (macOS)

**Files:**
- Modify: `EmpUI_macOS/Sources/Components/EmpButton.swift` (строки 120-197)

**Step 1: Заменить makeElementView**

Заменить метод `makeElementView(_:)` (строки 120-162):

```swift
    private func makeElementView(_ element: Content.Element) -> NSView {
        switch element {
        case let .text(viewModel):
            let empText = EmpText()
            empText.configure(with: viewModel)
            return empText

        case let .icon(viewModel):
            let empImage = EmpImage()
            empImage.configure(with: viewModel)
            return empImage

        case let .titleSubtitle(titleVM, subtitleVM):
            let stack = NSStackView()
            stack.orientation = .vertical
            stack.alignment = .leading
            stack.spacing = 2

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

**Step 2: Заменить updateContent**

Заменить метод `updateContent(_:)` (строки 164-197):

```swift
    private func updateContent(_ content: Content) {
        let elements: [Content.Element] = [content.leading, content.center, content.trailing].compactMap { $0 }

        guard contentStack.arrangedSubviews.count == elements.count else {
            rebuildContent(content)
            return
        }

        for (view, element) in zip(contentStack.arrangedSubviews, elements) {
            switch element {
            case let .text(viewModel):
                (view as? EmpText)?.configure(with: viewModel)

            case let .icon(viewModel):
                (view as? EmpImage)?.configure(with: viewModel)

            case let .titleSubtitle(titleVM, subtitleVM):
                if let stack = view as? NSStackView {
                    (stack.arrangedSubviews.first as? EmpText)?.configure(with: titleVM)
                    if stack.arrangedSubviews.count > 1 {
                        (stack.arrangedSubviews[1] as? EmpText)?.configure(with: subtitleVM)
                    }
                }
            }
        }
    }
```

---

### Task 7: Обновить styledElement в EmpButton+Preset.swift (macOS)

**Files:**
- Modify: `EmpUI_macOS/Sources/Components/EmpButton+Preset.swift` (строки 193-214)

**Step 1: Заменить styledElement**

Заменить метод `styledElement(_:primaryColor:secondaryColor:config:)`:

```swift
        private static func styledElement(
            _ element: ContentLayout.ElementLayout,
            primaryColor: NSColor,
            secondaryColor: NSColor,
            config: SizeConfig
        ) -> Content.Element {
            switch element {
            case let .icon(image):
                return .icon(EmpImage.ViewModel(
                    image: image,
                    tintColor: primaryColor,
                    size: CGSize(width: config.iconSize, height: config.iconSize),
                    contentMode: .center
                ))
            case let .text(string):
                return .text(EmpText.ViewModel(
                    content: .plain(.init(
                        text: string,
                        font: config.font,
                        color: primaryColor
                    )),
                    numberOfLines: 1,
                    alignment: .center
                ))
            case let .titleSubtitle(title, subtitle):
                return .titleSubtitle(
                    title: EmpText.ViewModel(
                        content: .plain(.init(
                            text: title,
                            font: config.font,
                            color: primaryColor
                        )),
                        numberOfLines: 1,
                        alignment: .leading
                    ),
                    subtitle: EmpText.ViewModel(
                        content: .plain(.init(
                            text: subtitle,
                            font: config.secondaryFont,
                            color: secondaryColor
                        )),
                        numberOfLines: 1,
                        alignment: .leading
                    )
                )
            }
        }
```

---

### Task 8: Собрать и проверить macOS

**Step 1: Собрать macOS фреймворк**

Run: `mise exec -- tuist build EmpUI_macOS`
Expected: BUILD SUCCEEDED

**Step 2: Собрать sandbox app (включает EmpUI_macOS)**

Run: `mise exec -- tuist build EmpDesignSystem`
Expected: BUILD SUCCEEDED

---

### Task 9: Финальная проверка обеих платформ

**Step 1: Запустить тесты macOS**

Run: `mise exec -- tuist test EmpUI_macOS`
Expected: All tests passed

**Step 2: Запустить тесты iOS**

Run: `mise exec -- tuist test EmpUI_iOS`
Expected: All tests passed

**Step 3: SwiftLint**

Run: `swiftlint`
Expected: No errors (warnings допустимы)

---

## Что НЕ меняется

- `EmpButton+ViewModel.swift` — структура ViewModel без изменений
- `EmpButton+Preview.swift` (iOS/macOS) — Preview файлы используют Preset API (ContentLayout), который не менялся
- `EmpText`, `EmpImage` — компоненты не трогаем
- `CommonViewModel`, `ControlParameter` — без изменений
