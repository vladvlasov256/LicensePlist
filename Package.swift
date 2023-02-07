// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "LicensePlist",
    products: [
        .executable(name: "LicensePlist", targets: ["LicensePlist"]),
        .library(name: "LicensePlistCore", targets: ["LicensePlistCore"]),
        .plugin(name: "LicensePlistBuildTool", targets: ["LicensePlistBuildTool"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git",
                 from: "1.1.4"),
        .package(url: "https://github.com/ishkawa/APIKit.git",
                 from: "5.3.0"),
        .package(url: "https://github.com/Kitura/HeliumLogger.git",
                 from: "2.0.0"),
        .package(url: "https://github.com/behrang/YamlSwift.git",
                 from: "3.4.4"),
        .package(url: "https://github.com/Kitura/swift-html-entities.git",
                 from: "4.0.1"),
        .package(url: "https://github.com/YusukeHosonuma/SwiftParamTest",
                 .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .executableTarget(
            name: "LicensePlist",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "LicensePlistCore",
                "HeliumLogger",
            ]
        ),
        .target(
            name: "LicensePlistCore",
            dependencies: [
                "APIKit",
                "HeliumLogger",
                .product(name: "HTMLEntities", package: "swift-html-entities"),
                .product(name: "Yaml", package: "YamlSwift")
            ]
        ),
        .testTarget(
            name: "LicensePlistTests",
            dependencies: ["LicensePlistCore", "SwiftParamTest"],
            exclude: [
                "Resources",
                "XcodeProjects",
            ]
        ),
        .plugin(
            name: "LicensePlistBuildTool",
            capability: .buildTool(),
            dependencies: ["LicensePlist"]
        )
    ]
)
