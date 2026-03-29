import AppKit
import os

@MainActor
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

    public static func build(from descriptor: ComponentDescriptor) -> NSView {
        log("BUILD: \(descriptor.fingerprint)")
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
        case let .stack(vm, children):
            let stack = EStack()
            stack.configure(with: vm)
            for child in children {
                stack.addView(build(from: child), in: .center)
            }
            return stack
        case let .overlay(vm, children):
            let container = EOverlay()
            container.configure(with: vm)
            for child in children {
                let childView = build(from: child)
                container.addSubview(childView)
                childView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    childView.topAnchor.constraint(equalTo: container.topAnchor),
                    childView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    childView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    childView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                ])
            }
            return container
        case let .spacer(vm):
            let spacer = ESpacer()
            spacer.configure(with: vm)
            return spacer
        case let .scroll(vm, child):
            let scrollView = EScroll()
            scrollView.configure(with: vm)
            let childView = build(from: child)
            childView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.documentView = childView
            return scrollView
        case let .tap(vm, content):
            let tap = ETapContainer()
            tap.configure(with: vm)
            let childView = build(from: content.normal)
            tap.setContent(childView)
            tap.onStateChange = { [weak tap] state in
                guard let tap, let contentView = tap.contentView else { return }
                Self.reconfigure(view: contentView, with: content[state])
            }
            return tap
        }
    }

    @discardableResult
    public static func update(view: NSView, with new: ComponentDescriptor) -> NSView? {
        switch new {
        case let .text(newVM):
            guard let text = view as? EText else { log("REBUILD: type mismatch"); return build(from: new) }
            if text.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            text.configure(with: newVM)
        case let .image(newVM):
            guard let image = view as? EImage else { log("REBUILD: type mismatch"); return build(from: new) }
            if image.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            image.configure(with: newVM)
        case let .progressBar(newVM):
            guard let bar = view as? EProgressBar else { log("REBUILD: type mismatch"); return build(from: new) }
            if bar.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            bar.configure(with: newVM)
        case let .infoCard(newVM):
            guard let card = view as? EInfoCard else { log("REBUILD: type mismatch"); return build(from: new) }
            if card.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            card.configure(with: newVM)
        case let .segmentControl(newVM):
            guard let seg = view as? ESegmentControl else { log("REBUILD: type mismatch"); return build(from: new) }
            if seg.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            seg.configure(with: newVM)
        case let .stack(newVM, newChildren):
            guard let stack = view as? EStack else { log("REBUILD: type mismatch"); return build(from: new) }
            log("UPDATE: reconfigure")
            stack.configure(with: newVM)
            updateChildrenInStack(stack, newChildren: newChildren)
        case let .overlay(newVM, newChildren):
            guard let container = view as? EOverlay else { log("REBUILD: type mismatch"); return build(from: new) }
            log("UPDATE: reconfigure")
            container.configure(with: newVM)
            updateChildren(
                of: container,
                newChildren: newChildren,
                getChildren: { $0.subviews },
                replace: { parent, _, oldView, newView in
                    newView.translatesAutoresizingMaskIntoConstraints = false
                    parent.addSubview(newView, positioned: .above, relativeTo: oldView)
                    NSLayoutConstraint.activate([
                        newView.topAnchor.constraint(equalTo: parent.topAnchor),
                        newView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                        newView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                        newView.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
                    ])
                    oldView.removeFromSuperview()
                }
            )
        case let .spacer(newVM):
            guard let spacer = view as? ESpacer else { log("REBUILD: type mismatch"); return build(from: new) }
            if spacer.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            spacer.configure(with: newVM)
        case let .scroll(newVM, child):
            guard let scrollView = view as? EScroll else { log("REBUILD: type mismatch"); return build(from: new) }
            log("UPDATE: reconfigure")
            scrollView.configure(with: newVM)
            if let contentView = scrollView.documentView {
                if let newContentView = update(view: contentView, with: child) {
                    scrollView.documentView = newContentView
                }
            }
        case let .tap(newVM, content):
            guard let tap = view as? ETapContainer else { log("REBUILD: type mismatch"); return build(from: new) }
            log("UPDATE: reconfigure")
            tap.configure(with: newVM)
            tap.onStateChange = { [weak tap] state in
                guard let tap, let contentView = tap.contentView else { return }
                Self.reconfigure(view: contentView, with: content[state])
            }
            if let contentView = tap.contentView {
                if let newContentView = update(view: contentView, with: content[tap.currentState]) {
                    tap.setContent(newContentView)
                }
            }
        }
        return nil
    }

    private static func updateChildrenInStack(_ stack: EStack, newChildren: [ComponentDescriptor]) {
        let childViews = stack.views
        for (index, (childView, newChild)) in zip(childViews, newChildren).enumerated() {
            if let newView = update(view: childView, with: newChild) {
                stack.removeView(childView)
                stack.insertView(newView, at: index, in: .center)
            }
        }
    }

    private static func updateChildren<Parent: NSView>(
        of parent: Parent,
        newChildren: [ComponentDescriptor],
        getChildren: (Parent) -> [NSView],
        replace: (Parent, Int, NSView, NSView) -> Void
    ) {
        let childViews = getChildren(parent)
        for (index, (childView, newChild)) in zip(childViews, newChildren).enumerated() {
            if let newView = update(view: childView, with: newChild) {
                replace(parent, index, childView, newView)
            }
        }
    }

    public static func reconfigure(view: NSView, with descriptor: ComponentDescriptor) {
        switch descriptor {
        case let .text(vm):           (view as! EText).configure(with: vm)
        case let .image(vm):          (view as! EImage).configure(with: vm)
        case let .progressBar(vm):    (view as! EProgressBar).configure(with: vm)
        case let .infoCard(vm):       (view as! EInfoCard).configure(with: vm)
        case let .segmentControl(vm): (view as! ESegmentControl).configure(with: vm)
        case let .stack(vm, children):
            let stack = view as! EStack
            stack.configure(with: vm)
            for (childView, childDescriptor) in zip(stack.views, children) {
                reconfigure(view: childView, with: childDescriptor)
            }
        case let .overlay(vm, children):
            let container = view as! EOverlay
            container.configure(with: vm)
            for (childView, childDescriptor) in zip(container.subviews, children) {
                reconfigure(view: childView, with: childDescriptor)
            }
        case let .spacer(vm):
            (view as! ESpacer).configure(with: vm)
        case let .scroll(vm, child):
            let scrollView = view as! EScroll
            scrollView.configure(with: vm)
            if let contentView = scrollView.documentView {
                reconfigure(view: contentView, with: child)
            }
        case let .tap(vm, content):
            let tap = view as! ETapContainer
            tap.configure(with: vm)
            tap.onStateChange = { [weak tap] state in
                guard let tap, let contentView = tap.contentView else { return }
                Self.reconfigure(view: contentView, with: content[state])
            }
            if let contentView = tap.contentView {
                reconfigure(view: contentView, with: content[tap.currentState])
            }
        }
    }
}
