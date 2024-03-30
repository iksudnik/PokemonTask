import ComposableArchitecture
import EventItemFeature
import Models

@Reducer
public struct EventsListFeature {
	@ObservableState
	public struct State: Equatable {
		public var events: IdentifiedArrayOf<Event>

		public init(events: IdentifiedArrayOf<Event> = []) {
			self.events = events
		}
	}

	public enum Action {
		case delegate(Delegate)

		@CasePathable
		public enum Delegate {
			case eventTapped(Event)
		}
	}

	public init() {}
}
