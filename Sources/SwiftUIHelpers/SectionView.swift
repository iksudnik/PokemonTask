import SwiftUI

public struct SectionView<Content>: View where Content: View {
	private let title: String
	private let titleOffset: CGFloat
	private let content: () -> Content

	public init(title: String, titleOffset: CGFloat = 12, @ViewBuilder content: @escaping () -> Content) {
		self.title = title
		self.titleOffset = titleOffset
		self.content = content
	}

	public var body: some View {
		VStack(alignment: .leading) {
			Text(title)
				.font(.system(size: 16, weight: .semibold))
				.padding(.leading, titleOffset)
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

