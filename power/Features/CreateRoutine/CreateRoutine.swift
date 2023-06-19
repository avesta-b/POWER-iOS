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
		@BindingState var textFieldState: String =  ""
		let bool: Bool = false
		@PresentationState var addExercise: AddExerciseFeature.State?
	}

	enum Action {
		case editTitle(TextFieldWithClearFeature.Action)
		case addExercise(PresentationAction<AddExerciseFeature.Action>)
		case cancelTapped
		case saveTapped
		case presentAddScreenTapped
		case didEditTextField(String)
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case let .addExercise(.presented(.delegate(.tappedAddExercises(selectedExercises)))):
				print(selectedExercises)
				return .none
			case .editTitle(_):
				return .none
			case .addExercise(_):
				return .none
			case .cancelTapped:
				return .none
			case .saveTapped:
				return .none
			case .presentAddScreenTapped:
				state.addExercise = .init(exercises: [
					.init(name: "Foo", muscles: ["Jeff"], image: nil),
					.init(name: "B", muscles: ["A"], image: nil)
				])
				return .none
			case let .didEditTextField(newText):
				state.textFieldState = newText
				return .none
			}
		}
		.ifLet(\.$addExercise, action: /Action.addExercise) {
			AddExerciseFeature()
		}


	}
}

struct CreateRoutineView: View {

	let store: StoreOf<CreateRoutineFeature>


	var body: some View {
		WithViewStore(store, observe: \.textFieldState ) { viewStore in
			NavigationStack {
				VStack {
					TextFieldWithClearView(
						titleKey: Strings.routineTitle,
						textFont: .body,
						prompt: Text(Strings.routineTitle).font(.body),
						text: viewStore.binding(get: { $0 }, send: { .didEditTextField($0) })
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
					Button(Strings.addExercise) {
						viewStore.send(.presentAddScreenTapped)
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
