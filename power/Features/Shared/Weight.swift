//
//  Weight.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-20.
//

import Foundation

enum Weight: Equatable {
	case pounds(Double?)
	case kilograms(Double?)

	private static let ratio: Double = 2.205

	var converted: Weight {
		switch self {
		case .pounds(let double):
			guard let double = double else { return .kilograms(nil) }
			return .kilograms(double / Self.ratio)
		case .kilograms(let double):
			guard let double = double else { return .pounds(nil) }
			return .pounds(double * Self.ratio)
		}
	}

	var displayValue: String {
		switch self {
		case .pounds(let double), .kilograms(let double):
			guard let double = double else { return "" }
			if floor(double) == double {
				return "\(Int(double))"
			} else {
				return String(format: "%.1f", double)
			}
		}
	}

	mutating func setWeight(_ newWeight: Double) {
		switch self {
		case .pounds(_):
			self = .pounds(newWeight)
		case .kilograms(_):
			self = .kilograms(newWeight)
		}
	}
}
