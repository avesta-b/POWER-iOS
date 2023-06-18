//
//  ExerciseListView.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-17.
//

import ComposableArchitecture
import SwiftUI

struct ExerciseListFeature: Reducer {

	struct State {
		let exercises: [ExerciseListItemFeature.Action]
	}

	enum Action {

	}

	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		return .none
	}

}

struct ExerciseListView: View {
    var body: some View {
		Text("F")
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListView()
    }
}
