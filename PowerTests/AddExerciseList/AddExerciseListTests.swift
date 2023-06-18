//
//  AddExerciseListTests.swift
//  powerTests
//
//  Created by Avesta Barzegar on 2023-06-18.
//

import ComposableArchitecture
import XCTest
@testable import power

final class AddExerciseListTests: XCTestCase {

	private static let initialItems: IdentifiedArrayOf<AddExerciseItemFeature.State> = [
		AddExerciseItemFeature.State(name: "Bench Press", muscles: ["Chest"], image: nil),
		AddExerciseItemFeature.State(name: "Squat", muscles: ["Legs"], image: nil),
		AddExerciseItemFeature.State(name: "Deadlift", muscles: ["Lower back"], image: nil)
	]

	func testMultipleSelections() async {

		let items = Self.initialItems

		let store = TestStore(
			initialState: AddExerciseListFeature.State(exercises: items),
			reducer: AddExerciseListFeature())
	}

}
