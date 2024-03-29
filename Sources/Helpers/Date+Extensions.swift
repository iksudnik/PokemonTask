import Foundation

public extension DateFormatter {
	static let event: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat =  "EEE d MMM"
		return formatter
	}()
}


// Just for fast mocking
public extension DateFormatter {
	static let `default`: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy"
		return formatter
	}()
}

public extension Date {
	static func from(string: String) -> Date {
		return DateFormatter.default.date(from: string) ?? Date()
	}
}




