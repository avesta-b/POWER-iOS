//
//  AddExerciseListTests.swift
//  powerTests
//
//  Created by Avesta Barzegar on 2023-06-18.
//

import ComposableArchitecture
import XCTest
@testable import power

@MainActor
final class AddExerciseListTests: XCTestCase {

	private static let initialItems: IdentifiedArrayOf<AddExerciseItemFeature.State> = [
		AddExerciseItemFeature.State(name: "Bench Press", muscles: ["Chest"], image: nil),
		AddExerciseItemFeature.State(name: "Squat", muscles: ["Legs"], image: nil),
		AddExerciseItemFeature.State(name: "Deadlift", muscles: ["Lower back"], image: nil)
	]

	func testSelectedFilter() async {

		let items = AddExerciseFeature.State(exercises: [
			AddExerciseItemFeature.State(name: "Exercise A", muscles: [], image: nil, selected: true),
			AddExerciseItemFeature.State(name: "Exercise B", muscles: [], image: nil, selected: false),
			AddExerciseItemFeature.State(name: "Exercise C", muscles: [], image: nil, selected: false),
			AddExerciseItemFeature.State(name: "Exercise D", muscles: [], image: nil, selected: true),
			AddExerciseItemFeature.State(name: "Exercise E", muscles: [], image: nil, selected: true),
			AddExerciseItemFeature.State(name: "Exercise F", muscles: [], image: nil, selected: true),
			AddExerciseItemFeature.State(name: "Exercise G", muscles: [], image: nil, selected: true),
		])

		XCTAssertEqual(items.selectedExercises.count, 5)
		XCTAssertEqual(items.selectedCount, 5)
	}

}
