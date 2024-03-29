import SwiftUI
import SDWebImageSwiftUI

public struct PokemonImageView: View {
	public var imageUrl: URL?

	public init(imageUrl: URL? = nil) {
		self.imageUrl = imageUrl
	}

    public var body: some View {
		Circle()
			.fill(Color(.systemGray6))
			.overlay {
				WebImage(url: imageUrl) { image in
					image
						.resizable()
						.scaleEffect(.init(width: 0.8, height: 0.8), anchor: .bottom)
				} placeholder: {
					Image(.shadow)
						.resizable()
						.scaleEffect(.init(width: 0.7, height: 0.7), anchor: .bottom)
				}
			}
    }
}

#Preview {
	let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
	return PokemonImageView(imageUrl: url)
}
