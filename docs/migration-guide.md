# Гайд по миграции на Descriptor Tree архитектуру

## Что изменилось

### Переименование: Emp → E

| Было | Стало |
|------|-------|
| `EmpText` | `EText` |
| `EmpImage` | `EImage` |
| `EmpProgressBar` | `EProgressBar` |
| `EmpInfoCard` | `EInfoCard` |
| `EmpSegmentControl` | `ESegmentControl` |
| `EmpButton` | **Удалён** (замена: `ButtonPreset` + `ETapContainer`) |

Модули (`EmpUI_iOS`, `EmpUI_macOS`), `EmpSpacing`, `EmpGradient` — без изменений.

### Новые компоненты

| Компонент | Описание |
|-----------|----------|
| `EStack` | Стек (горизонтальный/вертикальный), `axis` параметром |
| `EOverlay` | Наложение (дети друг на друге) |
| `ESpacer` | Гибкий или фиксированный отступ |
| `EScroll` | Скроллируемый контейнер |
| `ETapContainer` | Обёртка для нажатия с визуальными состояниями |

### Новые протоколы

Все компоненты теперь реализуют `EComponent`:

```swift
protocol EComponent: UIView {
    associatedtype ViewModel: ComponentViewModel
    var viewModel: ViewModel { get }

    @discardableResult
    func configure(with viewModel: ViewModel) -> Self
}

protocol ComponentViewModel: Equatable {
    var common: CommonViewModel { get }
}
```

### Size system

В `CommonViewModel` добавлено поле `size: SizeViewModel`:

```swift
enum SizeDimension {
    case hug            // intrinsicContentSize (по умолчанию)
    case fill           // растянуться на доступное пространство
    case fixed(CGFloat) // жёсткий размер
}

struct SizeViewModel {
    let width: SizeDimension   // default: .hug
    let height: SizeDimension  // default: .hug
}
```

---

## Миграция шаг за шагом

### 1. Переименование (поиск и замена)

Простая замена по всему проекту:

```
EmpText     → EText
EmpImage    → EImage
EmpProgressBar    → EProgressBar
EmpInfoCard       → EInfoCard
EmpSegmentControl → ESegmentControl
```

Компоненты API-совместимы — только имя изменилось.

### 2. configure(with:) теперь возвращает Self

Раньше:
```swift
let text = EmpText()
text.configure(with: viewModel)
```

Теперь оба варианта работают:
```swift
// Вариант 1 — как раньше (return value игнорируется)
let text = EText()
text.configure(with: viewModel)

// Вариант 2 — chaining
let text = EText().configure(with: viewModel)
```

В `#Preview`:
```swift
// Раньше — нужен был let _
let button = EmpButton()
let _ = button.configure(with: viewModel)
button

// Теперь
let text = EText()
text.configure(with: viewModel)
text
```

### 3. Миграция EmpButton → ButtonPreset

**Было:**
```swift
let button = EmpButton()
button.configure(with: .Preset.filled(.primary, content: .init(
    center: .text(.init(content: .plain(.init(text: "Оплатить"))))
), size: .medium))
button.action = { [weak self] in
    self?.pay()
}
```

**Стало (прямое создание):**
```swift
let descriptor = ComponentDescriptor.ButtonPreset.filled(
    .primary,
    title: "Оплатить",
    action: .init(id: "pay") { [weak self] _ in
        self?.pay()
    }
)
let button = ComponentBuilder.build(from: descriptor)
```

**Стало (через descriptor tree):**
```swift
let screen: ComponentDescriptor = .stack(.init(axis: .vertical, spacing: 16)) {
    .text(.init(content: .plain(.init(text: "Итого: 1500 ₽"))))

    ComponentDescriptor.ButtonPreset.filled(
        .primary,
        title: "Оплатить",
        action: .init(id: "pay") { [weak self] _ in
            self?.pay()
        }
    )
}
```

### 4. viewModel доступен для чтения

Все компоненты теперь хранят последний сконфигурированный `viewModel`:

```swift
let text = EText()
text.configure(with: .init(content: .plain(.init(text: "Hello"))))

// Можно прочитать текущее состояние
print(text.viewModel.content) // .plain(...)
```

---

## Два способа описывать UI

### Способ 1: Прямой (как раньше)

Создаёте компоненты вручную, добавляете в иерархию, конфигурируете. Ничего не изменилось, только имена:

```swift
class ProfileView: UIView {
    private let nameLabel = EText()
    private let avatar = EImage()
    private let stack = UIStackView()

    func setup() {
        stack.axis = .horizontal
        stack.spacing = 12
        stack.addArrangedSubview(avatar)
        stack.addArrangedSubview(nameLabel)
        addSubview(stack)
        // constraints...
    }

    func configure(name: String, image: UIImage) {
        nameLabel.configure(with: .init(
            content: .plain(.init(text: name, font: .systemFont(ofSize: 17, weight: .semibold)))
        ))
        avatar.configure(with: .init(
            common: .init(corners: .init(radius: 20)),
            image: image,
            size: CGSize(width: 40, height: 40)
        ))
    }
}
```

**Когда использовать:** статичные экраны, фиксированная структура, полный контроль над layout.

### Способ 2: Descriptor Tree

UI описывается как данные. `ComponentBuilder` создаёт view-иерархию:

```swift
class ProfileView: UIView {
    private var rootView: UIView?

    func configure(name: String, image: UIImage) {
        let descriptor: ComponentDescriptor = .stack(
            .init(axis: .horizontal, spacing: 12)
        ) {
            .image(.init(
                common: .init(corners: .init(radius: 20)),
                image: image,
                size: CGSize(width: 40, height: 40)
            ))
            .text(.init(
                content: .plain(.init(text: name, font: .systemFont(ofSize: 17, weight: .semibold)))
            ))
        }

        if let existing = rootView {
            // Diff-based update: обновит только изменившиеся узлы
            ComponentBuilder.update(view: existing, with: descriptor)
        } else {
            let view = ComponentBuilder.build(from: descriptor)
            addSubview(view)
            // constraints...
            rootView = view
        }
    }
}
```

**Когда использовать:**
- Динамические списки (коллекции)
- SDUI (сервер описывает UI)
- Экраны, где структура меняется в зависимости от данных
- Интерактивные элементы с визуальными состояниями (кнопки, карточки)

---

## Descriptor Tree — подробный гайд

### Создание дескриптора

Дескриптор — иммутабельные данные, описывающие UI:

```swift
// Листовые компоненты
let text: ComponentDescriptor = .text(.init(content: .plain(.init(text: "Hello"))))
let image: ComponentDescriptor = .image(.init(image: myImage, size: CGSize(width: 24, height: 24)))

// Контейнеры
let card: ComponentDescriptor = .stack(.init(axis: .vertical, spacing: 8)) {
    .text(.init(content: .plain(.init(text: "Заголовок", font: .boldSystemFont(ofSize: 17)))))
    .text(.init(content: .plain(.init(text: "Подзаголовок", color: .Semantic.textSecondary))))
}
```

### Result Builder DSL

Контейнеры поддерживают trailing closure с условиями и циклами:

```swift
.stack(.init(axis: .vertical, spacing: 8)) {
    .text(.init(content: .plain(.init(text: user.name))))

    // Условия
    if user.isPremium {
        .image(.init(image: premiumBadge, size: CGSize(width: 16, height: 16)))
    }

    // Циклы
    for tag in user.tags {
        .text(.init(content: .plain(.init(text: tag, font: .systemFont(ofSize: 12)))))
    }
}
```

### ComponentBuilder — три операции

| Метод | Когда | Что делает |
|-------|-------|-----------|
| `build(from:)` | Первое создание | Строит view-иерархию с нуля |
| `update(view:with:)` | Данные изменились | Diff: skip неизменённые, reconfigure изменённые, rebuild при смене типа |
| `reconfigure(view:with:)` | Fingerprint гарантирован | Безусловная реконфигурация (для смены state в ETapContainer) |

```swift
// Первое создание
let view = ComponentBuilder.build(from: descriptor)

// Обновление (diff-based)
// Возвращает nil если обновлено на месте, новый view если нужна замена
let newView = ComponentBuilder.update(view: existingView, with: newDescriptor)
if let newView {
    // тип изменился — заменить view
}
```

### Интерактивные элементы — ETapContainer

`ETapContainer` оборачивает контент и управляет визуальными состояниями:

```swift
let card: ComponentDescriptor = .tap(.init(
    action: .init(id: "open-detail") { [weak self] viewModel in
        self?.openDetail()
    }
)) {
    ControlParameter(
        normal: .stack(.init(
            common: .init(
                corners: .init(radius: 12),
                backgroundColor: .Semantic.backgroundSecondary,
                layoutMargins: UIEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
            ),
            axis: .vertical,
            spacing: 4
        )) {
            .text(.init(content: .plain(.init(text: "Карточка"))))
            .text(.init(content: .plain(.init(text: "Нажми меня", color: .Semantic.textSecondary))))
        },
        highlighted: .stack(.init(
            common: .init(
                corners: .init(radius: 12),
                backgroundColor: .Semantic.backgroundTertiary, // ← меняется при нажатии
                layoutMargins: UIEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
            ),
            axis: .vertical,
            spacing: 4
        )) {
            .text(.init(content: .plain(.init(text: "Карточка"))))
            .text(.init(content: .plain(.init(text: "Нажми меня", color: .Semantic.textSecondary))))
        }
    )
}
```

**Важно:** все состояния в `ControlParameter` должны иметь одинаковую структуру (те же типы компонентов, то же количество children). Меняются только данные (цвета, шрифты).

### ButtonPreset — готовые кнопки

```swift
// Простая кнопка
ComponentDescriptor.ButtonPreset.filled(
    .primary,
    title: "Продолжить",
    action: .init(id: "continue") { [weak self] _ in
        self?.next()
    }
)

// С иконкой
ComponentDescriptor.ButtonPreset.filled(
    .danger,
    title: "Удалить",
    icon: UIImage(systemName: "trash"),
    size: .small,
    action: .init(id: "delete") { [weak self] _ in
        self?.delete()
    }
)
```

Доступные стили: `.filled` (на данный момент). `outlined`, `ghost`, `base` — будут добавлены позже.

### Action — действия живут внутри дерева

```swift
struct Action: Equatable {
    let id: String                              // для Equatable-сравнения
    var handler: (ETapContainer.ViewModel) -> Void  // closure, получает ViewModel
}
```

- `id` — строковый идентификатор. Используется для diff-сравнения (closure не Equatable).
- `handler` — вызывается при срабатывании. Получает текущую ViewModel компонента.
- `[weak self]` — обязателен если closure захватывает ViewController.

---

## Коллекции с DiffableDataSource

### EItem — элемент для snapshot

```swift
let item = EItem(
    id: transaction.id,  // уникальный id для diffing
    descriptor: .stack(.init(axis: .horizontal, spacing: 12, alignment: .center)) {
        .image(.init(image: transaction.icon, size: CGSize(width: 40, height: 40)))
        .stack(.init(axis: .vertical, spacing: 2)) {
            .text(.init(content: .plain(.init(text: transaction.title))))
            .text(.init(content: .plain(.init(
                text: transaction.subtitle,
                color: .Semantic.textSecondary
            ))))
        }
        .spacer(.init())  // flexible spacer
        .text(.init(content: .plain(.init(text: transaction.amount))))
    }
)
```

### ECollectionCell — generic ячейка

Одна регистрация на все типы ячеек. Fingerprint оптимизирует reuse:

```swift
// Setup
let registration = UICollectionView.CellRegistration<ECollectionCell, EItem> { cell, _, item in
    cell.configure(with: item.descriptor)
}

dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { cv, indexPath, item in
    cv.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
}

// Обновление данных
var snapshot = NSDiffableDataSourceSnapshot<Section, EItem>()
snapshot.appendSections([.transactions])
snapshot.appendItems(transactionItems, toSection: .transactions)
dataSource.apply(snapshot)

// Точечное обновление одного элемента
snapshot.reconfigureItems([updatedItem])
dataSource.apply(snapshot)
```

### Пагинация

DiffableDataSource работает с окном элементов:

```swift
// Загрузить следующую страницу
var snapshot = dataSource.snapshot()
snapshot.appendItems(newBatch, toSection: .transactions)
dataSource.apply(snapshot)

// Удалить старые (освободить память)
snapshot.deleteItems(oldBatch)
dataSource.apply(snapshot)
```

---

## Size system

Новое поле `size` в `CommonViewModel`:

```swift
// Фиксированная ширина, высота по контенту
.text(.init(
    common: .init(size: .init(width: .fixed(200), height: .hug)),
    content: .plain(.init(text: "Фиксированная ширина"))
))

// Растянуть на всё доступное пространство
.text(.init(
    common: .init(size: .init(width: .fill, height: .hug)),
    content: .plain(.init(text: "Растянутый"))
))

// Два элемента делят пространство поровну
.stack(.init(axis: .horizontal, spacing: 8)) {
    .text(.init(
        common: .init(size: .init(width: .fill)),
        content: .plain(.init(text: "Левая половина"))
    ))
    .text(.init(
        common: .init(size: .init(width: .fill)),
        content: .plain(.init(text: "Правая половина"))
    ))
}
```

Приоритеты: `fixed` (1000) > `hug` (751) > `fill` (1).

---

## Полный пример — экран кошелька

```swift
class WalletViewController: UIViewController {

    enum Section: Hashable { case balance, transactions }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, EItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        loadData()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(60)
            ))
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
            return section
        }
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    private func setupDataSource() {
        let reg = UICollectionView.CellRegistration<ECollectionCell, EItem> { cell, _, item in
            cell.configure(with: item.descriptor)
        }
        dataSource = .init(collectionView: collectionView) { cv, ip, item in
            cv.dequeueConfiguredReusableCell(using: reg, for: ip, item: item)
        }
    }

    private func loadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, EItem>()
        snapshot.appendSections([.balance, .transactions])

        // Карточка баланса с нажатием
        snapshot.appendItems([
            EItem(id: "balance", descriptor: makeBalanceCard(balance: 12400))
        ], toSection: .balance)

        // Список транзакций
        let items = transactions.map { tx in
            EItem(id: tx.id, descriptor: makeTransactionRow(tx))
        }
        snapshot.appendItems(items, toSection: .transactions)

        dataSource.apply(snapshot)
    }

    // ─── Построение UI из данных ───

    private func makeBalanceCard(balance: Int) -> ComponentDescriptor {
        .tap(.init(
            action: .init(id: "open-balance") { [weak self] _ in
                self?.openBalanceDetail()
            }
        )) {
            ControlParameter(
                normal: .stack(.init(
                    common: .init(
                        corners: .init(radius: 16),
                        backgroundColor: .Semantic.backgroundSecondary,
                        layoutMargins: UIEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
                    ),
                    axis: .vertical,
                    spacing: 4
                )) {
                    .text(.init(content: .plain(.init(
                        text: "Баланс",
                        font: .systemFont(ofSize: 13),
                        color: .Semantic.textSecondary
                    ))))
                    .text(.init(content: .plain(.init(
                        text: "\(balance) ₽",
                        font: .systemFont(ofSize: 24, weight: .bold)
                    ))))
                },
                highlighted: .stack(.init(
                    common: .init(
                        corners: .init(radius: 16),
                        backgroundColor: .Semantic.backgroundTertiary,
                        layoutMargins: UIEdgeInsets(top: .m, left: .m, bottom: .m, right: .m)
                    ),
                    axis: .vertical,
                    spacing: 4
                )) {
                    .text(.init(content: .plain(.init(
                        text: "Баланс",
                        font: .systemFont(ofSize: 13),
                        color: .Semantic.textSecondary
                    ))))
                    .text(.init(content: .plain(.init(
                        text: "\(balance) ₽",
                        font: .systemFont(ofSize: 24, weight: .bold)
                    ))))
                }
            )
        }
    }

    private func makeTransactionRow(_ tx: Transaction) -> ComponentDescriptor {
        .stack(.init(
            common: .init(layoutMargins: UIEdgeInsets(top: .s, left: .m, bottom: .s, right: .m)),
            axis: .horizontal,
            spacing: EmpSpacing.s.rawValue,
            alignment: .center
        )) {
            .image(.init(
                common: .init(corners: .init(radius: 20)),
                image: tx.icon,
                size: CGSize(width: 40, height: 40)
            ))
            .stack(.init(axis: .vertical, spacing: 2)) {
                .text(.init(content: .plain(.init(
                    text: tx.title,
                    font: .systemFont(ofSize: 15, weight: .medium)
                ))))
                .text(.init(content: .plain(.init(
                    text: tx.subtitle,
                    font: .systemFont(ofSize: 13),
                    color: .Semantic.textSecondary
                ))))
            }
            .spacer(.init())
            .text(.init(content: .plain(.init(
                text: tx.amount,
                font: .systemFont(ofSize: 15, weight: .semibold),
                color: tx.isIncome ? .Semantic.actionSuccess : .Semantic.textPrimary
            ))))
        }
    }

    // ─── Обновление ───

    func updateBalance(_ newBalance: Int) {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([
            EItem(id: "balance", descriptor: makeBalanceCard(balance: newBalance))
        ])
        dataSource.apply(snapshot)
    }
}
```

---

## Debug

Логирование включено автоматически в DEBUG-сборках. Смотреть в Console.app, фильтр `[EDS]`:

```
[EDS] BUILD: leaf("text")
[EDS] SKIP
[EDS] UPDATE: reconfigure
[EDS] REBUILD: type mismatch
```

Отключить:
```swift
ComponentBuilder.isLoggingEnabled = false
```

---

## Чеклист миграции

- [ ] Заменить `EmpText` → `EText`, `EmpImage` → `EImage` и т.д. по всему проекту
- [ ] Заменить `EmpButton` на `ButtonPreset.filled(...)` + `ComponentBuilder.build(...)`
- [ ] Перенести `button.action = { ... }` в `Action(id:handler:)`
- [ ] Убрать `let _ =` перед `configure(with:)` в Preview файлах (если раздражает)
- [ ] Для коллекций: перейти на `EItem` + `ECollectionCell` + `DiffableDataSource`
- [ ] Использовать `size: .init(width: .fill)` вместо ручных constraint'ов где нужно

---

## Платформенные различия (macOS)

| iOS | macOS |
|-----|-------|
| `UIView`, `UIControl` | `NSView` (ETapContainer — не NSControl) |
| `EStack` наследует `UIStackView` | `EStack` наследует `NSStackView` |
| `axis: .horizontal` | `orientation: .horizontal` |
| `UIStackView.Alignment` | `NSLayoutConstraint.Attribute` |
| `UIHoverGestureRecognizer` | `NSTrackingArea` |
| `UICollectionView` | `NSCollectionView` |
| `ECollectionCell: UICollectionViewCell` | `ECollectionCell: NSCollectionViewItem` |
| `layoutMarginsGuide` | `empLayoutMarginsGuide` |
