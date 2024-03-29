import ComposableArchitecture
import HomeFeature
import SearchFeature
import TicketsFeature

@Reducer
public struct AppFeature {

	@ObservableState
	public struct State: Equatable {
		public var selection: Selection
		public var homeTab: HomeFeature.State
		public var searchTab: SearchFeature.State
		public var ticketsTab: TicketsFeature.State

		public init(selection: AppFeature.Selection = .home,
			 homeTab: HomeFeature.State = .init(),
			 searchTab: SearchFeature.State = .init(),
			 ticketsTab: TicketsFeature.State = .init()) {
			self.selection = selection
			self.homeTab = homeTab
			self.searchTab = searchTab
			self.ticketsTab = ticketsTab
		}
	}

	@CasePathable
	public enum Action {
		case homeTab(HomeFeature.Action)
		case searchTab(SearchFeature.Action)
		case ticketsTab(TicketsFeature.Action)
	}

	public enum Selection: Hashable {
		case home
		case search
		case tickets
	}

	public init() {}
	
	public var body: some ReducerOf<Self> {
		Scope(state: \.homeTab, action: \.homeTab) {
			HomeFeature()
		}

		Scope(state: \.searchTab, action: \.searchTab) {
			SearchFeature()
		}
		
		Scope(state: \.ticketsTab, action: \.ticketsTab) {
			TicketsFeature()
		}

		Reduce { state, action in
			return .none
		}
	}
}
