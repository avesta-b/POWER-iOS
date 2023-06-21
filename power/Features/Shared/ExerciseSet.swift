//
//  ExerciseSet.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-19.
//

import Foundation

struct ExerciseSet: Equatable, Identifiable {
	let id = UUID()
	var weight: Weight
	var reps: UInt32?
}
