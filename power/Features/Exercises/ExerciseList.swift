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
		let exercises: [ExerciseListItemFeature.State]
	}

	enum Action {
		case tappedSave
	}

	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case .tappedSave:
			let selectedItems = state.exercises.filter { $0.selected == true }
			print(selectedItems)
			return .none
		}
	}

}

struct ExerciseListView: View {

	let store: StoreOf<ExerciseListFeature>

    var body: some View {
		WithViewStore(store, observe: \.exercises) { viewStore in
			ScrollView {
				Button("Foo") {
					viewStore.send(.tappedSave)
				}
				LazyVGrid(columns: [.init()]) {
					ForEach(viewStore.state) { item in
						ExerciseListItemView(
							store: Store(initialState: item, reducer: ExerciseListItemFeature()))
						.padding(horizontal: 16)
					}
				}
			}
		}
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListView(
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
			]), reducer: ExerciseListFeature())
		)
    }
}
