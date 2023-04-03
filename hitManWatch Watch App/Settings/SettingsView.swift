//
//  ContentView.swift
//  hitManWatch Watch App
//
//  Created by matt nafarrete on 11/18/22.
//

import SwiftUI
import HealthKit

let screenBounds = WKInterfaceDevice.current().screenBounds
let height = screenBounds.height
let width = screenBounds.width
let widthRatio = width / 200
let heightRatio = height / 250
var inGameState = false

struct SettingsView: View {
    
    @StateObject var healthManager = HealthManager()
    
    @State private var currentHeatRate = 0
    @State private var hiHeartRate: Int = 150
    @State private var numberOfInts: Int = 2
    @State private var hiWindow: Int = 20
    @State private var liWindow: Int = 20
    
    let heartRateQuantity = HKUnit(from: "count/min")
    
    var body: some View {
        VStack {
            if healthManager.state == .inactive {
                HStack(spacing:35) {
                    VStack {
                        Picker("", selection: $hiHeartRate) {
                            ForEach(100...225, id:\.self) {
                                Text("\($0)")
                            }
                        }
                        .font(.system(size: 25 * widthRatio))
                        .frame(width: 60 * widthRatio, height: 42 * heightRatio)
                        Text("HI HR")
                            .frame(height: 10 * heightRatio)
                            .font(.system(size: 15 * widthRatio))
                    }
                    VStack {
                        Picker("", selection: $numberOfInts) {
                            ForEach(0...10, id:\.self) {
                                Text("\($0)")
                            }
                        }
                            .font(.system(size: 25 * widthRatio))
                            .frame(width: 60 * widthRatio, height: 42 * heightRatio)
                        Text("INTS")
                            .frame(height: 10 * heightRatio)
                            .font(.system(size: 15 * widthRatio))
                    }
                }
                HStack(spacing:35) {
                    VStack {
                        Picker("", selection: $hiWindow) {
                            ForEach(10...90, id:\.self) {
                                Text("\($0)")
                            }
                        }
                            .font(.system(size: 25 * widthRatio))
                            .frame(width: 60 * widthRatio, height: 42 * heightRatio)
                        Text("HI WIN")
                            .frame(height: 10 * heightRatio)
                            .font(.system(size: 15 * widthRatio))
                    }
                    VStack {
                        Picker("", selection: $liWindow) {
                            ForEach(10...90, id:\.self) {
                                Text("\($0)")
                            }
                        }
                            .font(.system(size: 25 * widthRatio))
                            .frame(width: 60 * widthRatio, height: 42 * heightRatio)
                        Text("LI WIN")
                            .frame(height: 10 * heightRatio)
                            .font(.system(size: 15 * widthRatio))
                    }
                    
                }
                Text("\(currentHeatRate)")
                    .fontWeight(.regular)
                    .font(.system(size: 25 * widthRatio))
                
                Text("CURENT BPM")
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .font(.system(size: 15 * widthRatio))
                Button("Start") {
                    print("start pressed")
                    healthManager.hiHeartRate = Double(hiHeartRate)
                    healthManager.hiWindow = Double(hiWindow)
                    healthManager.liWindow = Double(liWindow)
                    healthManager.numberOfInts = numberOfInts
                    healthManager.state = .active
                }
                .frame(width: width * 0.8, height: 35 * heightRatio)
                .buttonStyle(.bordered)
                .cornerRadius(15)
                
            } else {
                SessionView(healthMAnager: healthManager)
            }
        }
        .padding()
        .onAppear(perform: start)
    }
    
    private func start() {
        
        healthManager.healthStore.requestAuthorization(toShare: healthManager.sampleTypes, read: healthManager.sampleTypes) { (chk, error) in
            if (chk) {
                print("permission granted")
            } else {
                print("ERROR!!!")
                print(error as Any)
            }
        }
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            // 3
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
            
        self.process(samples, type: quantityTypeIdentifier)

        }
        
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // 5
        
        healthManager.healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.currentHeatRate = Int(lastHeartRate)
        }
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
