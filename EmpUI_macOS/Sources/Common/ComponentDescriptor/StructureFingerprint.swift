import Foundation

public enum StructureFingerprint: Hashable {
    case leaf(String)
    indirect case container(String, [StructureFingerprint])
}

extension ComponentDescriptor {
    public var fingerprint: StructureFingerprint {
        switch self {
        case .text:           return .leaf("text")
        case .image:          return .leaf("image")
        case .progressBar:    return .leaf("progressBar")
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
        case let .list(_, children):
            return .container("list", children.map(\.fingerprint))
        }
    }
}
