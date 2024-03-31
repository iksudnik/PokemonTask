import Foundation
import Helpers

public struct Pokemon: Decodable, Identifiable, Equatable {
	public let id: Int32
	public let name: String
	public let height: Int32
	public let weight: Int32
	public let order: Int32
	public let imageUrl: URL?
	public var isConnected: Bool = false

	enum CodingKeys: String, CodingKey {
		case id, name, height, weight, order, sprites
	}

	enum SpritesCodingKeys: String, CodingKey {
		case other
	}

	enum OtherSpritesCodingKeys: String, CodingKey {
		case officialArtwork = "official-artwork"
	}

	enum OfficialArtworkCodingKeys: String, CodingKey {
		case frontDefault = "front_default"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int32.self, forKey: .id)
		height = try container.decode(Int32.self, forKey: .height)
		weight = try container.decode(Int32.self, forKey: .weight)
		order = try container.decode(Int32.self, forKey: .order)

		let rawName = try container.decode(String.self, forKey: .name)
		self.name = rawName.capitalized

		if let spritesContainer = try? container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites),
		   let otherContainer = try? spritesContainer.nestedContainer(keyedBy: OtherSpritesCodingKeys.self, forKey: .other),
		   let officialArtworkContainer = try? otherContainer.nestedContainer(keyedBy: OfficialArtworkCodingKeys.self, forKey: .officialArtwork),
		   let imageUrlString = try? officialArtworkContainer.decode(String.self, forKey: .frontDefault) {
			imageUrl = URL(string: imageUrlString)
		} else {
			imageUrl = nil
		}
	}
}

public extension Pokemon {
	init(id: Int32, name: String, height: Int32, weight: Int32,
		 order: Int32, imageUrl: URL? = nil, isConnected: Bool) {
		self.id = id
		self.name = name
		self.height = height
		self.weight = weight
		self.order = order
		self.imageUrl = imageUrl
		self.isConnected = isConnected
	}
}
