//
//  HealthManager.swift
//  hitManWatch Watch App
//
//  Created by matt nafarrete on 11/23/22.
//

import Foundation
import HealthKit
import SwiftUI


class HealthManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate  {
    
    enum WorkoutState {
        case inactive, active, paused
    }
    
    enum GameState {
        case high, low
    }
    
    enum TrackingState {
        case at, high, low
    }
    
    let sampleTypes: Set<HKSampleType> = [
        .workoutType(),
        .quantityType(forIdentifier: .heartRate)!,
        .quantityType(forIdentifier: .activeEnergyBurned)!
    ]
    
    
    var hiHeartRate: Double = 150.0
    var numberOfInts: Int = 2
    var hiWindow: Double = 20.0
    var liWindow: Double = 20.0
    
    var timer: Timer = Timer()
    var count = 0
    @Published var trackingState: TrackingState = .low
    @Published var gameState: GameState = .low
    @Published var elapsedTime: String = "00:00"
    @Published var windowScore: Double = 0.0
    @Published var completedIntervals = 0
    
    @Published var state = WorkoutState.inactive
    @Published var heartRate = 0.0
    @Published var energyBurned = 0.0
    
    @Published var indicatorColor: UIColor = .blue
    @Published var indicatorIconName: String = "arrow.up"
    
    
    
    var healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?
    
    
    let activity = HKWorkoutActivityType.highIntensityIntervalTraining
    
    func startSession() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }

    @objc func timerCounter() {
        count += 1
        let time = secondsToMintuesSeconds(seconds: count )
        elapsedTime = makeTimeString(min: time.0, sec: time.1)
        
        runGame()
        
    }
    
    func runGame() {
        if gameState == .high {
            if heartRate >= hiHeartRate {
                trackingState = .at
                windowScore += Double(width) * 0.9/hiWindow
                indicatorColor = .green
                indicatorIconName = "checkmark"
            } else {
                indicatorColor = .red
                trackingState = .low
                indicatorIconName = "arrow.up"
            }
            
            if windowScore >= Double(width) * 0.9 {
                windowScore = 0
                completedIntervals += 1
                gameState = .low
                WKInterfaceDevice.current().play(.stop)
            }
        } else {
            if heartRate < hiHeartRate {
                trackingState = .at
                windowScore += Double(width) * 0.9/liWindow
                indicatorColor = .green
                indicatorIconName = "checkmark"
            } else {
                indicatorColor = .blue
                trackingState = .high
                indicatorIconName = "arrow.down"
            }
            if windowScore >= Double(width) * 0.9 {
                windowScore = 0
                gameState = .high
                WKInterfaceDevice.current().play(.stop)
            }
        }
        
        if completedIntervals == numberOfInts {
            state = .inactive
            WKInterfaceDevice.current().play(.stop)
            end()
        }
    }

    func secondsToMintuesSeconds(seconds: Int) -> (Int, Int) {
        return(((seconds % 3600)/60), ((seconds % 3600) % 60))
    }

    func makeTimeString(min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func start() {
        healthStore.requestAuthorization(toShare: sampleTypes, read: sampleTypes) { success, error in
            if success {
                self.beginWorkout()
            } else {
                print(error as Any)
            }
        }
    }
    
    private func beginWorkout() {
        let config = HKWorkoutConfiguration()
        config.activityType = activity
        config.locationType = .outdoor
        
        do {
            //start our workout
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
            
            workoutSession?.delegate = self
            workoutBuilder?.delegate = self
            
            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date()) { success, error in
                guard success else { return }
                DispatchQueue.main.async {
                    self.state = .active
                    self.startSession()
                }
            }
        } catch {
            //handle errors
        }
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            guard let statistics = workoutBuilder.statistics(for: quantityType) else { continue }
            
            DispatchQueue.main.async {
                switch statistics.quantityType {
                case HKQuantityType.quantityType(forIdentifier: .heartRate):
                    let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                    self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                    let value = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                    self.energyBurned = value
                default:
                    break
                }
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        //collecting events...for tracking number of intervals
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            switch toState {
            case .running:
                self.state = .active
            case .paused:
                self.state = .paused
            case .ended:
                self.save()
            default:
                break
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        //handle errors here
    }
    
    private func save () {
        workoutBuilder?.endCollection(withEnd: Date()) { success, error in
            if success {
                self.workoutBuilder?.finishWorkout() { workout, error in
                    DispatchQueue.main.async {
                        self.state = .inactive
                    }
                    
                }
            }
        }
    }
    
    func pause() {
        workoutSession?.pause()
        timer.invalidate()
    }
    
    func resume() {
        workoutSession?.resume()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    func end() {
        workoutSession?.end()
        count = 0
        elapsedTime = "00:00"
        windowScore = 0
        completedIntervals = 0
        state = .inactive
        gameState = .high
        timer.invalidate()
    }
}

