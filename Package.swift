// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swift Scientifics",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Swift Scientifics",
            targets: ["Swift Scientifics"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/NSHipster/DBSCAN",
            from: "0.0.1"
        ),
//         .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Swift Scientifics",
            dependencies: []),
        .testTarget(
            name: "Swift ScientificsTests",
            dependencies: ["Swift Scientifics"]),
    ]
)
