import ComposableArchitecture
import EventItemFeature

@Reducer
public struct EventsListFeature {
	@ObservableState
	public struct State: Equatable {
		public var events: IdentifiedArrayOf<EventItemFeature.State>

		public init(events: IdentifiedArrayOf<EventItemFeature.State> = []) {
			self.events = events
		}
	}

	public enum Action {
		case events(IdentifiedActionOf<EventItemFeature>)
	}

	public init() {}
}
