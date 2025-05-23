// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyCoinsServices",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MyCoinsServices",
            type: .dynamic,
            targets: ["MyCoinsServices"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.2")),
        .package(path: "MyCoinsCore")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyCoinsServices",
            dependencies: [
                "Alamofire",
                "MyCoinsCore",
            ]
        ),
        .testTarget(
            name: "MyCoinsServicesTests",
            dependencies: [
                "MyCoinsServices"
            ]
        ),
    ]
)
