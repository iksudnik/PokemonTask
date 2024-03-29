//
//  FeaturedEventFeature.swift
//  PokemonTask
//
//  Created by Ilya Sudnik on 29.03.24.
//

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
