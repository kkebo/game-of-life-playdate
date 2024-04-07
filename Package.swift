// swift-tools-version: 5.10

import PackageDescription

let gccIncludePrefix = "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1"

let playdateSDKPath =
    if let path = Context.environment["PLAYDATE_SDK_PATH"] {
        path
    } else {
        "\(Context.environment["HOME"]!)/Developer/PlaydateSDK"
    }

let package = Package(
    name: "game-of-life-playdate",
    products: [
        .library(name: "GameOfLifePlaydate", targets: ["GameOfLifePlaydate"])
    ],
    dependencies: [
        .package(url: "https://github.com/finnvoor/PlaydateKit", branch: "main"),
        .package(url: "https://github.com/kkebo/GameOfLife.swiftpm", branch: "embedded"),
    ],
    targets: [
        .target(
            name: "GameOfLifePlaydate",
            dependencies: [
                "PlaydateKit",
                .product(name: "GameOfLife", package: "GameOfLife.swiftpm"),
            ],
            exclude: [
                "Resources/logo.png",
                "Resources/pdxinfo",
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
                .unsafeFlags(["-I", "\(playdateSDKPath)/C_API"]),
            ]
        )
    ]
)
