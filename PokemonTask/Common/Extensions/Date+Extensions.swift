//
//  Date+Extensions.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import Foundation

extension DateFormatter {
	static let event: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat =  "EEE d MMM"
		return formatter
	}()
}


// Just for fast mocking
extension DateFormatter {
	static let `default`: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy"
		return formatter
	}()
}

extension Date {
	static func from(string: String) -> Date {
		return DateFormatter.default.date(from: string) ?? Date()
	}
}




