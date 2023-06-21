//
//  RoutineListItem.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-19.
//

import ComposableArchitecture
import SwiftUI

struct RoutineListItemFeature: Reducer {
	
	struct State: Equatable {
		let imageName: String
		let name: String
		
		// Notes for the exercise
		var notes: String
		// Nil means that there is no rest timer
		var restTime: UInt32?
		var exerciseSets: IdentifiedArrayOf<ExerciseSet>
	}
	
	enum Action {
		case pressedAddSet
		case editedWeight(ExerciseSet.ID, Double)
		case editedReps(ExerciseSet.ID, UInt32)
		case editedNotes(String)
	}
	
	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case .pressedAddSet:
			// Set ExerciseSet to return the default weight
			let emptySet = ExerciseSet(weight: .kilograms(nil), reps: nil)
			state.exerciseSets.append(emptySet)
			return .none
			
		case let .editedWeight(id, newWeight):
			guard var set = state.exerciseSets[id: id] else {
				assertionFailure("Tried to edit weight on a set that does not exist")
				return .none
			}
			set.weight.setWeight(newWeight)
			return .none
			
		case let .editedReps(id, newReps):
			guard var set = state.exerciseSets[id: id] else {
				assertionFailure("Tried to edit sets on a set that does not exist")
				return .none
			}
			set.reps = newReps
			return .none
			
		case let .editedNotes(newNotes):
			state.notes = newNotes
			return .none
		}
	}
}


struct RoutineListItemView: View {

	private static let gridItems: [GridItem] = [
		GridItem(.fixed(75), spacing: 8, alignment: .center),
		GridItem(.fixed(75), spacing: 8, alignment: .center),
		GridItem(.fixed(75), spacing: 8, alignment: .center)
	]
	
	let store: StoreOf<RoutineListItemFeature>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			LazyVStack {

				HStack {
					Image(viewStore.imageName)
						.padding(16)
						.background(.red)
						.frame(width: 36, height: 36)
						.padding(8)
					Text(viewStore.name)
						.padding(12)
					Spacer()
				}

				TextField(
					"Foo",
					text: viewStore.binding(get: \.notes, send: { noteEdit in .editedNotes(noteEdit)}),
					prompt: Text(Strings.addRoutineNotesHere)
				)
				.padding(horizontal: 16)

				LazyVGrid(columns: Self.gridItems, alignment: .leading, spacing: 12) {

					Text("SET")
					Text("LBS")
					Text("REPS")

					ForEach(Array(viewStore.exerciseSets.elements.enumerated()), id: \.element.id) { index, element in
						Text("\(index)")
						Text("\(element.weight.displayValue)")
						if let reps = element.reps {
							Text("\(reps)")
						} else {
							Text("-")
						}
					}
				}
				.padding(vertical: 8)
			}
			.padding(16)
		}
	}
}

struct RoutineListItem_Previews: PreviewProvider {
	static var previews: some View {
		RoutineListItemView(
			store: Store(initialState: RoutineListItemFeature.State(imageName: "",
																	name: "Bent Over Row (Barbell)",
																	notes: "",
																	exerciseSets: [.init(weight: .pounds(45.0), reps: 8),
																				   .init(weight: .pounds(45.0), reps: 8),
																				   .init(weight: .pounds(45.0), reps: 8)
																	]),
						 reducer: RoutineListItemFeature()
			)
		)
	}
}
