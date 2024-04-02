import ComposableArchitecture
import Models

@Reducer
public struct HomeTopBarFeature {
	@ObservableState
	public struct State: Equatable {
		public var isLoggedIn: Bool
		public var locations: [Location]

		public init(isLoggedIn: Bool = false, locations: [Location] = []) {
			self.isLoggedIn = isLoggedIn
			self.locations = locations
		}
	}

	public enum Action {
		case delegate(Delegate)

		@CasePathable
		public enum Delegate {
			case loginButtonTapped
			case locationSelected(Location)
		}
	}

	public init() {}
}

