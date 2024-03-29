import SwiftUI

public struct SectionView<Content>: View where Content: View {
	private let title: String
	private let content: () -> Content

	public init(title: String, @ViewBuilder content: @escaping () -> Content) {
		self.title = title
		self.content = content
	}

	public var body: some View {
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

