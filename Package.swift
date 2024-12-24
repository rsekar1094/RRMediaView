// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RRMediaView",
    platforms: [
        .iOS(.v15)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RRMediaView",
            targets: ["RRMediaView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.3.1"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "3.4.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RRMediaView",
            dependencies: [
                "Kingfisher",
                .product(name: "Lottie", package: "lottie-ios")
            ]
        )
    ]
)
