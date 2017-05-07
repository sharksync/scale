import PackageDescription

let package = Package(
    name: "scale",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0),
        .Package(url: "https://github.com/sharksync/SWSQLite.git", majorVersion: 1)
    ]
)
