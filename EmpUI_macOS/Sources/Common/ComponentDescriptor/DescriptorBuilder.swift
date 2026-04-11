import AppKit

@resultBuilder
public struct DescriptorBuilder {
    public static func buildBlock(_ components: [ComponentDescriptor]...) -> [ComponentDescriptor] {
        components.flatMap { $0 }
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

// MARK: - Factories

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

    static func selection(
        _ viewModel: ESelectionContainer.ViewModel,
        content: () -> ControlParameter<ComponentDescriptor>
    ) -> ComponentDescriptor {
        .selection(viewModel, content())
    }
}
