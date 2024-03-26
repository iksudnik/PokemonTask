//
//  SectionView.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 25.03.24.
//

import SwiftUI

struct SectionView<Content>: View where Content: View {
	private let title: String
	private let content: () -> Content

	init(title: String, @ViewBuilder content: @escaping () -> Content) {
		self.title = title
		self.content = content
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text(title)
				.font(.system(size: 16, weight: .semibold))
			content()
		}
	}
}

#Preview {
	SectionView(title: "This Weak") {
		RoundedRectangle(cornerRadius: 8)
			.fill(.accent)
	}
}

