// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "http_proxy_override",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(name: "http-proxy-override", targets: ["http_proxy_override"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "http_proxy_override",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ],
            cSettings: [
                .headerSearchPath("include/http_proxy_override"),
            ]
        ),
    ]
)
