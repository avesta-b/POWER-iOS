//
//  powerApp.swift
//  power
//
//  Created by Avesta Barzegar on 2023-06-11.
//

import Accelerate
import CoreMotion
import simd
import ComposableArchitecture
import SwiftUI


class RepetitionDetector {
	let threshold: Double
	let windowSize: Int

	var lastRepDetected: TimeInterval = 0
	var dataWindow: [Double] = []

	init(threshold: Double = 1, windowSize: Int = 10) {
		self.threshold = threshold
		self.windowSize = windowSize
	}

	func addData(x: Double, y: Double, z: Double) {
		let magnitude = sqrt(x * x + y * y + z * z)
		dataWindow.append(magnitude)

		if dataWindow.count > windowSize {
			dataWindow.removeFirst()
		}
	}

	func repetitionDetected() -> Bool {
		if dataWindow.count < windowSize {
			return false
		}

		let currentDate = Date()
		let rollingAverage = dataWindow.reduce(0, +) / Double(dataWindow.count)
		let maxValue = dataWindow.max()!
		let minValue = dataWindow.min()!

		guard currentDate.timeIntervalSince1970 - lastRepDetected > 0.1,
			  abs(maxValue - rollingAverage) >= threshold else {
			return false
		}

		lastRepDetected = currentDate.timeIntervalSince1970
		dataWindow = []

		return true
	}
}





struct AxisMotion: Equatable, Comparable {

	static func < (lhs: AxisMotion, rhs: AxisMotion) -> Bool {
		return abs(lhs.magnitude) < abs(rhs.magnitude)
	}


	enum Direction {
		case x
		case y
		case z
	}

	let direction: Direction
	let magnitude: Double

	static func create(from acceleration: CMAcceleration) -> [AxisMotion] {
		return [.init(direction: .x, magnitude: acceleration.x), .init(direction: .y, magnitude: acceleration.y), .init(direction: .z, magnitude: acceleration.z)]
	}
}

class ExerciseTracker: ObservableObject {

	// Create an instance of the RepetitionDetector
	let repetitionDetector = RepetitionDetector()

	// Create a motion manager for accelerometer data
	let motionManager = CMMotionManager()

	private let tracker = CMMotionManager()
	@Published private(set) var currentReps = 0
	private var trackingFrames = 0
	private let requiredFramesForRep = 5
	private var previousMotion: [AxisMotion] = []
	private let motionThreshold: Double = 0.5

	init() {
		tracker.accelerometerUpdateInterval = 1.0 / 20
	}

	func stop() {
		tracker.stopAccelerometerUpdates()
	}

	func foo() {
		// Start accelerometer updates
		motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
			if let data = accelerometerData {
				let x = data.acceleration.x
				let y = data.acceleration.y
				let z = data.acceleration.z

				// Add data to the detector
				self.repetitionDetector.addData(x: x, y: y, z: z)

				// Check if a repetition occurred
				if self.repetitionDetector.repetitionDetected() {
					self.currentReps += 1
				}
			}
		}
	}

	func startTracking() {
		currentReps = 0
		tracker.startAccelerometerUpdates(to: .main) { [weak self] data, error in
			guard let self = self,
				  let acceleration = data?.acceleration else { return }

			let currentMotion = AxisMotion.create(from: acceleration).filter { abs($0.magnitude) > self.motionThreshold }

			if self.isRepetition(currentMotion: currentMotion, previousMotion: self.previousMotion) {
				self.trackingFrames += 1
				if self.trackingFrames >= self.requiredFramesForRep {
					self.completeRep()
				}
			} else {
				self.resetTracking()
			}

			self.previousMotion = currentMotion
		}
	}

	private func isRepetition(currentMotion: [AxisMotion], previousMotion: [AxisMotion]) -> Bool {
		guard !currentMotion.isEmpty, !previousMotion.isEmpty else { return false }

		let currentVector = self.calculateVector(from: currentMotion)
		let previousVector = self.calculateVector(from: previousMotion)

		let dotProduct = dot(normalize(previousVector), normalize(currentVector))
		return dotProduct < -0.95
	}

	private func calculateVector(from motion: [AxisMotion]) -> simd_double3 {
		let x = motion.first(where: { $0.direction == .x })?.magnitude ?? 0.0
		let y = motion.first(where: { $0.direction == .y })?.magnitude ?? 0.0
		let z = motion.first(where: { $0.direction == .z })?.magnitude ?? 0.0
		return simd_double3(x, y, z)
	}

	private func completeRep() {
		currentReps += 1
		print("Rep completed! Total reps: \(currentReps)")
		resetTracking()
	}

	private func resetTracking() {
		trackingFrames = 0
	}
}




struct SampleView: View {

	@StateObject var obj = ExerciseTracker()

	var body: some View {
		VStack {
			Button("Start tracking") {
				obj.foo()
			}
			Text("Reps done: \(obj.currentReps) ")
			Button("Stop tracking") {
				obj.stop()
			}
		}
	}
}

@main
struct PowerApp: App {
	let persistenceController = PersistenceController.shared

	private static let store = Store(initialState: CounterFeature.State()) {
		CounterFeature()
	}

	var body: some Scene {
		WindowGroup {
			AddExerciseView(
				store: Store(
					initialState: AddExerciseFeature.State(exercises: []),
					reducer: AddExerciseFeature())
			)
//			SampleView()
//			TabPage(
//				store: Store(
//					initialState: TabPageFeature.State(currentTab: .exercises),
//					reducer: TabPageFeature())
//				)
		}
	}
}
