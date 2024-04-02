import ComposableArchitecture
import SwiftUI
import SwiftUIHelpers
import PokemonsListFeature

public struct EventDetailsView: View {
	let store: StoreOf<EventDetailsFeature>

	private let sideOffset: CGFloat = 12

	public init(store: StoreOf<EventDetailsFeature>) {
		self.store = store
	}

	public var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				Color.secondary
					.aspectRatio(1, contentMode: .fit)
					.overlay {
						Image(store.event.image)
							.resizable()
							.scaledToFill()
					}
					.clipped()

				VStack(alignment: .leading, spacing: 4) {
					Text(store.event.title)
						.font(.system(size: 16))
						.multilineTextAlignment(.leading)
					Group {
						Text(store.event.dateString)
						Text(store.event.location)
					}
					.font(.system(size: 16))
					.foregroundStyle(.secondary)
				}
				.padding(.horizontal, sideOffset)

				if let store = store.scope(state: \.pokemons, action: \.pokemons) {
					SectionView(title: "Featured Pokemons",
								titleOffset: sideOffset) {
						PokemonsListView(store: store,
										 contentHorizontalPadding: sideOffset)
					}
				}
			}
		}
		.ignoresSafeArea(edges: .top)
		.navigationTitle(store.event.title)
		.scrollIndicators(.hidden)
		.toolbar(.hidden, for: .tabBar)
		.task {
			store.send(.onTask)
		}
	}
}

// MARK: - Previews

#Preview {
	EventDetailsView(store: Store(
		initialState: EventDetailsFeature.State(event: .event1)) {
			EventDetailsFeature()
		}
	)
}
