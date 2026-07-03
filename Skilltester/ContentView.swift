//
//  ContentView.swift
//  Skilltester
//
//  Created by Luky on 02.07.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var timeElapsed = 0
    @State private var state: String = "settings" // nezapomen zmenit na start
    @State private var randomWait: Float = 0.0
    @State private var isMeasuring: Bool = false
    @State private var result = 0
    @State private var clickTimes: [Float] = []//[214, 170, 190, 305, 187] // SMAZAT PRED RUNEM
    @State private var testCount = 0
    @State private var avaTime: Float = 0
    
    @State private var minWaitTime: Float = 1.5
    @State private var maxWaitTime: Float = 3.0
    @State private var slider1Value: Double = 1.5
    @State private var slider2Value: Double = 3.0
    
    var slider1ValueText: String {
        String(format: "%.1f", slider1Value)
    }
    var slider2ValueText: String {
        String(format: "%.1f", slider2Value)
    }
    
    let testCountGoal = 5
    
    let graphWh: CGFloat = 50
    let graphCr: CGFloat = 8
    let graphHt: CGFloat = 100

    
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    func startTest(name: String) -> String {
        
        return "0"
    }

    
    var body: some View {
        ZStack {
            if state == "start" {
                ZStack {
                    Button(action: {
                        randomWait = Float.random(in: minWaitTime...maxWaitTime)
                        print("starting game..")
                        state = "wait"
                        print("Waiting..")
                        testCount += 1
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(randomWait * 1_000_000_000))
                            
                            if state == "wait" {
                                print("Done waiting!")
                                isMeasuring = true
                                state = "click"
                                timeElapsed = 0
                            }
                        }
                        
                    }) {
                        Text("Start")
                            .bold()
                            .padding(.horizontal, 50)
                            .padding(.vertical, 50)
                            .frame(minWidth: 700, minHeight: 600)
                            .background(Color.green)
                            .font(.largeTitle)
                        
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                    
                    Button(action: {
                        state = "settings"
                        clickTimes.removeAll()
                    }) {
                        Text("Settings")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.black)
                            .clipShape(Capsule())
                            .padding(.top, 500)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                    
                }.navigationTitle("Skilltester - Reaction time")
            }
            
            if state == "wait" {
                Button(action: {
                    state = "prefired"
                    print("Prefired.")
                }) {
                    Text("Wait for green")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.red)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
            }
            
            if state == "click" {
                Button(action: {
                    result = timeElapsed
                    isMeasuring = false
                    clickTimes.append(Float(result))
                    testCount += 1
                    
                    print("Clicked at \(result) ms!")
                    state = "clicked"
                }) {
                    Text("Click!")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.green)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                if isMeasuring == true {
                    Text("\(timeElapsed) ms.")
                        .padding(.top, 35)
                }
            }
            
            if state == "clicked" {
                Button(action: {
                    randomWait = Float.random(in: minWaitTime...maxWaitTime)
                    if testCount <= testCountGoal {
                        print("starting new game.. (\(testCount)/5)")
                        state = "wait"
                        print("Waiting..")
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(randomWait * 1_000_000_000))
                            
                            if state == "wait" {
                                print("Done waiting!")
                                isMeasuring = true
                                state = "click"
                                timeElapsed = 0
                            }
                        }
                    } else {
                        print("End")
                        print(clickTimes)
                        state = "end"
                        for i in clickTimes {
                            avaTime = avaTime + i
                        }
                        avaTime = avaTime / Float(testCountGoal)
                        print(avaTime)
                    }
                    
                }) {
                    Text("Click to continue")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.blue)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                
                Text("\(result) ms.")
                    .padding(.top, 35)
            }
            
            if state == "prefired" {
                Button(action: {
                    print("starting game..")
                    state = "wait"
                    print("Waiting..")
                    randomWait = Float.random(in: minWaitTime...maxWaitTime)
                    Task {
                        try? await Task.sleep(nanoseconds: UInt64(randomWait) * 1_000_000_000)
                        
                        if state == "wait" {
                            print("Done waiting!")
                            isMeasuring = true
                            state = "click"
                            timeElapsed = 0
                        }
                    }
                }) {
                    Text("Too soon!")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.red)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                
                Text("Click again to start.")
                    .padding(.top, 35)
            }
            
            if state == "end" {
                Button(action: {
                    state = "results"
                }) {
                    Text("End")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.black)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                
                Text("Click to see results.")
                    .padding(.top, 35)
            }
            
            if state == "results" {
                
                VStack {
                    ZStack {
                        Text("Results")
                            .bold()
                            .font(.largeTitle)
                            //.padding(.vertical, 1)
                            .padding(.horizontal, 200)
                        Text("Results")
                            .bold()
                            .font(.largeTitle)
                            //.padding(.vertical, 10)
                            .padding(.horizontal, 50)
                    }
                    
                    HStack(spacing: 10) {
                        Text("First: \(Int(clickTimes[0]))ms")
                        Text("Second: \(Int(clickTimes[1]))ms")
                        Text("Third: \(Int(clickTimes[2]))ms")
                        Text("Fourth: \(Int(clickTimes[3]))ms")
                        Text("Fifth: \(Int(clickTimes[4]))ms")

                    }// .padding(.vertical, 10)
                    
                    HStack(spacing: 30) {
                        RoundedRectangle(cornerRadius: graphCr)
                            .size(width: graphWh, height: CGFloat(clickTimes[0]/(clickTimes.max() ?? 150)*150))
                            .frame(width: 50)
                        RoundedRectangle(cornerRadius: graphCr)
                            .size(width: graphWh, height: CGFloat(clickTimes[1]/(clickTimes.max() ?? 150)*150))
                            .frame(width: 50)
                        RoundedRectangle(cornerRadius: graphCr)
                            .size(width: graphWh, height: CGFloat(clickTimes[2]/(clickTimes.max() ?? 150)*150))
                            .frame(width: 50)
                        RoundedRectangle(cornerRadius: graphCr)
                            .size(width: graphWh, height: CGFloat(clickTimes[3]/(clickTimes.max() ?? 150)*150))
                            .frame(width: 50)
                        RoundedRectangle(cornerRadius: graphCr)
                            .size(width: graphWh, height: CGFloat(clickTimes[4]/(clickTimes.max() ?? 150)*150))
                            .frame(width: 50)
                    }.navigationTitle("Skilltester - Reaction time, Results")
                    
                    HStack {
                        Text("Best: \(Int(clickTimes.min() ?? 0.0))ms")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.green)
                        Text("Avarage: \(Int(avaTime))ms")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Worst: \(Int(clickTimes.max() ?? 0.0))ms")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.red)
                    }//.padding(.vertical, 1)
                    Button(action: {
                        state = "start"
                        clickTimes.removeAll()
                    }) {
                        Text("Start again")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .padding(.top, 100)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                }.padding(.vertical, 10)
                    .navigationTitle("Skilltester - Reaction time")
                
                
                
            }
            
            if state == "settings" {
                ZStack {
                    
                    Rectangle()
                        .size(width: 700, height: 700)
                        .fill(Color.black)
                        .ignoresSafeArea()
                    
                    Text("Settings")
                        .bold()
                        .font(.largeTitle)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 550)
                    
                    Button(action: {
                        state = "start"
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }.padding(.top, 500)
                        .buttonStyle(.plain)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            Text("Min. wait time:")
                            Slider(value: $slider1Value, in: 0.5...10, step: 0.5)
                                .tint(.green)
                                .frame(width: 250)
                            Text("\(slider1ValueText) ms.")
                        }
                        HStack {
                            Text("Max. wait time:")
                            Slider(value: $slider2Value, in: 0.5...10, step: 0.5)
                                .tint(.green)
                                .frame(width: 250)
                            Text("\(slider2ValueText) ms.")
                        }
                    }
                    
                }.padding(.vertical, 10)
                    .navigationTitle("Skilltester - Reaction time, Settings")
            }
            
        }.navigationTitle("Skilltester - Reaction time")
        // .frame(width: 300, height: 400)
        .onReceive(timer) { _ in
            timeElapsed += 1
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
