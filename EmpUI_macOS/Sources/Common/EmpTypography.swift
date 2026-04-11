import AppKit

public enum EmpTypography: Sendable {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2

    public var fontSize: CGFloat {
        switch self {
        case .largeTitle: 34
        case .title1: 28
        case .title2: 22
        case .title3: 20
        case .headline: 17
        case .body: 17
        case .callout: 16
        case .subheadline: 15
        case .footnote: 13
        case .caption1: 12
        case .caption2: 11
        }
    }

    public var fontWeight: NSFont.Weight {
        switch self {
        case .largeTitle, .title1, .title2: .bold
        case .title3, .headline: .semibold
        case .body, .callout, .subheadline, .footnote, .caption1, .caption2: .regular
        }
    }

    public var lineHeight: CGFloat {
        switch self {
        case .largeTitle: 41
        case .title1: 34
        case .title2: 28
        case .title3: 25
        case .headline: 22
        case .body: 22
        case .callout: 21
        case .subheadline: 20
        case .footnote: 18
        case .caption1: 16
        case .caption2: 13
        }
    }

    public var font: NSFont {
        .systemFont(ofSize: fontSize, weight: fontWeight)
    }
}
