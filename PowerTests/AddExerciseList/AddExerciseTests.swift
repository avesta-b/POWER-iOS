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

	func testInitFilter() async {

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

	func testSelected() async {
		let items = AddExerciseFeature.State(exercises: [
			AddExerciseItemFeature.State(name: "Exercise A", muscles: [], image: nil, selected: true),
			AddExerciseItemFeature.State(name: "Exercise B", muscles: [], image: nil, selected: false),
			AddExerciseItemFeature.State(name: "Exercise C", muscles: [], image: nil, selected: false),
			AddExerciseItemFeature.State(name: "Exercise D", muscles: [], image: nil, selected: true),
			AddExerciseItemFeature.State(name: "Exercise E", muscles: [], image: nil, selected: true),
			AddExerciseItemFeature.State(name: "Exercise F", muscles: [], image: nil, selected: true),
			AddExerciseItemFeature.State(name: "Exercise G", muscles: [], image: nil, selected: true),
		])

		let parentStore = Store(initialState: items, reducer: AddExerciseFeature())
		let parentViewStore = ViewStore(parentStore, observe: { $0 })

		let childStore = parentStore.scope(state: { $0.exercises.first! },
										   action: AddExerciseFeature.Action.exerciseItem(id:action:))
		let childViewStore = ViewStore(childStore, observe: { $0 })

		let tappedChild: (AddExerciseItemFeature.State.ID, AddExerciseItemFeature.Action) = (childViewStore.state.id, .tappedListItem)

		childViewStore.send(tappedChild)
		XCTAssertEqual(parentViewStore.state.selectedCount, 4)
		childViewStore.send(tappedChild)
		XCTAssertEqual(parentViewStore.state.selectedCount, 5)
	}

}
