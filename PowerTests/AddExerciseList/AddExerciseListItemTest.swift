//
//  ExerciseItemTest.swift
//  powerTests
//
//  Created by Avesta Barzegar on 2023-06-18.
//

import ComposableArchitecture
import XCTest
@testable import power

@MainActor
final class AddExerciseListItemTest: XCTestCase {

	func testSelection() async {
		let addItemFeature = TestStore(
			initialState: AddExerciseItemFeature.State(name: "Bench Press", muscles: ["Chest"], image: nil),
			reducer: AddExerciseItemFeature()
		)

		await addItemFeature.send(.tappedListItem) { state in
			state.selected = true
		}

		await addItemFeature.send(.tappedListItem) { state in
			state.selected = false
		}
	}

}


