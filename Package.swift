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
		.library(name: "EventItemFeature", targets: ["EventItemFeature"]),
		.library(name: "EventDetailsFeature", targets: ["EventDetailsFeature"]),
		.library(name: "EventsListFeature", targets: ["EventsListFeature"]),
		.library(name: "FeaturedEventFeature", targets: ["FeaturedEventFeature"]),
		.library(name: "Helpers", targets: ["Helpers"]),
		.library(name: "HomeFeature", targets: ["HomeFeature"]),
		.library(name: "HomeTopBarFeature", targets: ["HomeTopBarFeature"]),
		.library(name: "Models", targets: ["Models"]),
		.library(name: "Mocks", targets: ["Mocks"]),
		.library(name: "PokemonConnectButtonFeature", targets: ["PokemonConnectButtonFeature"]),
		.library(name: "PokemonItemFeature", targets: ["PokemonItemFeature"]),
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
			name: "EventItemFeature",
			dependencies: [
				"Models",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
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
				"EventItemFeature",
				"Models",
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
				"Models",
				"SwiftUIHelpers",
				"PokemonDetailsFeature",
				"PokemonsListFeature",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "HomeTopBarFeature",
			dependencies: [
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
				"PokemonConnectButtonFeature",
				"SwiftUIHelpers",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "PokemonItemFeature",
			dependencies: [
				"Models",
				"SwiftUIHelpers",
				"PokemonConnectButtonFeature",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "PokemonConnectButtonFeature",
			dependencies: [
				"Models",
				"RepositoryClient",
				"SwiftUIHelpers",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
		.target(
			name: "PokemonsListFeature",
			dependencies: [
				"Models",
				"PokemonItemFeature",
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
				.product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
			]),
		.target(
			name: "TicketsFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]),
	]
)
