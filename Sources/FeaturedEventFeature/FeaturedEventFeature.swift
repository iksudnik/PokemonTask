import ComposableArchitecture
import Models

@Reducer
public struct FeaturedEventFeature {
	@ObservableState
	public struct State: Equatable {
		public var event: FeaturedEvent
		
		public init(event: FeaturedEvent) {
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
