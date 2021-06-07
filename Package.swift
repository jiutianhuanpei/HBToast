// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HBToast",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "HBToast", targets: ["HBToast"]),
    ],
    dependencies: [
        .package(url: "https://gitee.com/jiutianhuanpei/SnapKit.git", from: "5.0.1")
    ],
    targets: [
        .target(name: "HBToast", dependencies: ["SnapKit"]),
        .testTarget(name: "HBToastTests", dependencies: ["HBToast"]),
    ]
)
