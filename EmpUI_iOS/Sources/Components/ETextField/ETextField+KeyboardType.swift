import UIKit

public extension ETextField {
    enum KeyboardType: Equatable {
        case `default`
        case email
        case number
        case phone
        case url

        var uiKeyboardType: UIKeyboardType {
            switch self {
            case .default: return .default
            case .email: return .emailAddress
            case .number: return .numberPad
            case .phone: return .phonePad
            case .url: return .URL
            }
        }
    }
}
