//
//  RoutineListItem.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-19.
//

import ComposableArchitecture
import SwiftUI

struct RoutineListItemFeature: Reducer {

	struct State {
		let image: Image?
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
	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

struct RoutineListItem_Previews: PreviewProvider {
	static var previews: some View {
		RoutineListItemView()
	}
}
