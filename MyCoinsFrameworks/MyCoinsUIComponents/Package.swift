// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyCoinsUIComponents",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
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
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", from: "3.1.2"),
//        .package(name: "Charts", url: "https://github.com/spacenation/swiftui-charts", from: "1.0.0")
        .package(name: "SwiftUICharts", url: "https://github.com/AppPear/ChartView", from: "1.5.5"),
        .package(name: "Charts", url: "https://github.com/danielgindi/Charts", from: "4.0.1"),
        .package(name: "AAInfographics", url: "https://github.com/AAChartModel/AAChartKit-Swift", from: "6.0.0"),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyCoinsUIComponents",
            dependencies: ["MyCoinsCore", "Lottie", "SwiftUICharts", "Charts", "AAInfographics"]),
        .target(
            name: "MyCoinsWidgetUIComponents",
            dependencies: ["MyCoinsCore", "MyCoinsUIComponents"]),
        .testTarget(
            name: "MyCoinsUIComponentsTests",
            dependencies: ["MyCoinsUIComponents"]),
    ]
)
