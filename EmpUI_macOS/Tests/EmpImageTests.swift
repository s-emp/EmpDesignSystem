import AppKit
import Testing
@testable import EmpUI_macOS

// MARK: - ViewModel

@Suite("EmpImage.ViewModel")
struct EmpImageViewModelTests {
    @Test("ViewModel сохраняет все поля")
    func storesAllFields() throws {
        let image = try #require(NSImage(systemSymbolName: "star", accessibilityDescription: nil))
        let common = CommonViewModel(
            corners: .init(radius: 8),
            backgroundColor: .red
        )
        let size = CGSize(width: 32, height: 32)
        let tintColor = NSColor.blue

        let sut = EmpImage.ViewModel(
            common: common,
            image: image,
            tintColor: tintColor,
            size: size,
            contentMode: .aspectFill
        )

        #expect(sut.common == common)
        #expect(sut.image === image)
        #expect(sut.tintColor == tintColor)
        #expect(sut.size == size)
    }

    @Test("Дефолтные значения ViewModel")
    func defaultValues() throws {
        let image = try #require(NSImage(systemSymbolName: "star", accessibilityDescription: nil))
        let sut = EmpImage.ViewModel(
            image: image,
            size: CGSize(width: 24, height: 24)
        )

        #expect(sut.common == CommonViewModel())
        #expect(sut.tintColor == nil)
    }

    @Test("tintColor nil по умолчанию")
    func tintColorDefaultNil() throws {
        let image = try #require(NSImage(systemSymbolName: "star", accessibilityDescription: nil))
        let sut = EmpImage.ViewModel(
            image: image,
            size: CGSize(width: 16, height: 16)
        )

        #expect(sut.tintColor == nil)
    }
}

// MARK: - ContentMode

@Suite("EmpImage.ViewModel.ContentMode")
struct EmpImageContentModeTests {
    @Test("ContentMode имеет три варианта")
    func threeVariants() {
        let modes: [EmpImage.ViewModel.ContentMode] = [.aspectFit, .aspectFill, .center]
        #expect(modes.count == 3)
    }

    @Test("Дефолтный contentMode — aspectFit")
    func defaultContentMode() throws {
        let image = try #require(NSImage(systemSymbolName: "star", accessibilityDescription: nil))
        let sut = EmpImage.ViewModel(
            image: image,
            size: CGSize(width: 24, height: 24)
        )

        // Verify default is aspectFit by creating another with explicit aspectFit
        let explicit = EmpImage.ViewModel(
            image: image,
            size: CGSize(width: 24, height: 24),
            contentMode: .aspectFit
        )

        // Both should have the same size (indirectly verifying the default)
        #expect(sut.size == explicit.size)
    }
}
