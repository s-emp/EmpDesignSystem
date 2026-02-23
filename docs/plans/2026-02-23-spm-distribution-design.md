# SPM Distribution Design

## Goal

Make EmpDesignSystem available as a dependency for other projects via GitHub URL.

## Approach

Add a root-level `Package.swift` with two library products:

- `EmpUI_iOS` — iOS framework (UIKit)
- `EmpUI_macOS` — macOS framework (AppKit)

## Package.swift

```swift
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
            exclude: ["Preview"]
        ),
        .target(
            name: "EmpUI_macOS",
            path: "EmpUI_macOS/Sources",
            exclude: ["Preview"]
        ),
    ]
)
```

## Key Decisions

- **Preview files excluded** — only for development, not needed by consumers
- **Two separate products** — consumer picks the right one for their platform
- **No source code changes** — existing code stays as-is
- **No conflict with Tuist** — `Tuist/Package.swift` is for this project's deps, root `Package.swift` is for consumers

## Versioning

Git tags in semver format: `1.0.0`, `1.1.0`, etc.

## Consumer Usage

### SPM / Xcode

```swift
.package(url: "https://github.com/s-emp/EmpDesignSystem.git", from: "1.0.0")
// dependency: .product(name: "EmpUI_iOS", package: "EmpDesignSystem")
```

### Tuist

```swift
// Tuist/Package.swift
.package(url: "https://github.com/s-emp/EmpDesignSystem.git", from: "1.0.0")
// Project.swift dependency: .external(name: "EmpUI_macOS")
```
