//
//  ExerciseListView.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-17.
//

import ComposableArchitecture
import SwiftUI

struct AddExerciseListFeature: Reducer {

	struct State: Equatable {
		var exercises: IdentifiedArrayOf<AddExerciseItemFeature.State>
	}

	enum Action {
		case tappedCancel
		case tappedCreate
		case exerciseItem(id: AddExerciseItemFeature.State.ID, action: AddExerciseItemFeature.Action)
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .tappedCancel:
				return .none
			case .tappedCreate:
				let saved = state.exercises.filter { $0.selected == true }
				print(saved)
				return .none
			case .exerciseItem(id: _, action: _):
				return .none
			}
		}

		.forEach(\.exercises, action: /Action.exerciseItem(id:action:)) {
			AddExerciseItemFeature()
		}
	}


}

struct AddExerciseListView: View {

	let store: StoreOf<AddExerciseListFeature>

    var body: some View {
		WithViewStore(store, observe: \.exercises) { viewStore in

			VStack {

				HStack {
					Button(Strings.cancel) {
						viewStore.send(.tappedCancel)
					}
					.padding(16)
					Spacer()
					Text(Strings.addExercise)
					Spacer()
					Button(Strings.create) {
						viewStore.send(.tappedCreate)
					}
					.padding(16)
				}

				ScrollView {
					LazyVGrid(columns: [.init()]) {

						ForEachStore(
							self.store.scope(
								state: \.exercises,
								action: AddExerciseListFeature.Action.exerciseItem(id:action:))
						) { childStore in
							return AddExerciseItemView(store: childStore)
						}

					}
				}
			}
		}
    }
}

struct AddExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseListView(
			store: Store(initialState: .init(exercises: [
				.init(name: "Bench", muscles: ["Chest"], image: nil),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil),
				.init(name: "Bench", muscles: ["Chest"], image: nil),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil),
				.init(name: "Bench", muscles: ["Chest"], image: nil),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil),
				.init(name: "Bench", muscles: ["Chest"], image: nil),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil),
				.init(name: "Bench", muscles: ["Chest"], image: nil),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil),
				.init(name: "Bench", muscles: ["Chest"], image: nil),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil),
				.init(name: "Bench", muscles: ["Chest"], image: nil),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil),
				.init(name: "Bench", muscles: ["Chest"], image: nil),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil),
			]), reducer: AddExerciseListFeature())
		)
    }
}
