// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

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
        .library(
            name: "OceanMacro",
            targets: ["OceanMacro"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/es-kumagai/Swim", "0.2.0" ..< "0.3.0"),
        .package(url: "https://github.com/es-kumagai/Earth.git", from: "0.1.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Ocean",
            dependencies: [
                "Swim",
                "OceanMacro"
            ],
            swiftSettings: [
            ]
        ),
        .testTarget(
            name: "OceanTests",
            dependencies: ["Ocean", "Swim"]),
        .macro(
            name: "OceanMacroImplements",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "Earth", package: "earth"),
                .product(name: "EarthMacroCrust", package: "earth"),
            ]
        ),
        .target(
            name: "OceanMacro",
            dependencies: [
                "OceanMacroImplements"
            ]
        ),
        .testTarget(
            name: "OceanMacroTests",
            dependencies: [
                "OceanMacroImplements",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
