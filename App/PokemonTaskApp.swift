//
//  PokemonTaskApp.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import SwiftUI
import AppFeature

@main
struct PokemonTaskApp: App {
	var body: some Scene {
		WindowGroup {
			AppView(store: .init(
				initialState: AppFeature.State()) {
					AppFeature()
				})
		}
	}
}
