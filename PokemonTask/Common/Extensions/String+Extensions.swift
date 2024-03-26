//
//  String+Extensions.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 26.03.24.
//

import Foundation

extension String {
	func capitalizingFirstLetter() -> String {
		return prefix(1).capitalized + dropFirst()
	}
}
