// swift-tools-version: 5.9

// Experimental Swift Package Manager manifest for React Native's SwiftPM
// integration (React Native 0.88 or later). CocoaPods remains the default and
// fully supported integration; see README.md.
//
// SwiftPM does not allow Swift and Objective-C sources in one target, so the
// Objective-C bridge (RCT_EXTERN_MODULE) and the Swift implementation are two
// targets exposed through a single `RNRefiner` product.

import PackageDescription

let package = Package(
    // Must match `swiftpmConfig.name` in package.json.
    name: "RNRefiner",
    platforms: [.iOS("15.1")],
    products: [
        .library(name: "RNRefiner", targets: ["RNRefiner", "RNRefinerObjC"]),
    ],
    dependencies: [
        // Resolved from the autolinker's ios/build/generated/autolinking/libs/<SwiftPM name>
        // symlink: four levels up reaches ios/build, where React Native generates xcframeworks.
        .package(name: "ReactNative", path: "../../../../xcframeworks"),
        .package(url: "https://github.com/refiner-io/mobile-sdk-ios.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "RNRefiner",
            dependencies: [
                .product(name: "ReactHeaders", package: "ReactNative"),
                .product(name: "ReactNativeHeaders", package: "ReactNative"),
                .product(name: "ReactNativeDependenciesHeaders", package: "ReactNative"),
                .product(name: "RefinerSDK", package: "mobile-sdk-ios"),
            ],
            path: "ios",
            exclude: [
                "RNRefiner.xcodeproj",
                "RNRefiner-Bridging-Header.h",
                "RNRefiner.h",
                "RNRefiner.m",
                "RefinerReactNativeSpec",
            ],
            sources: ["RNRefiner.swift", "MapUtil.swift"]
        ),
        .target(
            name: "RNRefinerObjC",
            dependencies: [
                .product(name: "ReactHeaders", package: "ReactNative"),
                .product(name: "ReactNativeHeaders", package: "ReactNative"),
                .product(name: "ReactNativeDependenciesHeaders", package: "ReactNative"),
            ],
            path: "ios",
            exclude: [
                "RNRefiner.xcodeproj",
                "RNRefiner-Bridging-Header.h",
                "RNRefiner.swift",
                "MapUtil.swift",
                "RefinerReactNativeSpec",
            ],
            sources: ["RNRefiner.m"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("RefinerReactNativeSpec"),
            ]
        ),
    ]
)
