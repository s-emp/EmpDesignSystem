# EmpSpacing — Spacing-система на 4pt-сетке

## Цель

Стандартные spacing-токены для единообразных отступов во всей дизайн-системе. Базовая единица — 4pt.

## Шкала

| Токен | Значение |
|-------|----------|
| `xxs` | 4pt |
| `xs` | 8pt |
| `s` | 12pt |
| `m` | 16pt |
| `l` | 20pt |
| `xl` | 24pt |
| `xxl` | 32pt |
| `xxxl` | 40pt |

## Реализация

### EmpSpacing enum

`enum EmpSpacing: CGFloat` — идентичный на iOS и macOS. 8 case, rawValue = значение в points.

### Convenience init для EdgeInsets

- **iOS:** `UIEdgeInsets(top: EmpSpacing, left: EmpSpacing, bottom: EmpSpacing, right: EmpSpacing)`
- **macOS:** `NSEdgeInsets(top: EmpSpacing, left: EmpSpacing, bottom: EmpSpacing, right: EmpSpacing)`

### Файлы

```
EmpUI_iOS/Sources/Common/EmpSpacing.swift
EmpUI_iOS/Sources/Common/UIEdgeInsets+EmpSpacing.swift
EmpUI_macOS/Sources/Common/EmpSpacing.swift
EmpUI_macOS/Sources/Common/NSEdgeInsets+EmpSpacing.swift
```

### Интеграция

CommonViewModel не меняется. Пользователь передаёт `UIEdgeInsets(top: .xs, left: .m, ...)` в `layoutMargins`.

```swift
// До:
CommonViewModel(layoutMargins: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))

// После:
CommonViewModel(layoutMargins: UIEdgeInsets(top: .xs, left: .m, bottom: .xs, right: .m))
```

## Тестирование

- rawValue каждого case соответствует ожидаемому значению
- Convenience init корректно передаёт значения
