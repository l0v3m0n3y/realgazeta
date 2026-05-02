// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "realgazeta",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "realgazeta", targets: ["realgazeta"]),
    ],
    targets: [
        .target(
            name: "realgazeta",
            path: "src"
        ),
    ]
)
