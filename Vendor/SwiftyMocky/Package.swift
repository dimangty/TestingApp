// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swiftymocky",
    products: [
        .library(name: "SwiftyMocky", targets: ["SwiftyMocky"]),
        .library(name: "SwiftyPrototype", targets: ["SwiftyPrototype"]),
    ],
    targets: [
        .target(
            name: "SwiftyMocky",
            path: "Sources/SwiftyMocky",
            exclude: ["Mock.swifttemplate"]
        ),
        .target(
            name: "SwiftyPrototype",
            path: "Sources/SwiftyPrototype",
            exclude: ["Prototype.swifttemplate"]
        ),
    ]
)
