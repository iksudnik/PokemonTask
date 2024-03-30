import ComposableArchitecture
import HomeFeature
import SearchFeature
import TicketsFeature

@Reducer
public struct AppFeature {

	@ObservableState
	public struct State: Equatable {
		public var selection: Selection
		public var home: HomeFeature.State
		public var search: SearchFeature.State
		public var tickets: TicketsFeature.State

		public init(selection: AppFeature.Selection = .home,
			 home: HomeFeature.State = .init(),
			 search: SearchFeature.State = .init(),
			 tickets: TicketsFeature.State = .init()) {
			self.selection = selection
			self.home = home
			self.search = search
			self.tickets = tickets
		}
	}

	@CasePathable
	public enum Action {
		case selected(Selection)
		case home(HomeFeature.Action)
		case search(SearchFeature.Action)
		case tickets(TicketsFeature.Action)
	}

	public enum Selection: Hashable {
		case home
		case search
		case tickets
	}

	public init() {}
	
	public var body: some ReducerOf<Self> {
		Scope(state: \.home, action: \.home) {
			HomeFeature()
		}

		Scope(state: \.search, action: \.search) {
			SearchFeature()
		}
		
		Scope(state: \.tickets, action: \.tickets) {
			TicketsFeature()
		}

		Reduce { state, action in
			switch action {

			case let .selected(selection):
				state.selection = selection
				return .none
			case .home, .search, .tickets:
				return .none
			}
		}
	}
}
