//
//  TabPage.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-16.
//

import ComposableArchitecture
import SwiftUI

struct TabPageFeature: Reducer {

	enum Tab: Int, Equatable, CaseIterable {
		case profile
		case history
		case exercises
		case workout
		case upgrade
	}

	struct State: Equatable {
		var currentTab: Tab
	}

	enum Action: Equatable {
		case selectedTab(Tab)
	}

	var body: some Reducer {
		Reduce<State, Action> { state, action in
			switch action {
			case let .selectedTab(tab):
				state.currentTab = tab
				return .none
			}
		}
	}

	func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
		switch(action) {
		case let .selectedTab(tab):
			state.currentTab = tab
			return .none
		}
	}

}


struct TabPage: View {

	let store: StoreOf<TabPageFeature>
	
	var body: some View {
		WithViewStore(store, observe: \.currentTab) { viewStore in
			TabView(selection: viewStore.binding(send: TabPageFeature.Action.selectedTab)) {
				Button(Strings.exercises, action: {
					viewStore.send(.selectedTab(.exercises))
				})
				.tabItem { Text(Strings.profile) }
				.tag(TabPageFeature.Tab.profile)
				Text("ASD")
					.tabItem { Text(Strings.history) }
					.tag(TabPageFeature.Tab.history)
				Text("ASD")
					.tabItem { Text(Strings.exercises) }
					.tag(TabPageFeature.Tab.exercises)
				Text("ASD")
					.tabItem { Text(Strings.workout) }
					.tag(TabPageFeature.Tab.workout)
				Text("ASD")
					.tabItem { Text(Strings.workout) }
					.tag(TabPageFeature.Tab.upgrade)
			}
		}
	}

}

struct TabPage_Previews: PreviewProvider {
	static var previews: some View {
		ForEach(TabPageFeature.Tab.allCases, id: \.rawValue) { tab in
			TabPage(
				store: Store(
					initialState: TabPageFeature.State(currentTab: tab),
					reducer: TabPageFeature()
				)
			)
		}
	}

}
