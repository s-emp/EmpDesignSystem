import UIKit

public enum ComponentDescriptor: Equatable {
    // Листовые компоненты
    case text(EText.ViewModel)
    case image(EImage.ViewModel)
    case progressBar(EProgressBar.ViewModel)

    // Интерактивные компоненты
    case slider(ESlider.ViewModel)

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
