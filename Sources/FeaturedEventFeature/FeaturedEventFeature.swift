import ComposableArchitecture
import Models

@Reducer
public struct FeaturedEventFeature: Sendable {
	@ObservableState
	public struct State: Equatable {
		public var event: FeaturedEvent
		
		public init(event: FeaturedEvent) {
			self.event = event
		}
	}

	public enum Action: Sendable {
		case delegate(Delegate)

		@CasePathable
		public enum Delegate: Sendable {
			case eventTapped(Event)
		}
	}

	public init() {}

	public var body: some ReducerOf<Self> {
		EmptyReducer()
	}
}
