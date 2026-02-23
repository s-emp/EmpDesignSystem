// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "EmpDesignSystem",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        .library(name: "EmpUI_iOS", targets: ["EmpUI_iOS"]),
        .library(name: "EmpUI_macOS", targets: ["EmpUI_macOS"]),
    ],
    targets: [
        .target(
            name: "EmpUI_iOS",
            path: "EmpUI_iOS/Sources",
            exclude: ["Preview"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "EmpUI_macOS",
            path: "EmpUI_macOS/Sources",
            exclude: ["Preview"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
