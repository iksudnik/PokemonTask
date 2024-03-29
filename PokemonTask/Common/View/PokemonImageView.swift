//
//  PokemonImageView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonImageView: View {
	var imageUrl: URL?
	
    var body: some View {
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
	PokemonImageView(imageUrl: Pokemon.bulbasaur.imageUrl)
}
