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
		var textFieldState = TextFieldWithClearFeature.State(titleKey: Strings.routineTitle, textFont: .title3, prompt: Text(Strings.routineTitle).font(.title3))
		@PresentationState var addExercise: AddExerciseFeature.State?
	}

	enum Action {
		case editTitle(TextFieldWithClearFeature.Action)
		case addExercise(PresentationAction<AddExerciseFeature.Action>)
		case cancelTapped
		case saveTapped
		case addTapped
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
			case .addTapped:
				state.addExercise = .init(exercises: [])
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
					Text(Strings.getStartedByAddingAnExercise)
						.multilineTextAlignment(.center)
						.padding(horizontal: 32)
					Button("Add exercises") {
						viewStore.send(.addTapped)
					}
					.font(.headline)
					.foregroundColor(Color(UIColor.systemBackground))
					.padding(16)
					.background(Color.mint)
					.cornerRadius(16)
					.padding(8)
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
			.sheet(
				store: self.store.scope(
					state: \.$addExercise,
					action: { .addExercise($0) })) { presentationStore in
				AddExerciseView(store: presentationStore)
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
