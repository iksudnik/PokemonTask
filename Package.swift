// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "PokemonTask",
	platforms: [.iOS(.v17)],
	products: [
		.library(name: "ApiClient", targets: ["ApiClient"]),
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "DatabaseClient", targets: ["DatabaseClient"]),
		.library(name: "EventDetailsFeature", targets: ["EventDetailsFeature"]),
		.library(name: "EventsListFeature", targets: ["EventsListFeature"]),
		.library(name: "FeaturedEventFeature", targets: ["FeaturedEventFeature"]),
		.library(name: "Helpers", targets: ["Helpers"]),
		.library(name: "HomeFeature", targets: ["HomeFeature"]),
		.library(name: "HomeTopBarFeature", targets: ["HomeTopBarFeature"]),
		.library(name: "Models", targets: ["Models"]),
		.library(name: "Mocks", targets: ["Mocks"]),
		.library(name: "PokemonDetailsFeature", targets: ["PokemonDetailsFeature"]),
		.library(name: "PokemonsListFeature", targets: ["PokemonsListFeature"]),
		.library(name: "RepositoryClient", targets: ["RepositoryClient"]),
		.library(name: "SearchFeature", targets: ["SearchFeature"]),
		.library(name: "SwiftUIHelpers", targets: ["SwiftUIHelpers"]),
		.library(name: "TicketsFeature", targets: ["TicketsFeature"]),
	],
	dependencies: [
		.package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.1"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.2.2"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.2"),
	],
	targets: [
		.target(
			name: "ApiClient",
			dependencies: [
				"Models",
				"Mocks",
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.target(
			name: "AppFeature",
			dependencies: [
				"HomeFeature",
				"SearchFeature",
				"TicketsFeature",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(
			name: "AppFeatureTests",
			dependencies: ["AppFeature"]
		),
		.target(
			name: "DatabaseClient",
			dependencies: [
				"Models",
				"Mocks",
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.target(
			name: "EventDetailsFeature",
			dependencies: [
				"Models",
				"SwiftUIHelpers",
				"PokemonsListFeature",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "EventsListFeature",
			dependencies: [
				"Models",
				"SwiftUIHelpers",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "FeaturedEventFeature",
			dependencies: [
				"Models",
				"SwiftUIHelpers",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(name: "Helpers"),
		.target(
			name: "Models",
			dependencies: [
				"Helpers",
			]),
		.target(
			name: "HomeFeature",
			dependencies: [
				"FeaturedEventFeature",
				"HomeTopBarFeature",
				"EventDetailsFeature",
				"EventsListFeature",
				"Models",
				"SwiftUIHelpers",
				"PokemonDetailsFeature",
				"PokemonsListFeature",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "HomeTopBarFeature",
			dependencies: [
				"Mocks",
				"Models",
				"SwiftUIHelpers",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "Mocks",
			dependencies: [
				"Models",
			]),
		.target(
			name: "PokemonDetailsFeature",
			dependencies: [
				"Models",
				"SwiftUIHelpers",
				"RepositoryClient",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.testTarget(
			name: "PokemonDetailsFeatureTests",
			dependencies: ["PokemonDetailsFeature"]
		),
		.target(
			name: "PokemonsListFeature",
			dependencies: [
				"Models",
				"SwiftUIHelpers",
				"RepositoryClient",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "RepositoryClient",
			dependencies: [
				"ApiClient",
				"DatabaseClient",
				"Models",
				"Mocks",
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.target(
			name: "SearchFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "SwiftUIHelpers",
			dependencies: [
				"Mocks",
				"Models",
				.product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
			]),
		.target(
			name: "TicketsFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
	]
)
