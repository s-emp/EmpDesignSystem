import Cocoa
import EmpUI_macOS

@MainActor
struct ComponentPage {
    let component: NSView
    let defaultViewModel: Any
    let configure: @MainActor (NSView, Any) -> Void
}

@MainActor
enum ComponentFactory {

    static func makePage(for itemId: String) -> ComponentPage? {
        switch itemId {
        case "etext":
            return makeEText()
        case "eicon":
            return makeEIcon()
        case "edivider":
            return makeEDivider()
        case "eprogressbar":
            return makeEProgressBar()
        case "etoggle":
            return makeEToggle()
        case "eslider":
            return makeESlider()
        case "edropdown":
            return makeEDropdown()
        case "etextfield":
            return makeETextField()
        case "eactivityindicator":
            return makeEActivityIndicator()
        default:
            return nil
        }
    }

    // MARK: - Private

    private static func makeEText() -> ComponentPage {
        let view = EText()
        let vm = EText.ViewModel(
            content: .plain(.init(
                text: "Hello, Design System!",
                font: .systemFont(ofSize: 24, weight: .bold),
                color: .Semantic.textPrimary
            ))
        )
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? EText, let m = model as? EText.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }

    private static func makeEIcon() -> ComponentPage {
        let view = EIcon()
        let vm = EIcon.ViewModel(
            source: .sfSymbol("star.fill"),
            size: 48,
            tintColor: .Semantic.actionPrimary
        )
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? EIcon, let m = model as? EIcon.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }

    private static func makeEDivider() -> ComponentPage {
        let view = EDivider()
        let vm = EDivider.ViewModel()
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? EDivider, let m = model as? EDivider.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }

    private static func makeEProgressBar() -> ComponentPage {
        let view = EProgressBar()
        let vm = EProgressBar.ViewModel(progress: 0.65)
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? EProgressBar, let m = model as? EProgressBar.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }

    private static func makeEToggle() -> ComponentPage {
        let view = EToggle()
        let vm = EToggle.ViewModel(isOn: true)
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? EToggle, let m = model as? EToggle.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }

    private static func makeESlider() -> ComponentPage {
        let view = ESlider()
        let vm = ESlider.ViewModel(value: 0.5)
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? ESlider, let m = model as? ESlider.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }

    private static func makeEDropdown() -> ComponentPage {
        let view = EDropdown()
        let vm = EDropdown.ViewModel(
            items: ["Option A", "Option B", "Option C"],
            selectedIndex: 0,
            placeholder: "Select..."
        )
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? EDropdown, let m = model as? EDropdown.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }

    private static func makeETextField() -> ComponentPage {
        let view = ETextField()
        let vm = ETextField.ViewModel(
            placeholder: "Enter text here..."
        )
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? ETextField, let m = model as? ETextField.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }

    private static func makeEActivityIndicator() -> ComponentPage {
        let view = EActivityIndicator()
        let vm = EActivityIndicator.ViewModel(
            style: .large,
            isAnimating: true
        )
        let _ = view.configure(with: vm)
        return ComponentPage(
            component: view,
            defaultViewModel: vm,
            configure: { v, model in
                guard let v = v as? EActivityIndicator,
                      let m = model as? EActivityIndicator.ViewModel else { return }
                let _ = v.configure(with: m)
            }
        )
    }
}
