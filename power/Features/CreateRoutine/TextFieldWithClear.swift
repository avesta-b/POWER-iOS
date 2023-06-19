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

	private let titleKey: String
	private let textFont: Font?
	private let prompt: Text?

	private(set) var text: Binding<String>

	init(titleKey: String, textFont: Font?, prompt: Text?, text: Binding<String>) {
		self.titleKey = titleKey
		self.textFont = textFont
		self.prompt = prompt
		self.text = text
	}

	var body: some View {
		VStack {
			HStack {
				TextField(
					titleKey,
					text: text,
					prompt: prompt
				)
				.font(textFont)
				Spacer()
				Button {
					text.wrappedValue = ""
				} label: {
					if text.wrappedValue.isEmpty == false {
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

#if DEBUG

struct Wrapper: View {
	@State var binding = ""

	var body: some View {
		TextFieldWithClearView(
			titleKey: "Routine title",
			textFont: nil,
			prompt: nil,
			text: $binding
		)
	}
}

struct TextFieldWithClearView_Previews: PreviewProvider {
	static var previews: some View {
		Wrapper()
	}
}

#endif
