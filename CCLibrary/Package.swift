// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "CCLibrary",
        products: [
            .library(
                    name: "CCLibrary",
                    targets: ["CCLibrary"]),
        ],
        dependencies: [
            .package(url: "https://github.com/jpsim/Yams", from: "3.0.0")
        ],
        targets: [
            .target(
                    name: "CCLibrary",
                    dependencies: [
                        "Yams"
                    ]),
            .testTarget(
                    name: "CCLibraryTests",
                    dependencies: ["CCLibrary"]),
        ]
)
