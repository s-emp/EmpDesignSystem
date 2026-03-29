# Descriptor Tree Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Реализовать Descriptor Tree — систему описания UI как иммутабельного дерева данных с diff-based обновлением, для обеих платформ (iOS + macOS).

**Architecture:** Рекурсивный enum `ComponentDescriptor` описывает UI-дерево. `ComponentBuilder` строит view-иерархию (build), обновляет через diff (update) или безусловно (reconfigure). Каждый компонент реализует `EComponent` протокол и хранит свою ViewModel. Коллекции работают через `ECollectionCell` + `DiffableDataSource` с fingerprint-оптимизацией.

**Tech Stack:** Swift, UIKit (iOS), AppKit (macOS), Tuist 4.131.1, Swift Testing, swift-snapshot-testing

**Spec:** `docs/descriptor-tree-design.md`

---

## Файловая структура

### Новые файлы (iOS)

```
EmpUI_iOS/Sources/Common/
├── Protocols/
│   ├── EComponent.swift              — протокол EComponent
│   └── ComponentViewModel.swift      — протокол ComponentViewModel
├── Size/
│   ├── SizeDimension.swift           — enum SizeDimension (hug/fill/fixed)
│   └── SizeViewModel.swift           — struct SizeViewModel (width + height)
├── ComponentDescriptor/
│   ├── ComponentDescriptor.swift     — enum ComponentDescriptor
│   ├── StructureFingerprint.swift    — enum StructureFingerprint
│   ├── DescriptorBuilder.swift       — @resultBuilder + фабрики
│   └── ComponentBuilder.swift        — build / update / reconfigure
├── Collection/
│   ├── EItem.swift                   — struct EItem (id + descriptor)
│   └── ECollectionCell.swift         — generic cell для UICollectionView
EmpUI_iOS/Sources/Components/
├── EStack/
│   ├── EStack.swift                  — UIStackView subclass + EComponent
│   └── EStack+ViewModel.swift        — ViewModel с axis
├── EOverlay/
│   ├── EOverlay.swift                — UIView subclass + EComponent
│   └── EOverlay+ViewModel.swift      — ViewModel
├── ESpacer/
│   ├── ESpacer.swift                 — UIView subclass + EComponent
│   └── ESpacer+ViewModel.swift       — ViewModel с length
├── EScroll/
│   ├── EScroll.swift                 — UIScrollView subclass + EComponent
│   └── EScroll+ViewModel.swift       — ViewModel с axis
├── ETapContainer/
│   ├── ETapContainer.swift           — UIControl subclass + EComponent
│   ├── ETapContainer+ViewModel.swift — ViewModel с Action
│   └── ETapContainer+Action.swift    — Action struct (id + handler)
```

### Новые файлы (macOS) — зеркальная структура с NSView/NSColor/NSEdgeInsets

### Модифицируемые файлы

```
EmpUI_iOS/Sources/Common/
├── CommonViewModel.swift             — добавить size: SizeViewModel, удалить черновой код
├── UIView+CommonViewModel.swift      — добавить apply size в apply(common:)
EmpUI_iOS/Sources/Components/
├── EmpText/ → EText/                 — rename Emp→E, добавить EComponent conformance
├── EmpImage/ → EImage/               — rename Emp→E, добавить EComponent conformance
├── EmpProgressBar/ → EProgressBar/   — rename Emp→E, добавить EComponent conformance
├── EmpInfoCard/ → EInfoCard/         — rename Emp→E, добавить EComponent conformance
├── EmpSegmentControl/ → ESegmentControl/ → rename, EComponent conformance
├── EmpButton/                        — УДАЛИТЬ (заменяется ButtonPreset)
EmpUI_iOS/Tests/
├── все тесты                         — rename Emp→E в импортах и использовании
```

Аналогично для macOS.

### Файлы Tuist

```
Project.swift                         — обновить пути к файлам после rename
```

---

## Фаза 1: Фундамент (протоколы, размеры, рефакторинг имён)

### Task 1: Удалить черновой код из CommonViewModel.swift

**Files:**
- Modify: `EmpUI_iOS/Sources/Common/CommonViewModel.swift`

- [ ] **Step 1: Удалить черновой код**

Удалить всё после закрывающей скобки `CommonViewModel` (строки 28–84): протоколы `ComponentViewModel`, `ViewModelConfigurable`, классы `TestComponent`, `GenericCollectionCell`.

Файл должен содержать только:

```swift
import UIKit

public struct CommonViewModel: Equatable {
    public let border: Border
    public let shadow: Shadow
    public let corners: Corners
    public let backgroundColor: UIColor
    public let layoutMargins: UIEdgeInsets

    public init(
        border: Border = Border(),
        shadow: Shadow = Shadow(),
        corners: Corners = Corners(),
        backgroundColor: UIColor = .clear,
        layoutMargins: UIEdgeInsets = .zero
    ) {
        self.border = border
        self.shadow = shadow
        self.corners = corners
        self.backgroundColor = backgroundColor
        self.layoutMargins = layoutMargins
    }
}
```

- [ ] **Step 2: Собрать проект**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/CommonViewModel.swift
git commit -m "chore: удалить черновые протоколы из CommonViewModel"
```

---

### Task 2: Создать SizeDimension и SizeViewModel (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/Size/SizeDimension.swift`
- Create: `EmpUI_iOS/Sources/Common/Size/SizeViewModel.swift`
- Create: `EmpUI_iOS/Tests/SizeViewModelTests.swift`

- [ ] **Step 1: Написать тесты**

```swift
// EmpUI_iOS/Tests/SizeViewModelTests.swift
import Testing
@testable import EmpUI_iOS

@Suite("SizeViewModel")
struct SizeViewModelTests {

    @Test("Инициализация по умолчанию — hug по обеим осям")
    func defaultInit() {
        let size = SizeViewModel()
        #expect(size.width == .hug)
        #expect(size.height == .hug)
    }

    @Test("Fixed хранит значение")
    func fixedValue() {
        let size = SizeViewModel(width: .fixed(100), height: .fixed(50))
        #expect(size.width == .fixed(100))
        #expect(size.height == .fixed(50))
    }

    @Test("Equatable — одинаковые значения равны")
    func equatable() {
        let a = SizeViewModel(width: .fill, height: .hug)
        let b = SizeViewModel(width: .fill, height: .hug)
        #expect(a == b)
    }

    @Test("Equatable — разные значения не равны")
    func notEqual() {
        let a = SizeViewModel(width: .fill, height: .hug)
        let b = SizeViewModel(width: .hug, height: .hug)
        #expect(a != b)
    }

    @Test("SizeDimension.fixed с разными значениями не равны")
    func fixedNotEqual() {
        #expect(SizeDimension.fixed(10) != SizeDimension.fixed(20))
    }
}
```

- [ ] **Step 2: Запустить тесты — убедиться что не компилируются**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: ошибки компиляции — `SizeViewModel` и `SizeDimension` не найдены

- [ ] **Step 3: Создать SizeDimension**

```swift
// EmpUI_iOS/Sources/Common/Size/SizeDimension.swift
import Foundation

public enum SizeDimension: Equatable {
    case hug
    case fill
    case fixed(CGFloat)
}
```

- [ ] **Step 4: Создать SizeViewModel**

```swift
// EmpUI_iOS/Sources/Common/Size/SizeViewModel.swift
import Foundation

public struct SizeViewModel: Equatable {
    public let width: SizeDimension
    public let height: SizeDimension

    public init(
        width: SizeDimension = .hug,
        height: SizeDimension = .hug
    ) {
        self.width = width
        self.height = height
    }
}
```

- [ ] **Step 5: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты SizeViewModel проходят

- [ ] **Step 6: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/Size/ EmpUI_iOS/Tests/SizeViewModelTests.swift
git commit -m "feat(iOS): добавить SizeDimension и SizeViewModel"
```

---

### Task 3: Создать SizeDimension и SizeViewModel (macOS)

**Files:**
- Create: `EmpUI_macOS/Sources/Common/Size/SizeDimension.swift`
- Create: `EmpUI_macOS/Sources/Common/Size/SizeViewModel.swift`
- Create: `EmpUI_macOS/Tests/SizeViewModelTests.swift`

- [ ] **Step 1: Создать файлы — идентичны iOS**

```swift
// EmpUI_macOS/Sources/Common/Size/SizeDimension.swift
import Foundation

public enum SizeDimension: Equatable {
    case hug
    case fill
    case fixed(CGFloat)
}
```

```swift
// EmpUI_macOS/Sources/Common/Size/SizeViewModel.swift
import Foundation

public struct SizeViewModel: Equatable {
    public let width: SizeDimension
    public let height: SizeDimension

    public init(
        width: SizeDimension = .hug,
        height: SizeDimension = .hug
    ) {
        self.width = width
        self.height = height
    }
}
```

```swift
// EmpUI_macOS/Tests/SizeViewModelTests.swift
import Testing
@testable import EmpUI_macOS

@Suite("SizeViewModel")
struct SizeViewModelTests {

    @Test("Инициализация по умолчанию — hug по обеим осям")
    func defaultInit() {
        let size = SizeViewModel()
        #expect(size.width == .hug)
        #expect(size.height == .hug)
    }

    @Test("Fixed хранит значение")
    func fixedValue() {
        let size = SizeViewModel(width: .fixed(100), height: .fixed(50))
        #expect(size.width == .fixed(100))
        #expect(size.height == .fixed(50))
    }

    @Test("Equatable — одинаковые значения равны")
    func equatable() {
        let a = SizeViewModel(width: .fill, height: .hug)
        let b = SizeViewModel(width: .fill, height: .hug)
        #expect(a == b)
    }

    @Test("Equatable — разные значения не равны")
    func notEqual() {
        let a = SizeViewModel(width: .fill, height: .hug)
        let b = SizeViewModel(width: .hug, height: .hug)
        #expect(a != b)
    }

    @Test("SizeDimension.fixed с разными значениями не равны")
    func fixedNotEqual() {
        #expect(SizeDimension.fixed(10) != SizeDimension.fixed(20))
    }
}
```

- [ ] **Step 2: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_macOS 2>&1 | tail -20`
Expected: все тесты проходят

- [ ] **Step 3: Коммит**

```bash
git add EmpUI_macOS/Sources/Common/Size/ EmpUI_macOS/Tests/SizeViewModelTests.swift
git commit -m "feat(macOS): добавить SizeDimension и SizeViewModel"
```

---

### Task 4: Добавить size в CommonViewModel (iOS + macOS)

**Files:**
- Modify: `EmpUI_iOS/Sources/Common/CommonViewModel.swift`
- Modify: `EmpUI_macOS/Sources/Common/CommonViewModel.swift`
- Modify: `EmpUI_iOS/Tests/CommonViewModelTests.swift`
- Modify: `EmpUI_macOS/Tests/CommonViewModelTests.swift`

- [ ] **Step 1: Обновить тест (iOS)**

Добавить в существующий `CommonViewModelTests.swift` проверку `size`:

```swift
@Test("Инициализация по умолчанию")
func defaultInitializer() {
    let vm = CommonViewModel()
    #expect(vm.border == CommonViewModel.Border())
    #expect(vm.shadow == CommonViewModel.Shadow())
    #expect(vm.corners == CommonViewModel.Corners())
    #expect(vm.backgroundColor == .clear)
    #expect(vm.layoutMargins == .zero)
    #expect(vm.size == SizeViewModel())
}
```

- [ ] **Step 2: Запустить тест — убедиться что не компилируется**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: ошибка — `size` не найден в `CommonViewModel`

- [ ] **Step 3: Добавить size в CommonViewModel (iOS)**

```swift
// EmpUI_iOS/Sources/Common/CommonViewModel.swift
import UIKit

public struct CommonViewModel: Equatable {
    public let border: Border
    public let shadow: Shadow
    public let corners: Corners
    public let backgroundColor: UIColor
    public let layoutMargins: UIEdgeInsets
    public let size: SizeViewModel

    public init(
        border: Border = Border(),
        shadow: Shadow = Shadow(),
        corners: Corners = Corners(),
        backgroundColor: UIColor = .clear,
        layoutMargins: UIEdgeInsets = .zero,
        size: SizeViewModel = SizeViewModel()
    ) {
        self.border = border
        self.shadow = shadow
        self.corners = corners
        self.backgroundColor = backgroundColor
        self.layoutMargins = layoutMargins
        self.size = size
    }
}
```

- [ ] **Step 4: Запустить тесты iOS**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты проходят (дефолт `SizeViewModel()` не ломает существующий код)

- [ ] **Step 5: Повторить для macOS**

Аналогичные изменения в `EmpUI_macOS/Sources/Common/CommonViewModel.swift` и `EmpUI_macOS/Tests/CommonViewModelTests.swift`. Разница: `NSColor` вместо `UIColor`, `NSEdgeInsets` вместо `UIEdgeInsets`.

```swift
// EmpUI_macOS/Sources/Common/CommonViewModel.swift
import AppKit

public struct CommonViewModel: Equatable {
    public let border: Border
    public let shadow: Shadow
    public let corners: Corners
    public let backgroundColor: NSColor
    public let layoutMargins: NSEdgeInsets
    public let size: SizeViewModel

    public init(
        border: Border = Border(),
        shadow: Shadow = Shadow(),
        corners: Corners = Corners(),
        backgroundColor: NSColor = .clear,
        layoutMargins: NSEdgeInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        size: SizeViewModel = SizeViewModel()
    ) {
        self.border = border
        self.shadow = shadow
        self.corners = corners
        self.backgroundColor = backgroundColor
        self.layoutMargins = layoutMargins
        self.size = size
    }
}
```

- [ ] **Step 6: Запустить тесты macOS**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_macOS 2>&1 | tail -20`
Expected: все тесты проходят

- [ ] **Step 7: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/CommonViewModel.swift EmpUI_iOS/Tests/CommonViewModelTests.swift \
       EmpUI_macOS/Sources/Common/CommonViewModel.swift EmpUI_macOS/Tests/CommonViewModelTests.swift
git commit -m "feat: добавить size: SizeViewModel в CommonViewModel"
```

---

### Task 5: Реализовать apply(size:) в UIView/NSView extension

**Files:**
- Modify: `EmpUI_iOS/Sources/Common/UIView+CommonViewModel.swift`
- Modify: `EmpUI_macOS/Sources/Common/NSView+CommonViewModel.swift`

- [ ] **Step 1: Добавить apply(size:) в UIView extension (iOS)**

В `UIView+CommonViewModel.swift`, внутри метода `apply(common:)`, после существующего кода добавить вызов `applySize(viewModel.size)`. Добавить приватный метод:

```swift
// В конец файла UIView+CommonViewModel.swift

private extension UIView {
    func applySize(_ size: SizeViewModel) {
        applySizeDimension(size.width, for: .horizontal)
        applySizeDimension(size.height, for: .vertical)
    }

    func applySizeDimension(_ dimension: SizeDimension, for axis: NSLayoutConstraint.Axis) {
        // Удалить предыдущий fixed constraint если был
        let tag = axis == .horizontal ? 9001 : 9002
        if let existing = constraints.first(where: {
            ($0.firstAttribute == (axis == .horizontal ? .width : .height))
            && $0.secondItem == nil
            && $0.identifier == "EDS.fixed.\(axis.rawValue)"
        }) {
            existing.isActive = false
            removeConstraint(existing)
        }

        switch dimension {
        case .hug:
            setContentHuggingPriority(UILayoutPriority(751), for: axis)
            setContentCompressionResistancePriority(UILayoutPriority(752), for: axis)
        case .fill:
            setContentHuggingPriority(UILayoutPriority(1), for: axis)
            setContentCompressionResistancePriority(UILayoutPriority(752), for: axis)
        case .fixed(let value):
            setContentHuggingPriority(UILayoutPriority(751), for: axis)
            setContentCompressionResistancePriority(UILayoutPriority(752), for: axis)
            let constraint = axis == .horizontal
                ? widthAnchor.constraint(equalToConstant: value)
                : heightAnchor.constraint(equalToConstant: value)
            constraint.priority = .required
            constraint.identifier = "EDS.fixed.\(axis.rawValue)"
            constraint.isActive = true
        }
    }
}
```

В методе `apply(common:)` добавить строку `applySize(viewModel.size)` в конец.

- [ ] **Step 2: Аналогично для macOS**

В `NSView+CommonViewModel.swift` — идентичная логика, но с NSView API:

```swift
private extension NSView {
    func applySize(_ size: SizeViewModel) {
        applySizeDimension(size.width, for: .horizontal)
        applySizeDimension(size.height, for: .vertical)
    }

    func applySizeDimension(_ dimension: SizeDimension, for axis: NSLayoutConstraint.Axis) {
        if let existing = constraints.first(where: {
            ($0.firstAttribute == (axis == .horizontal ? .width : .height))
            && $0.secondItem == nil
            && $0.identifier == "EDS.fixed.\(axis.rawValue)"
        }) {
            existing.isActive = false
            removeConstraint(existing)
        }

        switch dimension {
        case .hug:
            setContentHuggingPriority(NSLayoutConstraint.Priority(751), for: axis == .horizontal ? .horizontal : .vertical)
            setContentCompressionResistancePriority(NSLayoutConstraint.Priority(752), for: axis == .horizontal ? .horizontal : .vertical)
        case .fill:
            setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: axis == .horizontal ? .horizontal : .vertical)
            setContentCompressionResistancePriority(NSLayoutConstraint.Priority(752), for: axis == .horizontal ? .horizontal : .vertical)
        case .fixed(let value):
            setContentHuggingPriority(NSLayoutConstraint.Priority(751), for: axis == .horizontal ? .horizontal : .vertical)
            setContentCompressionResistancePriority(NSLayoutConstraint.Priority(752), for: axis == .horizontal ? .horizontal : .vertical)
            let constraint = axis == .horizontal
                ? widthAnchor.constraint(equalToConstant: value)
                : heightAnchor.constraint(equalToConstant: value)
            constraint.priority = .required
            constraint.identifier = "EDS.fixed.\(axis.rawValue)"
            constraint.isActive = true
        }
    }
}
```

- [ ] **Step 3: Собрать оба таргета**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS && mise exec -- tuist build EmpDesignSystem`
Expected: BUILD SUCCEEDED для обоих

- [ ] **Step 4: Запустить все тесты**

Run: `mise exec -- tuist test EmpUI_iOS && mise exec -- tuist test EmpUI_macOS`
Expected: все существующие тесты проходят (дефолт `.hug` не ломает поведение)

- [ ] **Step 5: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/UIView+CommonViewModel.swift \
       EmpUI_macOS/Sources/Common/NSView+CommonViewModel.swift
git commit -m "feat: реализовать apply(size:) в UIView/NSView extension"
```

---

### Task 6: Создать протоколы EComponent и ComponentViewModel (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/Protocols/ComponentViewModel.swift`
- Create: `EmpUI_iOS/Sources/Common/Protocols/EComponent.swift`

- [ ] **Step 1: Создать ComponentViewModel**

```swift
// EmpUI_iOS/Sources/Common/Protocols/ComponentViewModel.swift
import Foundation

public protocol ComponentViewModel: Equatable {
    var common: CommonViewModel { get }
}
```

- [ ] **Step 2: Создать EComponent**

```swift
// EmpUI_iOS/Sources/Common/Protocols/EComponent.swift
import UIKit

public protocol EComponent: UIView {
    associatedtype ViewModel: ComponentViewModel
    var viewModel: ViewModel { get }

    @discardableResult
    func configure(with viewModel: ViewModel) -> Self
}
```

- [ ] **Step 3: Собрать**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS`
Expected: BUILD SUCCEEDED

- [ ] **Step 4: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/Protocols/
git commit -m "feat(iOS): добавить протоколы EComponent и ComponentViewModel"
```

---

### Task 7: Создать протоколы EComponent и ComponentViewModel (macOS)

**Files:**
- Create: `EmpUI_macOS/Sources/Common/Protocols/ComponentViewModel.swift`
- Create: `EmpUI_macOS/Sources/Common/Protocols/EComponent.swift`

- [ ] **Step 1: Создать файлы**

```swift
// EmpUI_macOS/Sources/Common/Protocols/ComponentViewModel.swift
import Foundation

public protocol ComponentViewModel: Equatable {
    var common: CommonViewModel { get }
}
```

```swift
// EmpUI_macOS/Sources/Common/Protocols/EComponent.swift
import AppKit

public protocol EComponent: NSView {
    associatedtype ViewModel: ComponentViewModel
    var viewModel: ViewModel { get }

    @discardableResult
    func configure(with viewModel: ViewModel) -> Self
}
```

- [ ] **Step 2: Собрать**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpDesignSystem`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Коммит**

```bash
git add EmpUI_macOS/Sources/Common/Protocols/
git commit -m "feat(macOS): добавить протоколы EComponent и ComponentViewModel"
```

---

### Task 8: Переименовать Emp → E и добавить EComponent (iOS листовые)

Это самая масштабная задача фазы 1. Переименовываем все компоненты и добавляем conformance к `EComponent` + `ComponentViewModel`.

**Files:**
- Rename + Modify: `EmpUI_iOS/Sources/Components/EmpText/` → `EText/`
- Rename + Modify: `EmpUI_iOS/Sources/Components/EmpImage/` → `EImage/`
- Rename + Modify: `EmpUI_iOS/Sources/Components/EmpProgressBar/` → `EProgressBar/`
- Rename + Modify: `EmpUI_iOS/Sources/Components/EmpInfoCard/` → `EInfoCard/`
- Rename + Modify: `EmpUI_iOS/Sources/Components/EmpSegmentControl/` → `ESegmentControl/`
- Modify: все тест-файлы

**Важно:** Каждый компонент требует:
1. Rename класса `EmpX` → `EX`
2. Rename файлов и папок
3. Добавить `var viewModel: ViewModel` property
4. ViewModel conformance к `ComponentViewModel` (добавить `common` если его нет как первое поле)
5. Изменить `configure(with:)`: сохранять viewModel, возвращать `Self`, добавить `@discardableResult`
6. Добавить `: EComponent` conformance
7. Обновить тесты

Эта задача выполняется **для каждого компонента отдельно**. Ниже — EText как первый компонент. Остальные — по аналогии.

---

#### Task 8a: Переименовать EmpText → EText + EComponent (iOS)

**Files:**
- Rename: `EmpUI_iOS/Sources/Components/EmpText/` → `EmpUI_iOS/Sources/Components/EText/`
- Modify: все файлы внутри: `EText.swift`, `EText+ViewModel.swift`, `EText+Content.swift`, `EText+Preview.swift`
- Modify: `EmpUI_iOS/Tests/EmpTextTests.swift` → `EmpUI_iOS/Tests/ETextTests.swift`
- Modify: `EmpUI_iOS/Tests/EmpTextSnapshotTests.swift` → `EmpUI_iOS/Tests/ETextSnapshotTests.swift`

- [ ] **Step 1: Переименовать папку и файлы**

```bash
cd /Users/emp15/Developer/EmpDesignSystem
mv EmpUI_iOS/Sources/Components/EmpText EmpUI_iOS/Sources/Components/EText
mv EmpUI_iOS/Sources/Components/EText/EmpText.swift EmpUI_iOS/Sources/Components/EText/EText.swift
mv EmpUI_iOS/Sources/Components/EText/EmpText+ViewModel.swift EmpUI_iOS/Sources/Components/EText/EText+ViewModel.swift
mv EmpUI_iOS/Sources/Components/EText/EmpText+Content.swift EmpUI_iOS/Sources/Components/EText/EText+Content.swift
mv EmpUI_iOS/Sources/Components/EText/EmpText+Preview.swift EmpUI_iOS/Sources/Components/EText/EText+Preview.swift
mv EmpUI_iOS/Tests/EmpTextTests.swift EmpUI_iOS/Tests/ETextTests.swift
mv EmpUI_iOS/Tests/EmpTextSnapshotTests.swift EmpUI_iOS/Tests/ETextSnapshotTests.swift
```

- [ ] **Step 2: Обновить EText+ViewModel.swift — добавить ComponentViewModel**

```swift
// EmpUI_iOS/Sources/Components/EText/EText+ViewModel.swift
import UIKit

public extension EText {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let content: Content
        public let numberOfLines: Int
        public let alignment: NSTextAlignment

        public init(
            common: CommonViewModel = CommonViewModel(),
            content: Content,
            numberOfLines: Int = 0,
            alignment: NSTextAlignment = .natural
        ) {
            self.common = common
            self.content = content
            self.numberOfLines = numberOfLines
            self.alignment = alignment
        }
    }
}
```

- [ ] **Step 3: Обновить EText+Content.swift — rename**

Заменить все `EmpText` на `EText` в файле.

- [ ] **Step 4: Обновить EText.swift — добавить EComponent, хранение viewModel**

```swift
// EmpUI_iOS/Sources/Components/EText/EText.swift
import UIKit

public final class EText: UIView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel(content: .plain(.init(text: "")))

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)
        label.numberOfLines = viewModel.numberOfLines
        label.textAlignment = viewModel.alignment

        switch viewModel.content {
        case let .plain(plainText):
            label.attributedText = nil
            label.text = plainText.text
            label.font = plainText.font
            label.textColor = plainText.color
        case let .attributed(attributedString):
            label.attributedText = attributedString
        }

        invalidateIntrinsicContentSize()
        return self
    }

    override public var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        let margins = layoutMargins
        let width = labelSize.width == UIView.noIntrinsicMetric
            ? UIView.noIntrinsicMetric
            : labelSize.width + margins.left + margins.right
        let height = labelSize.height == UIView.noIntrinsicMetric
            ? UIView.noIntrinsicMetric
            : labelSize.height + margins.top + margins.bottom
        return CGSize(width: width, height: height)
    }
}
```

- [ ] **Step 5: Обновить EText+Preview.swift — rename**

Заменить все `EmpText` на `EText` в файле.

- [ ] **Step 6: Обновить тесты — rename**

В `ETextTests.swift` и `ETextSnapshotTests.swift` заменить все `EmpText` на `EText`.

- [ ] **Step 7: Собрать и запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -30`
Expected: все тесты проходят

- [ ] **Step 8: Коммит**

```bash
git add -A EmpUI_iOS/Sources/Components/EText/ EmpUI_iOS/Tests/ETextTests.swift \
         EmpUI_iOS/Tests/ETextSnapshotTests.swift
git add -A EmpUI_iOS/Sources/Components/EmpText/ EmpUI_iOS/Tests/EmpTextTests.swift \
         EmpUI_iOS/Tests/EmpTextSnapshotTests.swift
git commit -m "refactor(iOS): переименовать EmpText → EText, добавить EComponent"
```

---

#### Task 8b–8e: Повторить для EImage, EProgressBar, EInfoCard, ESegmentControl (iOS)

Для каждого компонента — та же последовательность что в Task 8a:
1. Переименовать папку и файлы (Emp → E)
2. Добавить `ComponentViewModel` conformance к ViewModel
3. Добавить `EComponent` conformance к классу: `var viewModel`, `@discardableResult`, `return Self`
4. Обновить тесты
5. Собрать и запустить тесты
6. Коммит

**Примечание:** У EmpImage ViewModel уже есть `common` как первое поле. У EmpProgressBar тоже. У EmpInfoCard и EmpSegmentControl — проверить и добавить если нет.

---

### Task 9: Повторить Task 8 для macOS

Та же последовательность для всех компонентов в `EmpUI_macOS/Sources/Components/`. Разница:
- `NSView` вместо `UIView`
- `EComponent: NSView` из macOS-версии протокола
- `NSColor`, `NSFont`, `NSEdgeInsets`
- `empLayoutMarginsGuide` вместо `layoutMarginsGuide`

---

### Task 10: Удалить EmpButton (iOS + macOS)

**Files:**
- Delete: `EmpUI_iOS/Sources/Components/EmpButton/` (целиком)
- Delete: `EmpUI_macOS/Sources/Components/EmpButton/` (целиком)
- Delete: `EmpUI_iOS/Tests/EmpButtonSnapshotTests.swift`
- Delete: `EmpUI_macOS/Tests/EmpButtonSnapshotTests.swift`
- Delete: `EmpUI_macOS/Tests/EmpButtonTests.swift`

- [ ] **Step 1: Удалить файлы**

```bash
rm -rf EmpUI_iOS/Sources/Components/EmpButton
rm -rf EmpUI_macOS/Sources/Components/EmpButton
rm -f EmpUI_iOS/Tests/EmpButtonSnapshotTests.swift
rm -f EmpUI_macOS/Tests/EmpButtonSnapshotTests.swift
rm -f EmpUI_macOS/Tests/EmpButtonTests.swift
```

- [ ] **Step 2: Собрать оба таргета**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS && mise exec -- tuist build EmpDesignSystem`
Expected: BUILD SUCCEEDED (ни один другой код не зависит от EmpButton)

- [ ] **Step 3: Запустить тесты**

Run: `mise exec -- tuist test EmpUI_iOS && mise exec -- tuist test EmpUI_macOS`
Expected: все оставшиеся тесты проходят

- [ ] **Step 4: Коммит**

```bash
git add -A
git commit -m "refactor: удалить EmpButton (заменяется ButtonPreset + ETapContainer)"
```

---

## Фаза 2: Descriptor Tree core (enum, fingerprint, builder)

### Task 11: ComponentDescriptor enum — leaf cases (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentDescriptor.swift`
- Create: `EmpUI_iOS/Tests/ComponentDescriptorTests.swift`

- [ ] **Step 1: Написать тесты**

```swift
// EmpUI_iOS/Tests/ComponentDescriptorTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("ComponentDescriptor")
struct ComponentDescriptorTests {

    @Test("Equatable — одинаковые text дескрипторы равны")
    func textEqual() {
        let a = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let b = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        #expect(a == b)
    }

    @Test("Equatable — разные text дескрипторы не равны")
    func textNotEqual() {
        let a = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let b = ComponentDescriptor.text(.init(content: .plain(.init(text: "Bye"))))
        #expect(a != b)
    }

    @Test("Equatable — разные типы не равны")
    func differentTypes() {
        let text = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let image = ComponentDescriptor.image(.init(image: UIImage(), size: .zero))
        #expect(text != image)
    }
}
```

- [ ] **Step 2: Запустить тесты — убедиться что не компилируются**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: ошибка — `ComponentDescriptor` не найден

- [ ] **Step 3: Создать ComponentDescriptor с leaf cases**

```swift
// EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentDescriptor.swift
import UIKit

public enum ComponentDescriptor: Equatable {

    // ═══════════════════════════════════════
    // Листовые компоненты (Content Views)
    // ═══════════════════════════════════════

    case text(EText.ViewModel)
    case image(EImage.ViewModel)
    case progressBar(EProgressBar.ViewModel)

    // ═══════════════════════════════════════
    // Составные компоненты
    // ═══════════════════════════════════════

    case infoCard(EInfoCard.ViewModel)
    case segmentControl(ESegmentControl.ViewModel)
}
```

- [ ] **Step 4: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты ComponentDescriptor проходят

- [ ] **Step 5: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentDescriptor.swift \
       EmpUI_iOS/Tests/ComponentDescriptorTests.swift
git commit -m "feat(iOS): добавить ComponentDescriptor enum — leaf cases"
```

---

### Task 12: StructureFingerprint (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/ComponentDescriptor/StructureFingerprint.swift`
- Create: `EmpUI_iOS/Tests/StructureFingerprintTests.swift`

- [ ] **Step 1: Написать тесты**

```swift
// EmpUI_iOS/Tests/StructureFingerprintTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("StructureFingerprint")
struct StructureFingerprintTests {

    @Test("Одинаковая структура — одинаковый fingerprint")
    func sameStructure() {
        let a = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hello"))))
        let b = ComponentDescriptor.text(.init(content: .plain(.init(text: "World"))))
        #expect(a.fingerprint == b.fingerprint)
    }

    @Test("Разная структура — разный fingerprint")
    func differentStructure() {
        let text = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hello"))))
        let image = ComponentDescriptor.image(.init(image: UIImage(), size: .zero))
        #expect(text.fingerprint != image.fingerprint)
    }

    @Test("Leaf fingerprint — hashable")
    func leafHashable() {
        let fp = StructureFingerprint.leaf("text")
        var set = Set<StructureFingerprint>()
        set.insert(fp)
        #expect(set.contains(.leaf("text")))
        #expect(!set.contains(.leaf("image")))
    }
}
```

- [ ] **Step 2: Создать StructureFingerprint + extension на ComponentDescriptor**

```swift
// EmpUI_iOS/Sources/Common/ComponentDescriptor/StructureFingerprint.swift
import Foundation

public enum StructureFingerprint: Hashable {
    case leaf(String)
    indirect case container(String, [StructureFingerprint])
}

extension ComponentDescriptor {
    public var fingerprint: StructureFingerprint {
        switch self {
        case .text:           return .leaf("text")
        case .image:          return .leaf("image")
        case .progressBar:    return .leaf("progressBar")
        case .infoCard:       return .leaf("infoCard")
        case .segmentControl: return .leaf("segmentControl")
        }
    }
}
```

- [ ] **Step 3: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты проходят

- [ ] **Step 4: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/ComponentDescriptor/StructureFingerprint.swift \
       EmpUI_iOS/Tests/StructureFingerprintTests.swift
git commit -m "feat(iOS): добавить StructureFingerprint — leaf cases"
```

---

### Task 13: ComponentBuilder — build + update для leaf cases (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift`
- Create: `EmpUI_iOS/Tests/ComponentBuilderTests.swift`

- [ ] **Step 1: Написать тесты**

```swift
// EmpUI_iOS/Tests/ComponentBuilderTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("ComponentBuilder.build")
struct ComponentBuilderBuildTests {

    @Test("build text создаёт EText")
    func buildText() {
        let view = ComponentBuilder.build(from: .text(.init(content: .plain(.init(text: "Hi")))))
        #expect(view is EText)
    }

    @Test("build image создаёт EImage")
    func buildImage() {
        let view = ComponentBuilder.build(from: .image(.init(image: UIImage(), size: CGSize(width: 10, height: 10))))
        #expect(view is EImage)
    }

    @Test("build сохраняет viewModel через EComponent")
    func buildStoresViewModel() throws {
        let vm = EText.ViewModel(content: .plain(.init(text: "Hi")))
        let view = ComponentBuilder.build(from: .text(vm))
        let text = try #require(view as? EText)
        #expect(text.viewModel == vm)
    }
}

@Suite("ComponentBuilder.update")
struct ComponentBuilderUpdateTests {

    @Test("update возвращает nil когда viewModel не изменилась (skip)")
    func skipWhenEqual() {
        let descriptor = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let view = ComponentBuilder.build(from: descriptor)
        let result = ComponentBuilder.update(view: view, with: descriptor)
        #expect(result == nil)
    }

    @Test("update обновляет viewModel на месте")
    func reconfigureInPlace() throws {
        let d1 = ComponentDescriptor.text(.init(content: .plain(.init(text: "Old"))))
        let view = ComponentBuilder.build(from: d1)

        let d2 = ComponentDescriptor.text(.init(content: .plain(.init(text: "New"))))
        let result = ComponentBuilder.update(view: view, with: d2)

        #expect(result == nil) // обновлено на месте
        let text = try #require(view as? EText)
        #expect(text.viewModel.content == .plain(.init(text: "New")))
    }

    @Test("update возвращает новый view когда тип не совпадает (rebuild)")
    func rebuildWhenTypeDiffers() {
        let d1 = ComponentDescriptor.text(.init(content: .plain(.init(text: "Hi"))))
        let view = ComponentBuilder.build(from: d1)

        let d2 = ComponentDescriptor.image(.init(image: UIImage(), size: CGSize(width: 10, height: 10)))
        let result = ComponentBuilder.update(view: view, with: d2)

        #expect(result != nil)
        #expect(result is EImage)
    }
}
```

- [ ] **Step 2: Создать ComponentBuilder**

```swift
// EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift
import UIKit

public enum ComponentBuilder {

    // ═══════════════════════════════════════
    // BUILD
    // ═══════════════════════════════════════

    public static func build(from descriptor: ComponentDescriptor) -> UIView {
        switch descriptor {
        case let .text(vm):
            let v = EText()
            v.configure(with: vm)
            return v

        case let .image(vm):
            let v = EImage()
            v.configure(with: vm)
            return v

        case let .progressBar(vm):
            let v = EProgressBar()
            v.configure(with: vm)
            return v

        case let .infoCard(vm):
            let v = EInfoCard()
            v.configure(with: vm)
            return v

        case let .segmentControl(vm):
            let v = ESegmentControl()
            v.configure(with: vm)
            return v
        }
    }

    // ═══════════════════════════════════════
    // UPDATE
    // ═══════════════════════════════════════

    @discardableResult
    public static func update(view: UIView, with new: ComponentDescriptor) -> UIView? {
        switch new {
        case let .text(newVM):
            guard let text = view as? EText else { return build(from: new) }
            if text.viewModel == newVM { return nil }
            text.configure(with: newVM)

        case let .image(newVM):
            guard let image = view as? EImage else { return build(from: new) }
            if image.viewModel == newVM { return nil }
            image.configure(with: newVM)

        case let .progressBar(newVM):
            guard let bar = view as? EProgressBar else { return build(from: new) }
            if bar.viewModel == newVM { return nil }
            bar.configure(with: newVM)

        case let .infoCard(newVM):
            guard let card = view as? EInfoCard else { return build(from: new) }
            if card.viewModel == newVM { return nil }
            card.configure(with: newVM)

        case let .segmentControl(newVM):
            guard let seg = view as? ESegmentControl else { return build(from: new) }
            if seg.viewModel == newVM { return nil }
            seg.configure(with: newVM)
        }

        return nil
    }

    // ═══════════════════════════════════════
    // RECONFIGURE
    // ═══════════════════════════════════════

    public static func reconfigure(view: UIView, with descriptor: ComponentDescriptor) {
        switch descriptor {
        case let .text(vm):
            (view as! EText).configure(with: vm)
        case let .image(vm):
            (view as! EImage).configure(with: vm)
        case let .progressBar(vm):
            (view as! EProgressBar).configure(with: vm)
        case let .infoCard(vm):
            (view as! EInfoCard).configure(with: vm)
        case let .segmentControl(vm):
            (view as! ESegmentControl).configure(with: vm)
        }
    }
}
```

- [ ] **Step 3: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты ComponentBuilder проходят

- [ ] **Step 4: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift \
       EmpUI_iOS/Tests/ComponentBuilderTests.swift
git commit -m "feat(iOS): добавить ComponentBuilder — build/update/reconfigure для leaf cases"
```

---

### Task 14: Повторить Tasks 11–13 для macOS

Зеркальная реализация с `NSView`, `NSColor`, `NSFont`, `NSEdgeInsets`. Структура идентична, отличаются только платформенные типы.

---

## Фаза 3: Контейнеры

### Task 15: EStack (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Components/EStack/EStack.swift`
- Create: `EmpUI_iOS/Sources/Components/EStack/EStack+ViewModel.swift`
- Create: `EmpUI_iOS/Tests/EStackTests.swift`

- [ ] **Step 1: Написать тесты**

```swift
// EmpUI_iOS/Tests/EStackTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("EStack")
struct EStackTests {

    @Test("ViewModel по умолчанию — horizontal, spacing 0, fill/fill")
    func defaultViewModel() {
        let vm = EStack.ViewModel()
        #expect(vm.axis == .horizontal)
        #expect(vm.spacing == 0)
        #expect(vm.alignment == .fill)
        #expect(vm.distribution == .fill)
    }

    @Test("configure устанавливает axis и spacing")
    func configureAppliesProperties() {
        let stack = EStack()
        stack.configure(with: .init(axis: .vertical, spacing: 8))
        #expect(stack.axis == .vertical)
        #expect(stack.spacing == 8)
    }

    @Test("configure сохраняет viewModel")
    func configureStoresViewModel() {
        let stack = EStack()
        let vm = EStack.ViewModel(axis: .vertical, spacing: 16)
        stack.configure(with: vm)
        #expect(stack.viewModel == vm)
    }

    @Test("configure возвращает Self")
    func configureReturnsSelf() {
        let stack = EStack()
        let returned = stack.configure(with: .init())
        #expect(stack === returned)
    }
}
```

- [ ] **Step 2: Создать EStack+ViewModel**

```swift
// EmpUI_iOS/Sources/Components/EStack/EStack+ViewModel.swift
import UIKit

public extension EStack {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let axis: NSLayoutConstraint.Axis
        public let spacing: CGFloat
        public let alignment: UIStackView.Alignment
        public let distribution: UIStackView.Distribution

        public init(
            common: CommonViewModel = CommonViewModel(),
            axis: NSLayoutConstraint.Axis = .horizontal,
            spacing: CGFloat = 0,
            alignment: UIStackView.Alignment = .fill,
            distribution: UIStackView.Distribution = .fill
        ) {
            self.common = common
            self.axis = axis
            self.spacing = spacing
            self.alignment = alignment
            self.distribution = distribution
        }
    }
}
```

- [ ] **Step 3: Создать EStack**

```swift
// EmpUI_iOS/Sources/Components/EStack/EStack.swift
import UIKit

public final class EStack: UIStackView, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel()

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        axis = viewModel.axis
        spacing = viewModel.spacing
        alignment = viewModel.alignment
        distribution = viewModel.distribution
        apply(common: viewModel.common)
        return self
    }
}
```

- [ ] **Step 4: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты EStack проходят

- [ ] **Step 5: Коммит**

```bash
git add EmpUI_iOS/Sources/Components/EStack/ EmpUI_iOS/Tests/EStackTests.swift
git commit -m "feat(iOS): добавить EStack — UIStackView + EComponent"
```

---

### Task 16: EOverlay, ESpacer, EScroll (iOS)

Аналогично Task 15 для каждого контейнера. Краткие описания:

**EOverlay** — UIView, дети накладываются друг на друга (constraints к краям parent).

**ESpacer** — UIView, `length: CGFloat?` (nil = flexible, CGFloat = фиксированный размер вдоль axis).

**EScroll** — UIScrollView, один child, axis определяет направление скролла.

Каждый: ViewModel + EComponent + тесты + коммит.

---

### Task 17: Container cases в ComponentDescriptor (iOS)

**Files:**
- Modify: `EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentDescriptor.swift`
- Modify: `EmpUI_iOS/Sources/Common/ComponentDescriptor/StructureFingerprint.swift`
- Modify: `EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift`
- Modify: `EmpUI_iOS/Tests/ComponentDescriptorTests.swift`
- Modify: `EmpUI_iOS/Tests/StructureFingerprintTests.swift`
- Modify: `EmpUI_iOS/Tests/ComponentBuilderTests.swift`

- [ ] **Step 1: Добавить тесты для контейнеров**

```swift
// Добавить в ComponentDescriptorTests.swift
@Test("Stack descriptor — equatable")
func stackEqual() {
    let a = ComponentDescriptor.stack(.init(axis: .horizontal, spacing: 8), [
        .text(.init(content: .plain(.init(text: "A")))),
    ])
    let b = ComponentDescriptor.stack(.init(axis: .horizontal, spacing: 8), [
        .text(.init(content: .plain(.init(text: "A")))),
    ])
    #expect(a == b)
}

@Test("Stack descriptor — разные дети не равны")
func stackChildrenNotEqual() {
    let a = ComponentDescriptor.stack(.init(), [
        .text(.init(content: .plain(.init(text: "A")))),
    ])
    let b = ComponentDescriptor.stack(.init(), [
        .text(.init(content: .plain(.init(text: "B")))),
    ])
    #expect(a != b)
}
```

```swift
// Добавить в StructureFingerprintTests.swift
@Test("Container fingerprint учитывает children")
func containerFingerprint() {
    let a = ComponentDescriptor.stack(.init(), [.text(.init(content: .plain(.init(text: "A"))))])
    let b = ComponentDescriptor.stack(.init(), [.image(.init(image: UIImage(), size: .zero))])
    #expect(a.fingerprint != b.fingerprint)
}

@Test("Разное количество children — разный fingerprint")
func differentChildCount() {
    let a = ComponentDescriptor.stack(.init(), [
        .text(.init(content: .plain(.init(text: "A")))),
    ])
    let b = ComponentDescriptor.stack(.init(), [
        .text(.init(content: .plain(.init(text: "A")))),
        .text(.init(content: .plain(.init(text: "B")))),
    ])
    #expect(a.fingerprint != b.fingerprint)
}
```

```swift
// Добавить в ComponentBuilderTests.swift
@Test("build stack создаёт EStack с children")
func buildStack() throws {
    let descriptor = ComponentDescriptor.stack(
        .init(axis: .horizontal, spacing: 8),
        [
            .text(.init(content: .plain(.init(text: "A")))),
            .text(.init(content: .plain(.init(text: "B")))),
        ]
    )
    let view = ComponentBuilder.build(from: descriptor)
    let stack = try #require(view as? EStack)
    #expect(stack.arrangedSubviews.count == 2)
    #expect(stack.spacing == 8)
    #expect(stack.axis == .horizontal)
}

@Test("update stack — skip неизменённые children")
func updateStackSkipChildren() throws {
    let unchanged = ComponentDescriptor.text(.init(content: .plain(.init(text: "Static"))))
    let d1 = ComponentDescriptor.stack(.init(), [
        unchanged,
        .text(.init(content: .plain(.init(text: "Old")))),
    ])
    let view = ComponentBuilder.build(from: d1)
    let stack = try #require(view as? EStack)
    let staticView = stack.arrangedSubviews[0]

    let d2 = ComponentDescriptor.stack(.init(), [
        unchanged,
        .text(.init(content: .plain(.init(text: "New")))),
    ])
    ComponentBuilder.update(view: view, with: d2)

    #expect(stack.arrangedSubviews[0] === staticView) // тот же instance
    let updatedText = try #require(stack.arrangedSubviews[1] as? EText)
    #expect(updatedText.viewModel.content == .plain(.init(text: "New")))
}
```

- [ ] **Step 2: Добавить container cases в enum**

В `ComponentDescriptor.swift` добавить:

```swift
    // Контейнеры
    indirect case stack(EStack.ViewModel, [ComponentDescriptor])
    indirect case overlay(EOverlay.ViewModel, [ComponentDescriptor])
    case spacer(ESpacer.ViewModel)
    indirect case scroll(EScroll.ViewModel, ComponentDescriptor)
```

- [ ] **Step 3: Обновить fingerprint**

В `StructureFingerprint.swift` добавить cases в switch:

```swift
case let .stack(_, children):
    return .container("stack", children.map(\.fingerprint))
case let .overlay(_, children):
    return .container("overlay", children.map(\.fingerprint))
case .spacer:
    return .leaf("spacer")
case let .scroll(_, child):
    return .container("scroll", [child.fingerprint])
```

- [ ] **Step 4: Обновить ComponentBuilder — build, update, reconfigure**

Добавить container cases в каждый из трёх методов. Код — из спецификации `docs/descriptor-tree-design.md`, секция Layer 3.

- [ ] **Step 5: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -30`
Expected: все тесты проходят

- [ ] **Step 6: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/ComponentDescriptor/ EmpUI_iOS/Tests/
git commit -m "feat(iOS): добавить container cases в ComponentDescriptor + builder"
```

---

## Фаза 4: ETapContainer и интерактивность

### Task 18: ETapContainer (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Components/ETapContainer/ETapContainer.swift`
- Create: `EmpUI_iOS/Sources/Components/ETapContainer/ETapContainer+ViewModel.swift`
- Create: `EmpUI_iOS/Sources/Components/ETapContainer/ETapContainer+Action.swift`
- Create: `EmpUI_iOS/Tests/ETapContainerTests.swift`

- [ ] **Step 1: Написать тесты**

```swift
// EmpUI_iOS/Tests/ETapContainerTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("ETapContainer")
struct ETapContainerTests {

    @Test("State transitions вызывают onStateChange")
    func stateTransitions() {
        let tap = ETapContainer()
        tap.configure(with: .init(action: .init(id: "test") { _ in }))
        var states: [ControlState] = []
        tap.onStateChange = { states.append($0) }

        tap.isHighlighted = true
        tap.isHighlighted = false
        tap.isEnabled = false

        #expect(states == [.highlighted, .normal, .disabled])
    }

    @Test("Action handler получает текущую ViewModel")
    func actionReceivesViewModel() {
        var receivedID: String?
        let vm = ETapContainer.ViewModel(
            action: .init(id: "pay") { vm in
                receivedID = vm.action.id
            }
        )
        let tap = ETapContainer()
        tap.configure(with: vm)
        tap.viewModel.action.handler(tap.viewModel)

        #expect(receivedID == "pay")
    }

    @Test("Action equatable по id")
    func actionEquatable() {
        let a = ETapContainer.ViewModel.Action(id: "x") { _ in }
        let b = ETapContainer.ViewModel.Action(id: "x") { _ in }
        let c = ETapContainer.ViewModel.Action(id: "y") { _ in }
        #expect(a == b)
        #expect(a != c)
    }

    @Test("configure сохраняет viewModel")
    func configureStoresViewModel() {
        let tap = ETapContainer()
        let vm = ETapContainer.ViewModel(action: .init(id: "test") { _ in })
        tap.configure(with: vm)
        #expect(tap.viewModel.action.id == "test")
    }
}
```

- [ ] **Step 2: Создать Action**

```swift
// EmpUI_iOS/Sources/Components/ETapContainer/ETapContainer+Action.swift
import Foundation

public extension ETapContainer.ViewModel {
    struct Action: Equatable {
        public let id: String
        public var handler: (ETapContainer.ViewModel) -> Void

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }

        public init(id: String, handler: @escaping (ETapContainer.ViewModel) -> Void) {
            self.id = id
            self.handler = handler
        }
    }
}
```

- [ ] **Step 3: Создать ViewModel**

```swift
// EmpUI_iOS/Sources/Components/ETapContainer/ETapContainer+ViewModel.swift
import UIKit

public extension ETapContainer {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public var action: Action
        public var longPress: Action?

        public init(
            common: CommonViewModel = CommonViewModel(),
            action: Action,
            longPress: Action? = nil
        ) {
            self.common = common
            self.action = action
            self.longPress = longPress
        }
    }
}
```

- [ ] **Step 4: Создать ETapContainer**

```swift
// EmpUI_iOS/Sources/Components/ETapContainer/ETapContainer.swift
import UIKit

public final class ETapContainer: UIControl, EComponent {

    public private(set) var viewModel: ViewModel = ViewModel(
        action: .init(id: "", handler: { _ in })
    )
    public private(set) var contentView: UIView?
    private var isHovered = false

    var onStateChange: ((ControlState) -> Void)?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    // ─── EComponent ───

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        if viewModel.longPress != nil {
            let lp = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            addGestureRecognizer(lp)
        }

        return self
    }

    // ─── Content ───

    public func setContent(_ view: UIView) {
        contentView?.removeFromSuperview()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        contentView = view
    }

    // ─── Actions ───

    @objc private func handleTap() {
        viewModel.action.handler(viewModel)
    }

    @objc private func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        viewModel.longPress?.handler(viewModel)
    }

    // ─── State ───

    public var currentState: ControlState {
        if !isEnabled { return .disabled }
        if isHighlighted { return .highlighted }
        if isHovered { return .hover }
        return .normal
    }

    private func updateAppearance() {
        onStateChange?(currentState)
    }

    override public var isHighlighted: Bool { didSet { updateAppearance() } }
    override public var isEnabled: Bool { didSet { updateAppearance() } }
}
```

- [ ] **Step 5: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты ETapContainer проходят

- [ ] **Step 6: Коммит**

```bash
git add EmpUI_iOS/Sources/Components/ETapContainer/ EmpUI_iOS/Tests/ETapContainerTests.swift
git commit -m "feat(iOS): добавить ETapContainer с Action"
```

---

### Task 19: tap case в ComponentDescriptor + builder (iOS)

**Files:**
- Modify: `EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentDescriptor.swift`
- Modify: `EmpUI_iOS/Sources/Common/ComponentDescriptor/StructureFingerprint.swift`
- Modify: `EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift`
- Modify: `EmpUI_iOS/Tests/ComponentBuilderTests.swift`

- [ ] **Step 1: Добавить tap case в enum**

```swift
indirect case tap(ETapContainer.ViewModel, ControlParameter<ComponentDescriptor>)
```

- [ ] **Step 2: Обновить fingerprint**

```swift
case let .tap(_, content):
    return .container("tap", [content.normal.fingerprint])
```

- [ ] **Step 3: Обновить ComponentBuilder — build, update, reconfigure для tap**

Код из спецификации — секция Layer 3.

- [ ] **Step 4: Добавить тест**

```swift
@Test("build tap создаёт ETapContainer с content")
func buildTap() throws {
    let descriptor = ComponentDescriptor.tap(
        .init(action: .init(id: "test") { _ in }),
        ControlParameter(
            normal: .text(.init(content: .plain(.init(text: "Tap me"))))
        )
    )
    let view = ComponentBuilder.build(from: descriptor)
    let tap = try #require(view as? ETapContainer)
    #expect(tap.contentView is EText)
}
```

- [ ] **Step 5: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты проходят

- [ ] **Step 6: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/ComponentDescriptor/ EmpUI_iOS/Tests/ComponentBuilderTests.swift
git commit -m "feat(iOS): добавить tap case в ComponentDescriptor + builder"
```

---

## Фаза 5: Result Builder и фабрики

### Task 20: DescriptorBuilder + фабрики (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/ComponentDescriptor/DescriptorBuilder.swift`
- Create: `EmpUI_iOS/Tests/DescriptorBuilderTests.swift`

- [ ] **Step 1: Написать тесты**

```swift
// EmpUI_iOS/Tests/DescriptorBuilderTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("DescriptorBuilder")
struct DescriptorBuilderTests {

    @Test("stack builder создаёт правильную структуру")
    func stackBuilder() {
        let descriptor: ComponentDescriptor = .stack(.init(axis: .vertical, spacing: 8)) {
            .text(.init(content: .plain(.init(text: "A"))))
            .text(.init(content: .plain(.init(text: "B"))))
        }
        guard case let .stack(vm, children) = descriptor else {
            Issue.record("Expected .stack")
            return
        }
        #expect(vm.axis == .vertical)
        #expect(vm.spacing == 8)
        #expect(children.count == 2)
    }

    @Test("builder поддерживает if/else")
    func conditionalBuilder() {
        let showImage = true
        let descriptor: ComponentDescriptor = .stack(.init()) {
            .text(.init(content: .plain(.init(text: "A"))))
            if showImage {
                .image(.init(image: UIImage(), size: CGSize(width: 10, height: 10)))
            }
        }
        guard case let .stack(_, children) = descriptor else {
            Issue.record("Expected .stack")
            return
        }
        #expect(children.count == 2)
    }

    @Test("builder поддерживает for-in")
    func forInBuilder() {
        let names = ["A", "B", "C"]
        let descriptor: ComponentDescriptor = .stack(.init()) {
            for name in names {
                .text(.init(content: .plain(.init(text: name))))
            }
        }
        guard case let .stack(_, children) = descriptor else {
            Issue.record("Expected .stack")
            return
        }
        #expect(children.count == 3)
    }
}
```

- [ ] **Step 2: Создать DescriptorBuilder**

```swift
// EmpUI_iOS/Sources/Common/ComponentDescriptor/DescriptorBuilder.swift
import UIKit

@resultBuilder
public struct DescriptorBuilder {
    public static func buildBlock(_ components: ComponentDescriptor...) -> [ComponentDescriptor] {
        components
    }

    public static func buildEither(first component: [ComponentDescriptor]) -> [ComponentDescriptor] {
        component
    }

    public static func buildEither(second component: [ComponentDescriptor]) -> [ComponentDescriptor] {
        component
    }

    public static func buildOptional(_ component: [ComponentDescriptor]?) -> [ComponentDescriptor] {
        component ?? []
    }

    public static func buildArray(_ components: [[ComponentDescriptor]]) -> [ComponentDescriptor] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: ComponentDescriptor) -> [ComponentDescriptor] {
        [expression]
    }
}

// ─── Фабрики с trailing closure ───

public extension ComponentDescriptor {

    static func stack(
        _ viewModel: EStack.ViewModel = EStack.ViewModel(),
        @DescriptorBuilder children: () -> [ComponentDescriptor]
    ) -> ComponentDescriptor {
        .stack(viewModel, children())
    }

    static func overlay(
        _ viewModel: EOverlay.ViewModel = EOverlay.ViewModel(),
        @DescriptorBuilder children: () -> [ComponentDescriptor]
    ) -> ComponentDescriptor {
        .overlay(viewModel, children())
    }

    static func tap(
        _ viewModel: ETapContainer.ViewModel,
        content: () -> ControlParameter<ComponentDescriptor>
    ) -> ComponentDescriptor {
        .tap(viewModel, content())
    }

    static func scroll(
        _ viewModel: EScroll.ViewModel = EScroll.ViewModel(),
        child: () -> ComponentDescriptor
    ) -> ComponentDescriptor {
        .scroll(viewModel, child())
    }
}
```

- [ ] **Step 3: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты проходят

- [ ] **Step 4: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/ComponentDescriptor/DescriptorBuilder.swift \
       EmpUI_iOS/Tests/DescriptorBuilderTests.swift
git commit -m "feat(iOS): добавить DescriptorBuilder (result builder) + фабрики"
```

---

## Фаза 6: Коллекции

### Task 21: EItem + ECollectionCell (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Common/Collection/EItem.swift`
- Create: `EmpUI_iOS/Sources/Common/Collection/ECollectionCell.swift`
- Create: `EmpUI_iOS/Tests/EItemTests.swift`
- Create: `EmpUI_iOS/Tests/ECollectionCellTests.swift`

- [ ] **Step 1: Написать тесты EItem**

```swift
// EmpUI_iOS/Tests/EItemTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("EItem")
struct EItemTests {

    @Test("Hashable — одинаковый id, одинаковый hash")
    func hashableById() {
        let a = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        let b = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "B")))))
        #expect(a.hashValue == b.hashValue)
    }

    @Test("Equatable — одинаковый id + одинаковые данные → равны")
    func equalSameIdSameData() {
        let a = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        let b = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        #expect(a == b)
    }

    @Test("Equatable — одинаковый id + разные данные → не равны")
    func notEqualSameIdDifferentData() {
        let a = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "A")))))
        let b = EItem(id: "1", descriptor: .text(.init(content: .plain(.init(text: "B")))))
        #expect(a != b)
    }
}
```

- [ ] **Step 2: Создать EItem**

```swift
// EmpUI_iOS/Sources/Common/Collection/EItem.swift
import Foundation

public struct EItem: Hashable {
    public let id: AnyHashable
    public let descriptor: ComponentDescriptor

    public init(id: some Hashable, descriptor: ComponentDescriptor) {
        self.id = AnyHashable(id)
        self.descriptor = descriptor
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.descriptor == rhs.descriptor
    }
}
```

- [ ] **Step 3: Создать ECollectionCell**

```swift
// EmpUI_iOS/Sources/Common/Collection/ECollectionCell.swift
import UIKit

public final class ECollectionCell: UICollectionViewCell {
    private var rootView: UIView?
    private var currentFingerprint: StructureFingerprint?

    public func configure(with descriptor: ComponentDescriptor) {
        let fp = descriptor.fingerprint

        if fp == currentFingerprint, let root = rootView {
            ComponentBuilder.update(view: root, with: descriptor)
        } else {
            rootView?.removeFromSuperview()

            let view = ComponentBuilder.build(from: descriptor)
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: contentView.topAnchor),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])

            rootView = view
            currentFingerprint = fp
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }
}
```

- [ ] **Step 4: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты проходят

- [ ] **Step 5: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/Collection/ EmpUI_iOS/Tests/EItemTests.swift \
       EmpUI_iOS/Tests/ECollectionCellTests.swift
git commit -m "feat(iOS): добавить EItem + ECollectionCell для DiffableDataSource"
```

---

## Фаза 7: ButtonPreset и финализация

### Task 22: ButtonPreset фабрики (iOS)

**Files:**
- Create: `EmpUI_iOS/Sources/Components/ETapContainer/ButtonPreset.swift`
- Create: `EmpUI_iOS/Tests/ButtonPresetTests.swift`

- [ ] **Step 1: Написать тест**

```swift
// EmpUI_iOS/Tests/ButtonPresetTests.swift
import Testing
import UIKit
@testable import EmpUI_iOS

@Suite("ButtonPreset")
struct ButtonPresetTests {

    @Test("filled генерирует структурно-консистентные состояния")
    func filledConsistency() {
        let button = ComponentDescriptor.ButtonPreset.filled(
            .primary,
            title: "Test",
            action: .init(id: "test") { _ in }
        )
        guard case let .tap(_, content) = button else {
            Issue.record("Expected .tap case")
            return
        }
        #expect(content.isStructurallyConsistent)
    }

    @Test("filled возвращает .tap case")
    func filledIsTap() {
        let button = ComponentDescriptor.ButtonPreset.filled(
            .primary,
            title: "Pay",
            action: .init(id: "pay") { _ in }
        )
        guard case .tap = button else {
            Issue.record("Expected .tap case")
            return
        }
    }
}
```

- [ ] **Step 2: Создать ButtonPreset**

Реализация из спецификации — `docs/descriptor-tree-design.md`, секция "Button Presets". Включает `filled`, `outlined`, `ghost`, `base` фабрики.

- [ ] **Step 3: Добавить isStructurallyConsistent**

```swift
// Добавить в ControlParameter extension (в ControlParameter.swift или отдельный файл)
extension ControlParameter where T == ComponentDescriptor {
    public var isStructurallyConsistent: Bool {
        let fp = normal.fingerprint
        return hover.fingerprint == fp
            && highlighted.fingerprint == fp
            && disabled.fingerprint == fp
    }
}
```

- [ ] **Step 4: Запустить тесты**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS 2>&1 | tail -20`
Expected: все тесты проходят

- [ ] **Step 5: Коммит**

```bash
git add EmpUI_iOS/Sources/Components/ETapContainer/ButtonPreset.swift \
       EmpUI_iOS/Tests/ButtonPresetTests.swift
git commit -m "feat(iOS): добавить ButtonPreset фабрики (filled, outlined, ghost, base)"
```

---

### Task 23: Повторить Фазы 3–7 для macOS

Зеркальная реализация всех контейнеров, ETapContainer, DescriptorBuilder, EItem, ECollectionCell, ButtonPreset для macOS. Разница только в платформенных типах.

---

### Task 24: Debug logging (iOS + macOS)

**Files:**
- Modify: `EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift`
- Modify: `EmpUI_macOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift`

- [ ] **Step 1: Добавить logging в ComponentBuilder**

```swift
import os

public enum ComponentBuilder {

    public static var isLoggingEnabled: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()

    static func log(_ message: @autoclosure () -> String) {
        guard isLoggingEnabled else { return }
        os_log("[EDS] %{public}@", log: .default, type: .debug, message())
    }

    // В build: log("BUILD: \(descriptor.fingerprint)")
    // В update при skip: log("SKIP: fingerprint=\(new.fingerprint)")
    // В update при rebuild: log("⚠️ REBUILD: type mismatch")
    // В update при reconfigure: log("UPDATE: \(new.fingerprint)")
}
```

- [ ] **Step 2: Собрать оба таргета**

Run: `mise exec -- tuist generate --no-open && mise exec -- tuist build EmpUI_iOS && mise exec -- tuist build EmpDesignSystem`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Коммит**

```bash
git add EmpUI_iOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift \
       EmpUI_macOS/Sources/Common/ComponentDescriptor/ComponentBuilder.swift
git commit -m "feat: добавить debug logging в ComponentBuilder"
```

---

### Task 25: Финальная проверка — все тесты обеих платформ

- [ ] **Step 1: Полная сборка и тесты iOS**

Run: `mise exec -- tuist clean && mise exec -- tuist install && mise exec -- tuist generate --no-open && mise exec -- tuist test EmpUI_iOS`
Expected: все тесты проходят

- [ ] **Step 2: Полная сборка и тесты macOS**

Run: `mise exec -- tuist test EmpUI_macOS`
Expected: все тесты проходят

- [ ] **Step 3: Сборка sandbox app**

Run: `mise exec -- tuist build EmpDesignSystem`
Expected: BUILD SUCCEEDED

---

## Зависимости между задачами

```
Task 1 (удалить черновой код)
    └── Task 4 (size в CommonViewModel)
            └── Task 5 (apply size)

Task 2–3 (SizeViewModel iOS/macOS) ──── Task 4

Task 6–7 (протоколы iOS/macOS) ──────── Task 8–9 (rename + EComponent)
                                              └── Task 10 (удалить EmpButton)
                                              └── Task 11 (ComponentDescriptor)
                                                    └── Task 12 (Fingerprint)
                                                    └── Task 13 (ComponentBuilder)
                                                          └── Task 17 (containers в enum)
                                                                └── Task 20 (DescriptorBuilder)
                                                                └── Task 21 (EItem + Cell)

Task 15–16 (EStack, EOverlay...) ────── Task 17

Task 18 (ETapContainer) ────────────── Task 19 (tap case)
                                              └── Task 22 (ButtonPreset)

Task 23 = повтор фаз 3–7 для macOS
Task 24 = logging
Task 25 = финальная проверка
```
