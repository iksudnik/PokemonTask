//
//  File.swift
//  
//
//  Created by Ilya Sudnik on 1.04.24.
//

import Foundation
import Models

public extension Location {
	static let kanto = Self(title: "Kanto")

	static let ilex = Self(title: "Ilex")

	static let johto = Self(title: "Johto")

	static let viridian = Self(title: "Viridian")
}


public extension [Location] {
	static let mock: Self = [.kanto, .ilex, .johto, .viridian]
}
