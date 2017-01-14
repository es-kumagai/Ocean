import PackageDescription

let package = Package(
    name: "Ocean",
    dependencies: [
        .Package(url: "https://github.com/es-kumagai/Swim", majorVersion: 0, minor: 1)
    ]
)
