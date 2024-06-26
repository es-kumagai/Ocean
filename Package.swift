// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ocean",
    platforms: [
        .macOS(.v13),
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Ocean",
            targets: ["Ocean"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/es-kumagai/Swim", "0.2.0" ..< "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Ocean",
            dependencies: ["Swim"],
            swiftSettings: [
            ]
        ),
        .testTarget(
            name: "OceanTests",
            dependencies: ["Ocean", "Swim"]),
    ],
    swiftLanguageVersions: [.v5]
)
