//
//  SessionView.swift
//  hitManWatch Watch App
//
//  Created by matt nafarrete on 11/18/22.
//

import SwiftUI
import HealthKit



struct SessionView: View {
    
    
    
    enum SessionState {
        case active, paused
    }
    
    
    
    @State private var sessionState: SessionState = .active
    
    @ObservedObject var healthMAnager: HealthManager
    
    let heartRateQuantity = HKUnit(from: "count/min")
    
    
    
//    @State private var count = 0
    
    
    var body: some View {
        VStack {
            HStack {
                Text("\(String(Int(healthMAnager.heartRate)))")
                    .fontWeight(.regular)
                    .font(.system(size: 25 * widthRatio))
                Text("BPM")
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .font(.system(size: 20 * widthRatio))

            }
            Spacer()
            IndicatorView(healthManager: healthMAnager)
            Spacer()
            ProgressView(healthManager: healthMAnager)
            Spacer()
            HStack {
                Text(healthMAnager.elapsedTime)
                    .fontWeight(.regular)
                    .font(.system(size: 18 * widthRatio))
                Text("TIME")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .font(.system(size: 15 * widthRatio))
                Spacer()
                IntervalView(healthManager: healthMAnager)
            }
            Spacer()
            HStack {
                if sessionState == .active {
                    Button("Pause") {
                        DispatchQueue.main.async {
                            healthMAnager.state = .paused
                            healthMAnager.pause()
                            sessionState = .paused
                        }
                    }
                    .frame(height: 30 * heightRatio)
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                } else {
                    Button("Exit") {
                        DispatchQueue.main.async {
                            healthMAnager.state = .inactive
                            healthMAnager.end()
                            inGameState = false
                        }
                    }
                    .font(.system(size: 15 * widthRatio))
                    .frame(height: 30 * heightRatio)
                    .buttonStyle(.bordered)
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    

                    Spacer()
                    Button("Resume") {
                        DispatchQueue.main.async {
                            healthMAnager.state = .active
                            healthMAnager.resume()
                            sessionState = .active
                            
                        }
                    }
                    .font(.system(size: 15 * widthRatio))
                    .frame(height: 30 * heightRatio)
                    .buttonStyle(.bordered)
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(15)

                }
            }
        }
        .onAppear(perform: healthMAnager.start)
    }
    
    
}

struct IndicatorView: View {
    @ObservedObject var healthManager: HealthManager
    var body: some View {
        HStack {
            Image(systemName: healthManager.indicatorIconName)
            Text(String(healthManager.hiHeartRate))
                .fontWeight(.bold)
                .font(.system(size: 25 * widthRatio))
            Image(systemName: healthManager.indicatorIconName)
        }
        .frame(maxWidth: .infinity, maxHeight: 42 * heightRatio)
        .padding(2)
        .background(Color(healthManager.indicatorColor))
        .cornerRadius(20)
    }
}

struct ProgressView: View {
    @ObservedObject var healthManager: HealthManager
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .frame(width:width * 0.9, height: 15 * heightRatio)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 20)
                .frame(width:CGFloat(healthManager.windowScore), height: 15 * heightRatio)
                .foregroundColor(.green)
        }
    }
}

struct IntervalView: View {
    @ObservedObject var healthManager: HealthManager
    var body: some View {
        Text("\(healthManager.completedIntervals)/\(healthManager.numberOfInts)")
            .fontWeight(.regular)
            .font(.system(size: 18 * widthRatio))
        Text("INT")
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .font(.system(size: 15 * widthRatio))
    }
}

