//
//  WorkoutTab.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-23.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutTab: View {

	var body: some View {
		NavigationStack {
			Text("F")
				.navigationTitle(Strings.workout)
		}
	}
}


struct WorkoutTab_Preview: PreviewProvider {
	static var previews: some View {
		WorkoutTab()
	}
}
