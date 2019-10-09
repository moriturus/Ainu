// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Ainu",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "Ainu",
            targets: ["Ainu"]),
    ],
    targets: [
        .target(
            name: "Ainu",
            dependencies: []),
        .testTarget(
            name: "AinuTests",
            dependencies: ["Ainu"]),
    ],
    swiftLanguageVersions: [ .v5 ]
)
