# Подходы к описанию UI и стилизации компонентов

## Контекст

Фундаментальный вопрос: как токены попадают в компоненты и как описать UI-дерево так, чтобы:
- Generic UICollectionViewCell мог принять любой компонент
- При reuse проверялась структура: если та же — только реконфигурация, без пересоздания
- Сложные вложенные структуры (TapWrapper → HStack → [VStack[Text, Text], VStack[Text, Text]]) работали эффективно

---

## Исследование: как это делают другие

### React — Virtual DOM и Reconciliation

**Абстракция**: React Element — легковесный иммутабельный объект `{ type, props, children }`. Компонент — функция, возвращающая Elements. Внутренне каждый элемент представлен как **Fiber** — мутабельная структура, хранящая состояние и ссылку на DOM.

**Reconciliation (Fiber)** работает в две фазы:
- **Render phase** (асинхронная): обход Fiber-дерева, вызов render, построение workInProgress tree. Может быть прервана.
- **Commit phase** (синхронная): применение изменений к реальному DOM.

Алгоритм диффинга — эвристический O(n):
1. Разные типы элементов → старое поддерево уничтожается, строится новое
2. `key` — стабильная идентичность в списках. Без key — сравнение по позиции

**Reuse в списках**: React не имеет встроенного cell reuse. Для виртуализации — `react-window`, `react-virtuoso` (рендерят только видимый диапазон).

---

### SwiftUI — View protocol и AttributeGraph

**Абстракция**: `View` — протокол с `var body: some View`. View — value type (struct), дешёвый, создаётся заново при каждом обновлении.

Компилятор раскрывает `body` в конкретный generic-тип:
```
VStack<TupleView<(Text, Optional<Text>, Button<Text>)>>
```

**Два вида идентичности**:
- **Structural**: позиция view в иерархии типов. `if/else` → `_ConditionalContent<A, B>`
- **Explicit**: `.id(value)` или `ForEach(data, id: \.keyPath)`

**Диффинг**: AttributeGraph строит граф зависимостей. При изменении `@State`/`@ObservedObject` инвалидируются только зависимые view, сравниваются через Equatable.

**Reuse в списках**: `List`/`LazyVStack` — ленивая загрузка, `ForEach` с `id:` для стабильной идентичности.

---

### Jetpack Compose — Slot Table и Recomposition

**Абстракция**: `@Composable` функция — компилятор добавляет скрытые параметры (`$composer`, `$changed`). Функция не возвращает view, а записывает слоты в Slot Table.

**Slot Table** — gap buffer. Каждый вызов composable записывает группу (ключ + данные + дочерние). `remember { }` привязывает значение к позиции вызова в коде.

**Что перекомпоновать**: `$changed` — битовая маска (3 бита на параметр). Если параметры стабильны и не изменились — composable пропускается.

**Reuse в списках**: `LazyColumn` + `key { }` для привязки identity к данным.

---

### Epoxy (Airbnb, iOS)

**Абстракция**: Разделение на **Content** (данные, меняются часто) и **Style** (визуальный стиль, не меняется). View → `ItemModel` → `SectionModel`.

```swift
final class TextRow: UIView, EpoxyableView {
    struct Content: Equatable { let title: String }
    struct Style: Hashable { let font: UIFont }
    func setContent(_ content: Content, animated: Bool) { ... }
}
```

**Диффинг**: Paul Heckel O(n). `dataID` — идентичность, `Content: Equatable` — нужна ли реконфигурация.

**Reuse**: `reuseIdentifier` = тип View + хэш Style. Content применяется через `setContent(_:animated:)`.

---

### IGListKit (Instagram, iOS)

**Абстракция**: `ListDiffable` — `diffIdentifier()` + `isEqual(toDiffableObject:)`. `ListSectionController` управляет одной секцией.

**Диффинг**: Paul Heckel O(n). Два уровня: `diffIdentifier` (insert/delete/move), `isEqual` (reload).

**Reuse**: Стандартный UICollectionView cell reuse. IGListKit управляет только секциями.

---

### ComponentKit (Facebook, iOS)

**Абстракция**: `CKComponent` — иммутабельный объект, описывающий конфигурацию view. НЕ сам view. Создаётся на фоновом потоке.

**Mount/Unmount**:
1. Build: фоновый поток, строится дерево компонентов
2. Layout: фоновый поток, вычисляются размеры/позиции
3. Mount: главный поток, создаются/переиспользуются UIView
4. Unmount: view возвращается в пул

**Reuse**: UIView'ы переиспользуются по классу + набору атрибутов.

---

### Texture / AsyncDisplayKit (Pinterest, iOS)

**Абстракция**: `ASDisplayNode` — потокобезопасная обёртка над UIView/CALayer. View создаётся лениво. Layout через `ASLayoutSpec` — описание как дерево спецификаций.

**Принципиальное отличие**: **ASCollectionNode НЕ переиспользует ячейки**. 1 элемент = 1 node. Это возможно потому что node'ы легковесные, а тяжёлые UIView создаются лениво.

---

## Сводная таблица фреймворков

| | Абстракция | Дерево как данные | Диффинг | Reuse в списках |
|---|---|---|---|---|
| **React** | Element (объект) → Fiber | Virtual DOM tree | O(n) эвристический, key-based | Виртуализация через библиотеки |
| **SwiftUI** | View (struct) | Generic type tree + AttributeGraph | Тип-based + Equatable | Lazy loading, ForEach с id |
| **Compose** | @Composable → Slot Table | Gap buffer | Positional memoization + $changed | LazyColumn + key { } |
| **Epoxy** | EpoxyableView → ItemModel | Array\<SectionModel\> | Paul Heckel O(n) | UICollectionView reuse по Type+Style |
| **IGListKit** | ListDiffable → SectionController | Array\<ListDiffable\> | Paul Heckel O(n) | Стандартный UICollectionView reuse |
| **ComponentKit** | CKComponent (immutable) | Immutable component tree | Сравнение деревьев при mount | UIView reuse pool |
| **Texture** | ASDisplayNode (thread-safe) | Node + ASLayoutSpec tree | RangeController | **Нет reuse** — 1 node = 1 элемент |

---

## Три подхода для EmpDesignSystem

### Подход 1: Component Descriptor Tree (по мотивам ComponentKit / Epoxy)

UI описывается как **иммутабельное дерево дескрипторов**. Каждый дескриптор знает тип компонента и данные.

```swift
// Описание UI — чистые данные, нет UIView
let cell = Emp.tap(action: onTap) {
    Emp.hStack(spacing: .xs) {
        Emp.vStack(spacing: .xxs) {
            Emp.text(.plain("Баланс", font: .caption, color: .textSecondary))
            Emp.text(.plain("12 400 ₽", font: .title2, color: .textPrimary))
        }
        Emp.vStack(spacing: .xxs) {
            Emp.text(.plain("Кэшбэк", font: .caption, color: .textSecondary))
            Emp.text(.plain("340 ₽", font: .title2, color: .textAccent))
        }
    }
}

// Тип — рекурсивный enum
enum ComponentDescriptor {
    case text(EmpText.ViewModel)
    case image(EmpImage.ViewModel)
    case progressBar(EmpProgressBar.ViewModel)
    // ...листовые компоненты

    // контейнеры
    indirect case hStack(spacing: CGFloat, children: [ComponentDescriptor])
    indirect case vStack(spacing: CGFloat, children: [ComponentDescriptor])
    indirect case tap(common: ControlParameter<CommonViewModel>,
                      action: () -> Void, child: ComponentDescriptor)
}
```

**Структурный fingerprint = reuseIdentifier:**

```swift
enum StructureFingerprint: Hashable {
    case leaf(String)                                       // "text", "image"
    indirect case container(String, [StructureFingerprint]) // "hStack", [children]
}

extension ComponentDescriptor {
    var fingerprint: StructureFingerprint {
        switch self {
        case .text:        return .leaf("text")
        case .image:       return .leaf("image")
        case .hStack(_, let children):
            return .container("hStack", children.map(\.fingerprint))
        case .vStack(_, let children):
            return .container("vStack", children.map(\.fingerprint))
        case .tap(_, _, let child):
            return .container("tap", [child.fingerprint])
        // ...
        }
    }
}
```

**Generic cell:**

```swift
final class EmpCollectionCell: UICollectionViewCell {
    private var rootView: UIView?
    private var currentFingerprint: StructureFingerprint?

    func configure(with descriptor: ComponentDescriptor) {
        let newFingerprint = descriptor.fingerprint

        if newFingerprint == currentFingerprint, let existing = rootView {
            // Структура та же — только реконфигурация
            reconfigure(view: existing, with: descriptor)
        } else {
            // Структура другая — пересоздание
            rootView?.removeFromSuperview()
            let view = build(from: descriptor)
            contentView.addSubview(view)
            rootView = view
            currentFingerprint = newFingerprint
        }
    }
}
```

| Плюсы | Минусы |
|---|---|
| Полный контроль создания/реконфигурации | Enum растёт с каждым компонентом |
| Fingerprint как reuseID — UICollectionView подбирает нужную ячейку | Closures ломают Equatable (решается через actionID) |
| ViewModel'ы уже Equatable | build() и reconfigure() — два пути, нужно синхронизировать |
| Компилятор проверяет exhaustive switch | |

---

### Подход 2: Type-erased Protocol Models (по мотивам IGListKit / Epoxy)

Каждый компонент реализует протокол. Нет центрального enum.

```swift
protocol EmpComponentModel {
    var reuseIdentifier: String { get }
    var dataID: AnyHashable { get }
    func makeView() -> UIView
    func configure(view: UIView)
    func isContentEqual(to other: EmpComponentModel) -> Bool
}

// Конкретная модель
struct EmpTextModel: EmpComponentModel {
    let dataID: AnyHashable
    let viewModel: EmpText.ViewModel

    var reuseIdentifier: String { "EmpText" }
    func makeView() -> UIView { EmpText() }
    func configure(view: UIView) {
        (view as! EmpText).configure(with: viewModel)
    }
    func isContentEqual(to other: EmpComponentModel) -> Bool {
        guard let other = other as? EmpTextModel else { return false }
        return viewModel == other.viewModel
    }
}

// Вложенные структуры — враппер-модели
struct EmpHStackModel: EmpComponentModel {
    let dataID: AnyHashable
    let spacing: CGFloat
    let children: [EmpComponentModel]

    var reuseIdentifier: String {
        "HStack[\(children.map(\.reuseIdentifier).joined(separator: ","))]"
    }

    func makeView() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = spacing
        for child in children {
            stack.addArrangedSubview(child.makeView())
        }
        return stack
    }

    func configure(view: UIView) {
        let stack = view as! UIStackView
        stack.spacing = spacing
        for (model, view) in zip(children, stack.arrangedSubviews) {
            model.configure(view: view)
        }
    }
}
```

| Плюсы | Минусы |
|---|---|
| Расширяемость — новый компонент = новая struct | Type erasure — force-cast в configure(view:) |
| reuseIdentifier строится рекурсивно | Нет compile-time проверки view↔model |
| Каждый компонент инкапсулирует свою логику | isContentEqual — ручной boilerplate |

---

### Подход 3: Node Tree без reuse (по мотивам Texture)

Отказ от cell reuse. Каждый элемент — свой node. UIView создаётся лениво.

```swift
class EmpNode {
    var viewModel: any EmpViewModel
    var children: [EmpNode]

    // UIView создаётся лениво, только когда node виден
    private(set) lazy var view: UIView = makeView()
    private var isViewLoaded = false

    func makeView() -> UIView { ... }

    func apply() {
        guard isViewLoaded else { return }
        // обновить view из viewModel
    }
}

class EmpListNode {
    var itemNodes: [EmpNode] = []

    func setItems(_ descriptors: [ComponentDescriptor]) {
        // Диффинг по dataID
        // Новые — создать node
        // Удалённые — удалить node
        // Существующие — обновить viewModel, вызвать apply()
        // Видимые — загрузить view
        // Невидимые — view не создан или выгружен
    }
}
```

| Плюсы | Минусы |
|---|---|
| Нет проблемы reuse — 1 элемент = 1 node | Нужен свой "UICollectionView" |
| Layout на фоновом потоке | Потребление памяти — node для каждого элемента |
| Простая ментальная модель | Огромный объём работы |
| Нет force-cast'ов | Overengineering для 99% задач |

---

## Итоговое сравнение подходов

| | Descriptor Tree (enum) | Protocol Models | Node Tree (без reuse) |
|---|---|---|---|
| **Описание ячейки** | `ComponentDescriptor` enum | `EmpComponentModel` protocol | `EmpNode` class |
| **reuseID** | `fingerprint` из структуры | `reuseIdentifier` строка | не нужен |
| **Compile-time safety** | Полная (enum exhaustive) | Частичная (force-cast) | Полная |
| **Добавить компонент** | + case в enum + build/reconfigure | + новая struct | + новый node class |
| **Equatable** | Бесплатно (struct enum) | Ручной boilerplate | Бесплатно |
| **Closures** | Проблема (решается через actionID) | Та же проблема | Та же проблема |
| **Сложность реализации** | Средняя | Средняя | Высокая |
| **Близость к текущему коду** | Высокая | Средняя | Низкая |

---

## Рекомендация

**Подход 1 (Descriptor Tree)** — лучше всего ложится на проект:

1. Паттерн уже существует в `EmpButton.Content.Element` (`.text(EmpText.ViewModel)`, `.icon(EmpImage.ViewModel)`)
2. ViewModel'ы уже Equatable — fingerprint и диффинг бесплатно
3. Enum конечен — для дизайн-системы это преимущество: компилятор показывает все места при добавлении нового case
4. Fingerprint как reuseIdentifier решает задачу UICollectionView reuse точно

Проблему с closures можно решить через `actionID`:

```swift
case tap(actionID: String, child: ComponentDescriptor)
// actionID → lookup в словаре обработчиков
// не участвует в Equatable-сравнении данных
```
