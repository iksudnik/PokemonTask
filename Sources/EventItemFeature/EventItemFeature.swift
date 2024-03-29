import ComposableArchitecture
import Models

@Reducer
public struct EventItemFeature {
	@ObservableState
	public struct State: Equatable, Identifiable {
		public var id: Event.ID { event.id }
		public var event: Event

		public init(event: Event) {
			self.event = event
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

