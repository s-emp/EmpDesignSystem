import Foundation

public protocol ComponentViewModel: Equatable {
    var common: CommonViewModel { get }
}
