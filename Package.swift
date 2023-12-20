// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SeerBitCheckout",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SeerBitCheckout",
            targets: ["SeerBitCheckout"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.18.3"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "2.2.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SeerBitCheckout",
            dependencies: [
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ],
//            path: "Sources",
            resources: [.process("Sources/SeerBitCheckout/PackageAssets.xcassets"), 
                .process("Sources/SeerBitCheckout/customFonts")]
            
        ),
        .testTarget(
            name: "SeerBitCheckoutTests",
            dependencies: ["SeerBitCheckout"]),
    ]
)
