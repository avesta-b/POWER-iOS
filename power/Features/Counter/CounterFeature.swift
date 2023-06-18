//
//  CounterFeature.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-15.
//

import ComposableArchitecture
import SwiftUI

struct CounterFeature: Reducer {

	struct State: Equatable {
		var count: Int = 0
		var fact: String?
		@PresentationState var cardItem: WorkoutCardItemFeature.State?
	}

	enum Action {
		case incrementButtonTapped
		case decrementButtonTapped
		case factButtonTapped
		case cardItem(PresentationAction<WorkoutCardItemFeature.Action>)
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch (action) {
			case .incrementButtonTapped:
				state.count += 1
				return .none
			case .decrementButtonTapped:
				state.count -= 1
				return .none
			case .factButtonTapped:
				state.cardItem = .init(title: "Pull 1", description: ["ABCD"])
				return .none
			case .cardItem(_):
				return .none
			}
		}
		.ifLet(\.$cardItem, action: /Action.cardItem) {
			WorkoutCardItemFeature()
		}
	}

}

struct CounterView: View {

	let store: StoreOf<CounterFeature>

	var body: some View {
		NavigationStack {
			WithViewStore(store, observe: { $0 }) { viewStore in
				VStack {
					Text("\(viewStore.count)")
						.font(.largeTitle)
						.padding()
						.background(Color.black.opacity(0.1))
						.cornerRadius(10)
					HStack {
						Button("-") {
							viewStore.send(.decrementButtonTapped)
						}
						.font(.largeTitle)
						.padding()
						.background(Color.black.opacity(0.1))
						.cornerRadius(10)
						Button("+") {
							viewStore.send(.incrementButtonTapped)
						}
						.font(.largeTitle)
						.padding()
						.background(Color.black.opacity(0.1))
						.cornerRadius(10)
					}
					Button("Fact") {
						viewStore.send(.factButtonTapped)
					}
					.font(.largeTitle)
					.padding()
					.background(Color.black.opacity(0.1))
					.cornerRadius(8)
					if let factString = viewStore.fact {
						Text(factString)
					}
				}
				.navigationDestination(
					store: self.store.scope(state: \.$cardItem,
											action: { .cardItem($0) })) { subStore in
												WorkoutCardItemView(store: subStore)
											}
			}
		}
	}
}

struct CounterPreview: PreviewProvider {

	static var previews: some View {
		CounterView(
			store: Store(initialState: CounterFeature.State()) {
				CounterFeature()
			}
		)
	}

}
