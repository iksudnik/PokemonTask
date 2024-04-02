import Foundation

public struct Location: Equatable {
	public let title: String

	public init(title: String) {
		self.title = title
	}
}

extension Location: CustomStringConvertible {
	public var description: String {
		return title
	}
}
