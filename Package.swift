// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuesstionableIntelligence",
    platforms: [
      .iOS(.v13),
      .macOS(.v10_15),
      .tvOS(.v13),
      .watchOS(.v6),
    ],
    dependencies: [
         .package(url: "https://github.com/autoreleasefool/quess-engine", branch: "main"),
         .package(url: "https://github.com/vapor/console-kit", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "QuesstionableIntelligence",
            dependencies: [
              .product(name: "ConsoleKit", package: "console-kit"),
              .product(name: "QuessEngine", package: "quess-engine"),
            ]
        ),
        .testTarget(
            name: "QuesstionableIntelligenceTests",
            dependencies: ["QuesstionableIntelligence"]
        ),
    ]
)
