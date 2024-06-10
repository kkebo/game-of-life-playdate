// swift-tools-version: 6.0

import PackageDescription

let gccIncludePrefix = "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1"
guard let home = Context.environment["HOME"] else {
    fatalError("could not determine home directory")
}

let package = Package(
    name: "game-of-life-playdate",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "GameOfLifePlaydate", type: .static, targets: ["GameOfLifePlaydate"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-playdate-examples", branch: "main"),
        .package(url: "https://github.com/kkebo/GameOfLife.swiftpm", branch: "embedded"),
    ],
    targets: [
        .target(
            name: "GameOfLifePlaydate",
            dependencies: [
                .product(name: "Playdate", package: "swift-playdate-examples"),
                .product(name: "GameOfLife", package: "GameOfLife.swiftpm"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags(["-Xfrontend", "-disable-objc-interop"]),
                .unsafeFlags(["-Xfrontend", "-disable-stack-protector"]),
                .unsafeFlags(["-Xfrontend", "-function-sections"]),
                .unsafeFlags(["-Xfrontend", "-gline-tables-only"]),
                .unsafeFlags(["-Xcc", "-DTARGET_EXTENSION"]),
                .unsafeFlags(["-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include"]),
                .unsafeFlags(["-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include-fixed"]),
                .unsafeFlags(["-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/../../../../arm-none-eabi/include"]),
                .unsafeFlags(["-I", "\(home)/Developer/PlaydateSDK/C_API"]),
            ]
        )
    ],
    swiftLanguageVersions: [.version("6")]
)
