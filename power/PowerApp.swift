//
//  powerApp.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-11.
//

import ComposableArchitecture
import SwiftUI

@main
struct PowerApp: App {
	let persistenceController = PersistenceController.shared

	private static let store = Store(initialState: CounterFeature.State()) {
		CounterFeature()
	}

	var body: some Scene {
		WindowGroup {
			TabPage(
				store: Store(
					initialState: TabPageFeature.State(currentTab: .exercises),
					reducer: TabPageFeature())
				)
		}
	}
}
