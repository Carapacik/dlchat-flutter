// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "image_saver",
    platforms: [
        .macOS("11.0")
    ],
    products: [
        .library(name: "image-saver", targets: ["image_saver"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "image_saver",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
