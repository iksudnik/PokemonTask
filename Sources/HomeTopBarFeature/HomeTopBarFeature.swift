import ComposableArchitecture

@Reducer
public struct HomeTopBarFeature {
	@ObservableState
	public struct State: Equatable {
		public var isLoggedIn: Bool

		public init(isLoggedIn: Bool = false) {
			self.isLoggedIn = isLoggedIn
		}
	}

	public enum Action {
		case delegate(Delegate)

		@CasePathable
		public enum Delegate {
			case loginButtonTapped
		}
	}

	public init() {}
}

