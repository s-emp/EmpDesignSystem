import AppKit

public enum ComponentDescriptor: Equatable {
    // Листовые компоненты
    case text(EText.ViewModel)
    case richLabel(ERichLabel.ViewModel)
    case image(EImage.ViewModel)
    case icon(EIcon.ViewModel)
    case progressBar(EProgressBar.ViewModel)
    case activityIndicator(EActivityIndicator.ViewModel)

    // Составные компоненты
    case infoCard(EInfoCard.ViewModel)
    case segmentControl(ESegmentControl.ViewModel)

    // Контейнеры
    indirect case stack(EStack.ViewModel, [ComponentDescriptor])
    indirect case overlay(EOverlay.ViewModel, [ComponentDescriptor])
    case spacer(ESpacer.ViewModel)
    indirect case scroll(EScroll.ViewModel, ComponentDescriptor)
    indirect case tap(ETapContainer.ViewModel, ControlParameter<ComponentDescriptor>)
}
