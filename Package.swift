// swift-tools-version:4.0
import PackageDescription

let package = Package(
	name: "Niles",
	products: [
		.library(
			name: "HTTP",
			targets: ["HTTP"]),
	],
	targets: [
		.target(
			name: "HTTP",
			dependencies: []),
		.testTarget(
			name: "HTTPTests",
			dependencies: ["HTTP"]),
	]
)
