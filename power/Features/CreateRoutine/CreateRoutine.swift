//
//  CreateRoutine.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-18.
//

import ComposableArchitecture
import SwiftUI

struct CreateRoutineFeature: Reducer {

	struct State: Equatable {
		var textFieldState = TextFieldWithClearFeature.State(titleKey: "Routine title", textFont: .title3, prompt: Text("A").font(.title3))
		@PresentationState var addExercise: AddExerciseFeature.State?
	}

	enum Action {
		case editTitle(TextFieldWithClearFeature.Action)
		case addExercise(PresentationAction<AddExerciseFeature.Action>)
		case cancelTapped
		case saveTapped
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .editTitle(_):
				return .none
			case .addExercise(_):
				return .none
			case .cancelTapped:
				return .none
			case .saveTapped:
				return .none
			}
		}
		.ifLet(\.$addExercise, action: /Action.addExercise) {
			AddExerciseFeature()
		}
		Scope(state: \.textFieldState, action: /Action.editTitle) {
			TextFieldWithClearFeature()
		}

	}
}

struct CreateRoutineView: View {

	let store: StoreOf<CreateRoutineFeature>

	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			NavigationStack {
				VStack {
					TextFieldWithClearView(
						store: self.store.scope(
							state: \.textFieldState,
							action: CreateRoutineFeature.Action.editTitle)
					)
					.padding(16)

					Spacer()
					Image(systemName: Images.workoutImage)
						.resizable()
						.scaledToFit()
						.frame(width: 48)
						.foregroundColor(.mint)
						.padding(8)
					Text("Get started by adding an exercise to your routine")
						
						.padding(horizontal: 32)
				}
				.navigationTitle(Strings.createRoutine)
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(Strings.cancel) {
							viewStore.send(.cancelTapped)
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button(Strings.save) {
							viewStore.send(.saveTapped)
						}
					}
				}
			}
		}
	}
}

struct CreateRoutineView_Previews: PreviewProvider {
	static var previews: some View {
		CreateRoutineView(
			store: Store(initialState: CreateRoutineFeature.State(), reducer: CreateRoutineFeature())
		)
	}
}
