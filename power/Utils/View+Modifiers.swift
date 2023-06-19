//
//  View+Extensions.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-16.
//

import SwiftUI

extension View {

	@inlinable func padding(horizontal: CGFloat) -> some View {
		return self.padding(EdgeInsets(top: 0, leading: horizontal, bottom: 0, trailing: horizontal))
	}

	@inlinable func padding(vertical: CGFloat) -> some View {
		return self.padding(EdgeInsets(top: vertical, leading: 0, bottom: vertical, trailing: 0))
	}

	@inlinable func padding(horizontal: CGFloat, vertical: CGFloat) -> some View {
		return self.padding(EdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal))
	}
	
}
