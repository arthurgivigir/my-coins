// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyCoinsUIComponents",
    platforms: [
        .macOS(.v11),
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MyCoinsUIComponents",
            type: .dynamic,
            targets: ["MyCoinsUIComponents", "MyCoinsWidgetUIComponents"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "MyCoinsCore"),
        .package(url: "https://github.com/willdale/SwiftUICharts.git", from: "2.10.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyCoinsUIComponents",
            dependencies: ["MyCoinsCore", "SwiftUICharts"],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-no_application_extension"])]),
        .target(
            name: "MyCoinsWidgetUIComponents",
            dependencies: ["MyCoinsCore", "MyCoinsUIComponents"]),
        .testTarget(
            name: "MyCoinsUIComponentsTests",
            dependencies: ["MyCoinsUIComponents"]),
    ]
)
