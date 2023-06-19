//
//  ExerciseListView.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-17.
//

import ComposableArchitecture
import SwiftUI

struct AddExerciseFeature: Reducer {

	@Dependency(\.dismiss) var dismiss

	struct State: Equatable {
		var exercises: IdentifiedArrayOf<AddExerciseItemFeature.State>

		var selectedCount: Int = 0

		init(exercises: IdentifiedArrayOf<AddExerciseItemFeature.State>) {
			self.exercises = exercises
			self.selectedCount = selectedExercises.count
		}

		var selectedExercises: IdentifiedArrayOf<AddExerciseItemFeature.State> {
			return exercises.filter { $0.selected == true }
		}
	}

	enum Action {
		case tappedCancel
		case tappedAddCustom
		case tappedAddExercises
		case exerciseItem(id: AddExerciseItemFeature.State.ID, action: AddExerciseItemFeature.Action)
		case delegate(Delegate)

		enum Delegate {
			case tappedAddExercises(IdentifiedArrayOf<AddExerciseItemFeature.State.ExtractedState>)
		}
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .tappedCancel:
				return .run { _ in await self.dismiss() }
			case .tappedAddCustom:
				return .none
			case .tappedAddExercises:
				let exercises: [AddExerciseItemFeature.State.ExtractedState] = state
					.selectedExercises
					.map { AddExerciseItemFeature.State.ExtractedState(from: $0) }

				let selectedExercises: IdentifiedArrayOf<AddExerciseItemFeature.State.ExtractedState> = IdentifiedArrayOf(uniqueElements: exercises)

				return .run { [selectedItems = selectedExercises] send in
					await send(.delegate(.tappedAddExercises(selectedItems)))
					await self.dismiss()
				}

			case let .exerciseItem(id: idValue, action: actionItem):
				switch actionItem {
				case .tappedListItem:
					guard let selectedValue = state.exercises[id: idValue]?.selected else { return .none }
					switch selectedValue {
					case true:
						state.selectedCount += 1
					case false:
						state.selectedCount -= 1
					}
					return .none
				case .tappedSeeData:
					return .none
				}
			case .delegate(_):
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
		WithViewStore(store, observe: \.selectedCount) { viewStore in

			NavigationStack {
				VStack {
					ZStack {
						ScrollView {
							Spacer()
								.frame(height: 24)
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

						if viewStore.state != 0 {
							VStack {
								Spacer()
								Button(Strings.addExercises(count: viewStore.state)) {
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
				.navigationTitle(Strings.addExercise)
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(Strings.cancel) {
							viewStore.send(.tappedCancel)
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button(Strings.addCustom) {
							viewStore.send(.tappedAddCustom)
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
				.init(name: "Bench", muscles: ["Chest"], image: nil, selected: true),
				.init(name: "Deadlift", muscles: ["Back"], image: nil),
				.init(name: "Squat", muscles: ["Legs"], image: nil, selected: true),
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
