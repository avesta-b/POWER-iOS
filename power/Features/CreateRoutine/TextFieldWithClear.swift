//
//  TextField.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-18.
//

import ComposableArchitecture
import SwiftUI

struct TextFieldWithClearFeature: Reducer {

	struct State: Equatable {
		let titleKey: String
		let textFont: Font?
		let prompt: Text?
		var text: String = ""
	}

	enum Action {
		case didTapClear
		case didUpdateText(String)
	}

	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case let .didUpdateText(newText):
			state.text = newText
			return .none
		case .didTapClear:
			return .send(.didUpdateText(""))
		}
	}

}

struct TextFieldWithClearView: View {

	let store: StoreOf<TextFieldWithClearFeature>

    var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			VStack {
				HStack {
					TextField(
						viewStore.state.titleKey,
						text: viewStore.binding(get: { $0.text }, send: TextFieldWithClearFeature.Action.didUpdateText),
						prompt: viewStore.state.prompt
					)
					.font(viewStore.textFont)
					Spacer()
					Button {
						viewStore.send(.didTapClear)
					} label: {
						if viewStore.text.isEmpty == false {
							Image(systemName: Images.deleteLeftImage)
								.resizable()
								.foregroundColor(.primary)
								.scaledToFit()
								.frame(width: 24)
						}
					}
				}
				Divider()
			}
		}
    }
}

struct TextFieldWithClearView_Previews: PreviewProvider {
    static var previews: some View {
		TextFieldWithClearView(
			store: Store(
				initialState: TextFieldWithClearFeature.State(titleKey: "Some title",
															  textFont: .body,
															  prompt: Text("Foo prompt")),
				reducer: TextFieldWithClearFeature())
		)
    }
}
