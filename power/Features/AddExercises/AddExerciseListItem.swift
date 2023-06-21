//
//  ExerciseListItem.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-17.
//

import ComposableArchitecture
import SwiftUI

struct AddExerciseItemFeature: Reducer {

	struct State: Equatable, Identifiable {
		let id = UUID()
		let name: String
		let muscles: [String]
		let image: Image?
		var selected: Bool = false

		struct ExtractedState: Equatable, Identifiable {
			let id: UUID
			let name: String
			let muscles: [String]
			let image: Image?
			init(from state: State) {
				self.id = state.id
				self.name = state.name
				self.muscles = state.muscles
				self.image = state.image
			}
		}
	}

	enum Action {
		case tappedListItem
		case tappedSeeData
	}

	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case .tappedListItem:
			state.selected.toggle()
			return .none
		case .tappedSeeData:
			return .none
		}
	}
}

struct AddExerciseItemView: View {

	let store: StoreOf<AddExerciseItemFeature>

	var body: some View {
		WithViewStore(store, observe: { $0 }) { (viewStore: ViewStoreOf<AddExerciseItemFeature>) in
			HStack {

				Image(systemName: Images.workoutImage)
					.resizable(resizingMode: .stretch)
					.scaledToFit()
					.frame(maxWidth: 36)
					.padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))

				VStack(alignment: .leading, spacing: 8) {
					Text(viewStore.state.name)
					Text(viewStore.state.muscles.joined(separator: ","))
						.foregroundColor(.secondary)
				}.padding(12)

				Spacer()

				Button {
					viewStore.send(.tappedSeeData)
				} label: {
					Image(systemName: Images.pieChartImage)
						.resizable(resizingMode: .stretch)
						.scaledToFit()
						.frame(width: 24)
						.foregroundColor(.mint)
						.padding(16)
				}


			}
			.contentShape(Rectangle())
			.onTapGesture {
				withAnimation(.easeOut(duration: 0.1)) {
					viewStore.send(.tappedListItem)
					return
				}
			}
			.padding(vertical: 2)
			.background(viewStore.selected ? Color.cyan.opacity(0.2): .clear)
			.cornerRadius(16)
			.overlay(
				RoundedRectangle(cornerRadius: 16)
					.stroke(Color.mint, lineWidth: 2)
			)
			.padding(horizontal: 16, vertical: 4)
		}
	}
}

struct AddExerciseItemView_Previews: PreviewProvider {
	static var previews: some View {
		AddExerciseItemView(
			store: Store(initialState: .init(name: "Bench", muscles: ["Chest"], image: nil), reducer: {
				AddExerciseItemFeature()
			})
		)
	}
}
