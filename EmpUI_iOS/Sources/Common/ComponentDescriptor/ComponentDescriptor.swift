import UIKit

public enum ComponentDescriptor: Equatable {
    // Листовые компоненты
    case text(EText.ViewModel)
    case richLabel(ERichLabel.ViewModel)
    case image(EImage.ViewModel)
    case icon(EIcon.ViewModel)
    case progressBar(EProgressBar.ViewModel)
    case activityIndicator(EActivityIndicator.ViewModel)
    case divider(EDivider.ViewModel)
    case animationView(EAnimationView.ViewModel)
    case textField(ETextField.ViewModel)
    case textView(ETextView.ViewModel)
    case toggle(EToggle.ViewModel)

    // Составные компоненты
    case infoCard(EInfoCard.ViewModel)
    case segmentControl(ESegmentControl.ViewModel)

    // Контейнеры
    indirect case stack(EStack.ViewModel, [ComponentDescriptor])
    indirect case overlay(EOverlay.ViewModel, [ComponentDescriptor])
    case spacer(ESpacer.ViewModel)
    indirect case scroll(EScroll.ViewModel, ComponentDescriptor)
    indirect case tap(ETapContainer.ViewModel, ControlParameter<ComponentDescriptor>)
    indirect case selection(ESelectionContainer.ViewModel, ControlParameter<ComponentDescriptor>)
    indirect case animation(EAnimationContainer.ViewModel, ComponentDescriptor)
    indirect case list(EListContainer.ViewModel, [ComponentDescriptor])
    case native(ENativeContainer.ViewModel)
}
