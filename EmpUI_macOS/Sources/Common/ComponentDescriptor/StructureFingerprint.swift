import Foundation

public enum StructureFingerprint: Hashable {
    case leaf(String)
    indirect case container(String, [StructureFingerprint])
}

extension ComponentDescriptor {
    public var fingerprint: StructureFingerprint {
        switch self {
        case .text:           return .leaf("text")
        case .richLabel:      return .leaf("richLabel")
        case .image:          return .leaf("image")
        case .icon:              return .leaf("icon")
        case .progressBar:       return .leaf("progressBar")
        case .activityIndicator: return .leaf("activityIndicator")
        case .divider:           return .leaf("divider")
        case .animationView:     return .leaf("animationView")
        case .textField:         return .leaf("textField")
        case .textView:          return .leaf("textView")
        case .toggle:            return .leaf("toggle")
        case .infoCard:       return .leaf("infoCard")
        case .segmentControl: return .leaf("segmentControl")
        case let .stack(_, children):
            return .container("stack", children.map(\.fingerprint))
        case let .overlay(_, children):
            return .container("overlay", children.map(\.fingerprint))
        case .spacer:
            return .leaf("spacer")
        case let .scroll(_, child):
            return .container("scroll", [child.fingerprint])
        case let .tap(_, content):
            return .container("tap", [content.normal.fingerprint])
        case let .selection(_, content):
            return .container("selection", [content.normal.fingerprint])
        case let .animation(_, child):
            return .container("animation", [child.fingerprint])
        case let .list(_, children):
            return .container("list", children.map(\.fingerprint))
        case .native:
            return .leaf("native")
        case let .splitView(_, children):
            return .container("splitView", children.map(\.fingerprint))
        }
    }
}
