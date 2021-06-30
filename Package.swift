// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PMNetworking",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "PMNetworking",
            type: .dynamic,
            targets: ["PMNetworking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AFNetworking/AFNetworking.git", .upToNextMajor(from: "4.0.0")),
        .package(name: "Crypto", url: "https://gitlab.protontech.ch/apple/shared/pmcrypto.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "PMNetworking",
            dependencies: ["Crypto", "AFNetworking"],
            path: "PMNetworking/Sources",
            exclude: [
                "README.md",
                "Info.plist"],
            resources: [
                .process("PMNetworking/Assets")
            ],
            cSettings: [ CSetting.define("ENABLE_BITCODE", to: "NO")],
            cxxSettings: [CXXSetting.define("ENABLE_BITCODE", to: "NO")]),
    ],
    swiftLanguageVersions: [.v5]
)
