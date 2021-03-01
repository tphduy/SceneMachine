// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SceneMachine",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "SceneMachine",
            targets: ["SceneMachine"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SceneMachine",
            dependencies: []),
        .testTarget(
            name: "SceneMachineTests",
            dependencies: ["SceneMachine"]),
    ]
)
