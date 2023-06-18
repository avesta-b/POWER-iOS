//
//  ExerciseCardItem.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-16.
//

import ComposableArchitecture
import SwiftUI

struct WorkoutCardItemFeature: Reducer {

	struct State: Equatable {
		var title: String
		var description: [String]
	}

	enum Action {
		case tappedStart
		case tappedSeeMore
		case tappedItem(title: String, description: [String])
	}

	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		return .none
	}


}

struct WorkoutCardItemView: View {

	let store: StoreOf<WorkoutCardItemFeature>

	var body: some View {
		
		WithViewStore(store, observe: { $0 }) { viewStore in
			VStack(alignment: .leading) {

				HStack {
					Text(viewStore.state.title)
						.font(.title3)
						.bold()
						.padding(horizontal: 12)
					Spacer()
					Button("See more") {
						viewStore.send(.tappedSeeMore)
					}
					.font(.body)
					.padding(horizontal: 12)
				}

				Text(viewStore.description.joined(separator: ", "))
					.font(.subheadline)
					.padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))

				HStack {
					Spacer()
					Button(Strings.startRoutine) {
						viewStore.send(.tappedStart)
					}
					.font(.title3)
					.padding(16)
					.foregroundColor(Color(uiColor: UIColor.secondaryLabel))
					.background(Color(uiColor: UIColor.secondarySystemFill))
					.cornerRadius(8, antialiased: true)
					Spacer()
				}
			}

		}
	}
}

struct ExerciseCardItemView_Previews: PreviewProvider {
	static var previews: some View {
		WorkoutCardItemView(
			store: Store(
				initialState: WorkoutCardItemFeature.State(title: "Pull 2", description: ["Bench", "Squat", "Deadlift"]),
				reducer: WorkoutCardItemFeature()
			)
		)
	}
}
