//
//  ExerciseListItem.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-17.
//

import ComposableArchitecture
import SwiftUI

struct ExerciseListItemFeature: Reducer {

	struct State: Equatable {
		let name: String
		let muscles: [String]
		let image: Image?
		var selected: Bool = true
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

struct ExerciseListItemView: View {

	let store: StoreOf<ExerciseListItemFeature>

	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			HStack(spacing: 8) {

				if viewStore.state.selected {
					Rectangle()
						.frame(width: 16, height: 20)
						.cornerRadius(4)
				}

				Text("Img")
					.padding(horizontal: 12)

				VStack(alignment: .leading, spacing: 8) {
					Text(viewStore.state.name)
					Text(viewStore.state.muscles.joined(separator: ","))
				}

				Spacer()

				Image(systemName: "chart.xyaxis.line")
					.resizable(resizingMode: .stretch)
					.frame(width: 32, height: 32)
					.foregroundColor(.mint)
					.padding(horizontal: 12)
					.onTapGesture {
						viewStore.send(.tappedSeeData)
					}
			}
			.border(.blue)
			.padding(8)
			.contentShape(Rectangle())
			.onTapGesture {
				withAnimation(.easeOut(duration: 0.1)) {
					viewStore.send(.tappedListItem)
					return
				}
			}
		}
	}
}

struct ExerciseListItemView_Previews: PreviewProvider {
	static var previews: some View {
		ExerciseListItemView(
			store: Store(initialState: .init(name: "Bench", muscles: ["Chest"], image: nil), reducer: {
				ExerciseListItemFeature()
			})
		)
	}
}
