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
        case let .richLabel(vm):
            let v = ERichLabel()
            v.configure(with: vm)
            return v
        case let .image(vm):
            let v = EImage()
            v.configure(with: vm)
            return v
        case let .icon(vm):
            let v = EIcon()
            v.configure(with: vm)
            return v
        case let .progressBar(vm):
            let v = EProgressBar()
            v.configure(with: vm)
            return v
        case let .activityIndicator(vm):
            let v = EActivityIndicator()
            v.configure(with: vm)
            return v
        case let .divider(vm):
            let v = EDivider()
            v.configure(with: vm)
            return v
        case let .animationView(vm):
            let v = EAnimationView()
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
            let guide = container.empLayoutMarginsGuide
            for child in children {
                let childView = build(from: child)
                container.addSubview(childView)
                childView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    childView.topAnchor.constraint(equalTo: guide.topAnchor),
                    childView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                    childView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                    childView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
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
            assert(content.isStructurallyConsistent, "tap content must have the same structure across all states")
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
        case let .richLabel(newVM):
            guard let label = view as? ERichLabel else { log("REBUILD: type mismatch"); return build(from: new) }
            if label.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            label.configure(with: newVM)
        case let .image(newVM):
            guard let image = view as? EImage else { log("REBUILD: type mismatch"); return build(from: new) }
            if image.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            image.configure(with: newVM)
        case let .icon(newVM):
            guard let icon = view as? EIcon else { log("REBUILD: type mismatch"); return build(from: new) }
            if icon.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            icon.configure(with: newVM)
        case let .progressBar(newVM):
            guard let bar = view as? EProgressBar else { log("REBUILD: type mismatch"); return build(from: new) }
            if bar.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            bar.configure(with: newVM)
        case let .activityIndicator(newVM):
            guard let indicator = view as? EActivityIndicator else { log("REBUILD: type mismatch"); return build(from: new) }
            if indicator.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            indicator.configure(with: newVM)
        case let .divider(newVM):
            guard let divider = view as? EDivider else { log("REBUILD: type mismatch"); return build(from: new) }
            if divider.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            divider.configure(with: newVM)
        case let .animationView(newVM):
            guard let anim = view as? EAnimationView else { log("REBUILD: type mismatch"); return build(from: new) }
            if anim.viewModel == newVM { log("SKIP"); return nil }
            log("UPDATE: reconfigure")
            anim.configure(with: newVM)
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
                addChild: { parent, newView in
                    newView.translatesAutoresizingMaskIntoConstraints = false
                    parent.addSubview(newView)
                    NSLayoutConstraint.activate([
                        newView.topAnchor.constraint(equalTo: parent.empLayoutMarginsGuide.topAnchor),
                        newView.leadingAnchor.constraint(equalTo: parent.empLayoutMarginsGuide.leadingAnchor),
                        newView.trailingAnchor.constraint(equalTo: parent.empLayoutMarginsGuide.trailingAnchor),
                        newView.bottomAnchor.constraint(equalTo: parent.empLayoutMarginsGuide.bottomAnchor),
                    ])
                },
                removeChild: { _, oldView in
                    oldView.removeFromSuperview()
                },
                replace: { parent, _, oldView, newView in
                    newView.translatesAutoresizingMaskIntoConstraints = false
                    parent.addSubview(newView, positioned: .above, relativeTo: oldView)
                    NSLayoutConstraint.activate([
                        newView.topAnchor.constraint(equalTo: parent.empLayoutMarginsGuide.topAnchor),
                        newView.leadingAnchor.constraint(equalTo: parent.empLayoutMarginsGuide.leadingAnchor),
                        newView.trailingAnchor.constraint(equalTo: parent.empLayoutMarginsGuide.trailingAnchor),
                        newView.bottomAnchor.constraint(equalTo: parent.empLayoutMarginsGuide.bottomAnchor),
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
        let commonCount = min(childViews.count, newChildren.count)

        for index in 0..<commonCount {
            if let newView = update(view: childViews[index], with: newChildren[index]) {
                stack.removeView(childViews[index])
                stack.insertView(newView, at: index, in: .center)
            }
        }

        if newChildren.count > childViews.count {
            for index in childViews.count..<newChildren.count {
                stack.addView(build(from: newChildren[index]), in: .center)
            }
        } else if childViews.count > newChildren.count {
            for index in stride(from: childViews.count - 1, through: newChildren.count, by: -1) {
                stack.removeView(childViews[index])
            }
        }
    }

    private static func updateChildren<Parent: NSView>(
        of parent: Parent,
        newChildren: [ComponentDescriptor],
        getChildren: (Parent) -> [NSView],
        addChild: (Parent, NSView) -> Void,
        removeChild: (Parent, NSView) -> Void,
        replace: (Parent, Int, NSView, NSView) -> Void
    ) {
        let childViews = getChildren(parent)
        let commonCount = min(childViews.count, newChildren.count)

        for index in 0..<commonCount {
            if let newView = update(view: childViews[index], with: newChildren[index]) {
                replace(parent, index, childViews[index], newView)
            }
        }

        if newChildren.count > childViews.count {
            for index in childViews.count..<newChildren.count {
                addChild(parent, build(from: newChildren[index]))
            }
        } else if childViews.count > newChildren.count {
            for index in stride(from: childViews.count - 1, through: newChildren.count, by: -1) {
                removeChild(parent, childViews[index])
            }
        }
    }

    public static func reconfigure(view: NSView, with descriptor: ComponentDescriptor) {
        switch descriptor {
        case let .text(vm):
            assert(view is EText, "reconfigure type mismatch: expected EText, got \(type(of: view))")
            (view as! EText).configure(with: vm)
        case let .richLabel(vm):
            assert(view is ERichLabel, "reconfigure type mismatch: expected ERichLabel, got \(type(of: view))")
            (view as! ERichLabel).configure(with: vm)
        case let .image(vm):
            assert(view is EImage, "reconfigure type mismatch: expected EImage, got \(type(of: view))")
            (view as! EImage).configure(with: vm)
        case let .icon(vm):
            assert(view is EIcon, "reconfigure type mismatch: expected EIcon, got \(type(of: view))")
            (view as! EIcon).configure(with: vm)
        case let .progressBar(vm):
            assert(view is EProgressBar, "reconfigure type mismatch: expected EProgressBar, got \(type(of: view))")
            (view as! EProgressBar).configure(with: vm)
        case let .activityIndicator(vm):
            assert(view is EActivityIndicator, "reconfigure type mismatch: expected EActivityIndicator, got \(type(of: view))")
            (view as! EActivityIndicator).configure(with: vm)
        case let .divider(vm):
            assert(view is EDivider, "reconfigure type mismatch: expected EDivider, got \(type(of: view))")
            (view as! EDivider).configure(with: vm)
        case let .animationView(vm):
            assert(view is EAnimationView, "reconfigure type mismatch: expected EAnimationView, got \(type(of: view))")
            (view as! EAnimationView).configure(with: vm)
        case let .infoCard(vm):
            assert(view is EInfoCard, "reconfigure type mismatch: expected EInfoCard, got \(type(of: view))")
            (view as! EInfoCard).configure(with: vm)
        case let .segmentControl(vm):
            assert(view is ESegmentControl, "reconfigure type mismatch: expected ESegmentControl, got \(type(of: view))")
            (view as! ESegmentControl).configure(with: vm)
        case let .stack(vm, children):
            assert(view is EStack, "reconfigure type mismatch: expected EStack, got \(type(of: view))")
            let stack = view as! EStack
            stack.configure(with: vm)
            for (childView, childDescriptor) in zip(stack.views, children) {
                reconfigure(view: childView, with: childDescriptor)
            }
        case let .overlay(vm, children):
            assert(view is EOverlay, "reconfigure type mismatch: expected EOverlay, got \(type(of: view))")
            let container = view as! EOverlay
            container.configure(with: vm)
            for (childView, childDescriptor) in zip(container.subviews, children) {
                reconfigure(view: childView, with: childDescriptor)
            }
        case let .spacer(vm):
            assert(view is ESpacer, "reconfigure type mismatch: expected ESpacer, got \(type(of: view))")
            (view as! ESpacer).configure(with: vm)
        case let .scroll(vm, child):
            assert(view is EScroll, "reconfigure type mismatch: expected EScroll, got \(type(of: view))")
            let scrollView = view as! EScroll
            scrollView.configure(with: vm)
            if let contentView = scrollView.documentView {
                reconfigure(view: contentView, with: child)
            }
        case let .tap(vm, content):
            assert(view is ETapContainer, "reconfigure type mismatch: expected ETapContainer, got \(type(of: view))")
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
