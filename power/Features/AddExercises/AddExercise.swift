//
//  ExerciseListView.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-17.
//

import ComposableArchitecture
import SwiftUI

struct AddExerciseFeature: Reducer {

	struct State: Equatable {
		var exercises: IdentifiedArrayOf<AddExerciseItemFeature.State>

		var selectedExercises: IdentifiedArrayOf<AddExerciseItemFeature.State> {
			return exercises.filter { $0.selected == true }
		}
	}

	enum Action {
		case tappedCancel
		case tappedCreate
		case tappedAddExercises
		case exerciseItem(id: AddExerciseItemFeature.State.ID, action: AddExerciseItemFeature.Action)
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .tappedCancel:
				return .none
			case .tappedCreate:
				return .none
			case .tappedAddExercises:
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

struct AddExerciseView: View {

	let store: StoreOf<AddExerciseFeature>

    var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in

			VStack {
				HStack {
					Button(Strings.cancel) {
						viewStore.send(.tappedCancel)
					}
					.font(.title3)
					.padding(16)

					Spacer()
					Text(Strings.addExercise)
						.font(.title3)
					Spacer()

					Button(Strings.create) {
						viewStore.send(.tappedCreate)
					}
					.font(.title3)
					.padding(16)
				}

				ZStack {
					ScrollView {
						LazyVGrid(columns: [.init()]) {

							ForEachStore(
								self.store.scope(
									state: \.exercises,
									action: AddExerciseFeature.Action.exerciseItem(id:action:))
							) { childStore in
								AddExerciseItemView(store: childStore)
							}
						}
					}

					if viewStore.state.selectedExercises.isEmpty == false {
						VStack {
							Spacer()
							Button(Strings.addExercises(count: viewStore.state.selectedExercises.count)) {
								viewStore.send(.tappedAddExercises)
							}
							.font(.headline)
							.foregroundColor(Color(UIColor.systemBackground))
							.padding(16)
							.background(Color.mint)
							.cornerRadius(16)
						}

					}
				}

			}
		}
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(
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
			]), reducer: AddExerciseFeature())
		)
    }
}
