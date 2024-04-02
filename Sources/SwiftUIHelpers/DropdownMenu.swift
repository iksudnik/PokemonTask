import SwiftUI

public struct DropdownMenu<Item>: View where Item: CustomStringConvertible {
	@State private var selectedIndex: Int = 0 {
		didSet {
			itemSelected(items[selectedIndex])
		}
	}

	@State private var show: Bool = false

	private var items: [Item]
	private let itemSelected: (Item) -> Void

	public init(items: [Item],
				itemSelected: @escaping (Item) -> Void) {
		self.items = items
		self.itemSelected = itemSelected
	}

	public var body: some View {
		ZStack {
			Text(String(describing: items[selectedIndex]))
				.font(.system(size: 20, weight: .semibold))
				.padding(.bottom, 4)
				.overlay(
					Rectangle()
						.frame(height: 2)
						.foregroundColor(.primary),
					alignment: .bottom
				)
				.zIndex(1)
				.onTapGesture {
					show.toggle()
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.overlay(alignment: .bottomLeading) {
					Group {
						if show {
							VStack(alignment: .leading, spacing: 12) {
								ForEach(items.indices, id: \.self) { index in
									Button(action: {
										show = false
										selectedIndex = index
									}, label: {
										Text(String(describing: items[index]))
											.font(.system(size: 18, weight: .semibold))
											.tint(.primary)
									})
								}
							}
							.padding(.vertical, 12)
							.padding(.leading, 4)
							.padding(.trailing, 16)
							.background(.background.opacity(0.5))
							.fixedSize()
							.transition(.opacity)
						}
					}
					.alignmentGuide(.bottom) { $0[.top] }
				}
				.animation(.bouncy, value: show)
		}
	}
}




#Preview {
	DropdownMenu(items: ["Kanto", "Something", "Something2"]) { item in
		print(item)
	}
	.padding()

}
