# EmpUI Design System Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Set up Tuist project with two independent UI frameworks (EmpUI_iOS, EmpUI_macOS) containing EmpButton and EmpLabel components with ViewModel+configure pattern and Previews.

**Architecture:** Two independent frameworks — `EmpUI_iOS` (UIKit) and `EmpUI_macOS` (AppKit). Each component is a view subclass with a nested `ViewModel` struct and `configure(with:)` method. Sandbox macOS app for Preview. No shared code between platforms.

**Tech Stack:** Swift, Tuist 4.131.1, UIKit, AppKit, #Preview macro

**Design doc:** `docs/plans/2026-02-22-design-system-design.md`

---

### Task 1: Update Project.swift — add framework targets

**Files:**
- Modify: `Project.swift`

**Step 1: Update Project.swift with all 4 targets**

Replace entire contents of `Project.swift`:

```swift
import ProjectDescription

let project = Project(
    name: "EmpDesignSystem",
    targets: [
        // MARK: - Frameworks

        .target(
            name: "EmpUI_iOS",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.emp.EmpUI-iOS",
            sources: ["EmpUI_iOS/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "EmpUI_macOS",
            destinations: .macOS,
            product: .framework,
            bundleId: "dev.emp.EmpUI-macOS",
            sources: ["EmpUI_macOS/Sources/**"],
            dependencies: []
        ),

        // MARK: - Sandbox App

        .target(
            name: "EmpDesignSystem",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.emp.EmpDesignSystem",
            infoPlist: .default,
            sources: ["EmpDesignSystem/Sources/**"],
            resources: ["EmpDesignSystem/Resources/**"],
            dependencies: [
                .target(name: "EmpUI_macOS"),
            ]
        ),

        // MARK: - Tests

        .target(
            name: "EmpDesignSystemTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.emp.EmpDesignSystemTests",
            sources: ["EmpDesignSystem/Tests/**"],
            dependencies: [
                .target(name: "EmpDesignSystem"),
            ]
        ),
    ]
)
```

**Step 2: Create directory structure**

Run:
```bash
mkdir -p EmpUI_iOS/Sources/Components
mkdir -p EmpUI_iOS/Sources/Preview
mkdir -p EmpUI_macOS/Sources/Components
mkdir -p EmpUI_macOS/Sources/Preview
```

**Step 3: Commit**

```bash
git add Project.swift
git commit -m "feat: add EmpUI_iOS and EmpUI_macOS framework targets"
```

---

### Task 2: Create EmpButton for macOS (AppKit)

**Files:**
- Create: `EmpUI_macOS/Sources/Components/EmpButton.swift`

**Step 1: Write EmpButton component**

```swift
import AppKit

public final class EmpButton: NSView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let title: String
        public let style: Style

        public enum Style {
            case primary
            case secondary
        }

        public init(title: String, style: Style) {
            self.title = title
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let button = NSButton()

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        button.bezelStyle = .rounded
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        button.title = viewModel.title

        switch viewModel.style {
        case .primary:
            button.bezelColor = .controlAccentColor
            button.contentTintColor = .white
        case .secondary:
            button.bezelColor = nil
            button.contentTintColor = .controlAccentColor
        }
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_macOS/Sources/Components/EmpButton.swift
git commit -m "feat: add EmpButton macOS component"
```

---

### Task 3: Create EmpButton Preview for macOS

**Files:**
- Create: `EmpUI_macOS/Sources/Preview/EmpButton+Preview.swift`

**Step 1: Write Preview with test data**

```swift
import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpButton — Primary") {
    let button = EmpButton()
    button.configure(with: .init(title: "Primary Action", style: .primary))
    return button
}

@available(macOS 14.0, *)
#Preview("EmpButton — Secondary") {
    let button = EmpButton()
    button.configure(with: .init(title: "Secondary Action", style: .secondary))
    return button
}
```

**Step 2: Commit**

```bash
git add EmpUI_macOS/Sources/Preview/EmpButton+Preview.swift
git commit -m "feat: add EmpButton macOS preview"
```

---

### Task 4: Create EmpLabel for macOS (AppKit)

**Files:**
- Create: `EmpUI_macOS/Sources/Components/EmpLabel.swift`

**Step 1: Write EmpLabel component**

```swift
import AppKit

public final class EmpLabel: NSView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let text: String
        public let style: Style

        public enum Style {
            case title
            case body
            case caption
        }

        public init(text: String, style: Style) {
            self.text = text
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let textField = NSTextField(labelWithString: "")

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        textField.isEditable = false
        textField.isBordered = false
        textField.drawsBackground = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        textField.stringValue = viewModel.text

        switch viewModel.style {
        case .title:
            textField.font = .systemFont(ofSize: 24, weight: .bold)
            textField.textColor = .labelColor
        case .body:
            textField.font = .systemFont(ofSize: 16, weight: .regular)
            textField.textColor = .labelColor
        case .caption:
            textField.font = .systemFont(ofSize: 12, weight: .regular)
            textField.textColor = .secondaryLabelColor
        }
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_macOS/Sources/Components/EmpLabel.swift
git commit -m "feat: add EmpLabel macOS component"
```

---

### Task 5: Create EmpLabel Preview for macOS

**Files:**
- Create: `EmpUI_macOS/Sources/Preview/EmpLabel+Preview.swift`

**Step 1: Write Preview with test data**

```swift
import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpLabel — Title") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Title Text", style: .title))
    return label
}

@available(macOS 14.0, *)
#Preview("EmpLabel — Body") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Body text goes here. This is a longer piece of text.", style: .body))
    return label
}

@available(macOS 14.0, *)
#Preview("EmpLabel — Caption") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Caption text", style: .caption))
    return label
}
```

**Step 2: Commit**

```bash
git add EmpUI_macOS/Sources/Preview/EmpLabel+Preview.swift
git commit -m "feat: add EmpLabel macOS preview"
```

---

### Task 6: Create EmpButton for iOS (UIKit)

**Files:**
- Create: `EmpUI_iOS/Sources/Components/EmpButton.swift`

**Step 1: Write EmpButton component**

```swift
import UIKit

public final class EmpButton: UIView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let title: String
        public let style: Style

        public enum Style {
            case primary
            case secondary
        }

        public init(title: String, style: Style) {
            self.title = title
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let button = UIButton(type: .system)

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        button.setTitle(viewModel.title, for: .normal)

        switch viewModel.style {
        case .primary:
            button.configuration = {
                var config = UIButton.Configuration.filled()
                config.title = viewModel.title
                config.baseBackgroundColor = .systemBlue
                config.baseForegroundColor = .white
                config.cornerStyle = .medium
                return config
            }()
        case .secondary:
            button.configuration = {
                var config = UIButton.Configuration.bordered()
                config.title = viewModel.title
                config.baseBackgroundColor = .clear
                config.baseForegroundColor = .systemBlue
                config.cornerStyle = .medium
                return config
            }()
        }
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_iOS/Sources/Components/EmpButton.swift
git commit -m "feat: add EmpButton iOS component"
```

---

### Task 7: Create EmpButton Preview for iOS

**Files:**
- Create: `EmpUI_iOS/Sources/Preview/EmpButton+Preview.swift`

**Step 1: Write Preview with test data**

```swift
import UIKit
import SwiftUI

@available(iOS 17.0, *)
#Preview("EmpButton — Primary") {
    let button = EmpButton()
    button.configure(with: .init(title: "Primary Action", style: .primary))
    return button
}

@available(iOS 17.0, *)
#Preview("EmpButton — Secondary") {
    let button = EmpButton()
    button.configure(with: .init(title: "Secondary Action", style: .secondary))
    return button
}
```

**Step 2: Commit**

```bash
git add EmpUI_iOS/Sources/Preview/EmpButton+Preview.swift
git commit -m "feat: add EmpButton iOS preview"
```

---

### Task 8: Create EmpLabel for iOS (UIKit)

**Files:**
- Create: `EmpUI_iOS/Sources/Components/EmpLabel.swift`

**Step 1: Write EmpLabel component**

```swift
import UIKit

public final class EmpLabel: UIView {

    // MARK: - ViewModel

    public struct ViewModel {
        public let text: String
        public let style: Style

        public enum Style {
            case title
            case body
            case caption
        }

        public init(text: String, style: Style) {
            self.text = text
            self.style = style
        }
    }

    // MARK: - UI Elements

    private let label = UILabel()

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.text

        switch viewModel.style {
        case .title:
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textColor = .label
        case .body:
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .label
        case .caption:
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textColor = .secondaryLabel
        }
    }
}
```

**Step 2: Commit**

```bash
git add EmpUI_iOS/Sources/Components/EmpLabel.swift
git commit -m "feat: add EmpLabel iOS component"
```

---

### Task 9: Create EmpLabel Preview for iOS

**Files:**
- Create: `EmpUI_iOS/Sources/Preview/EmpLabel+Preview.swift`

**Step 1: Write Preview with test data**

```swift
import UIKit
import SwiftUI

@available(iOS 17.0, *)
#Preview("EmpLabel — Title") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Title Text", style: .title))
    return label
}

@available(iOS 17.0, *)
#Preview("EmpLabel — Body") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Body text goes here. This is a longer piece of text.", style: .body))
    return label
}

@available(iOS 17.0, *)
#Preview("EmpLabel — Caption") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Caption text", style: .caption))
    return label
}
```

**Step 2: Commit**

```bash
git add EmpUI_iOS/Sources/Preview/EmpLabel+Preview.swift
git commit -m "feat: add EmpLabel iOS preview"
```

---

### Task 10: Verify — tuist generate and build

**Step 1: Run tuist generate**

Run: `tuist generate`
Expected: Xcode project generated successfully with all 4 targets visible.

**Step 2: Build macOS sandbox**

Run: `tuist build --scheme EmpDesignSystem`
Expected: Build succeeds.

**Step 3: Build iOS framework**

Run: `tuist build --scheme EmpUI_iOS`
Expected: Build succeeds.

**Step 4: Final commit if any fixes needed**

```bash
git add -A
git commit -m "fix: resolve build issues from verification"
```
