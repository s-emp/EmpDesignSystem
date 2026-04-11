import AppKit

public extension ESplitView {
    struct ViewModel: ComponentViewModel {
        public let common: CommonViewModel
        public let orientation: Orientation
        public let dividerStyle: DividerStyle

        public enum Orientation: Equatable {
            case horizontal
            case vertical
        }

        public enum DividerStyle: Equatable {
            case thin
            case thick
        }

        public init(
            common: CommonViewModel = CommonViewModel(),
            orientation: Orientation = .horizontal,
            dividerStyle: DividerStyle = .thin
        ) {
            self.common = common
            self.orientation = orientation
            self.dividerStyle = dividerStyle
        }
    }
}
