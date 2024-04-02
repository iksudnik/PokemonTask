import ComposableArchitecture
import Models

@Reducer
public struct EventsListFeature: Sendable {
	@ObservableState
	public struct State: Equatable {
		public var events: IdentifiedArrayOf<Event>

		public init(events: IdentifiedArrayOf<Event> = []) {
			self.events = events
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
