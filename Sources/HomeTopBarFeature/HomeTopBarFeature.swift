import ComposableArchitecture
import Models

@Reducer
public struct HomeTopBarFeature: Sendable {
	@ObservableState
	public struct State: Equatable {
		public var isLoggedIn: Bool
		public var locations: [Location]

		public init(isLoggedIn: Bool = false, locations: [Location] = []) {
			self.isLoggedIn = isLoggedIn
			self.locations = locations
		}
	}

	public enum Action: Sendable {
		case delegate(Delegate)

		@CasePathable
		public enum Delegate: Sendable {
			case loginButtonTapped
			case locationSelected(Location)
		}
	}

	public init() {}

	public var body: some ReducerOf<Self> {
		EmptyReducer()
	}
}

