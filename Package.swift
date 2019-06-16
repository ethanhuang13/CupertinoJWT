// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CupertinoJWT",
	platforms: [
      .macOS(.v10_12),
   ],
	products: [
		.library( name: "CupertinoJWT", targets: ["CupertinoJWT"]),
	],
     targets: [
		.target(name: "CupertinoJWT", path:"Sources"),
	],
	swiftLanguageVersions: [.v5]
)
