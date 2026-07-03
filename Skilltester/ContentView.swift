//
//  ContentView.swift
//  Skilltester
//
//  Created by Luky on 02.07.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var timeElapsed = 0
    @State private var state: String = "results" // nezapomen zmenit na start
    @State private var randomWait: Float = 0.0
    @State private var isMeasuring: Bool = false
    @State private var result = 0
    @State private var clickTimes: [Float] = [214, 170, 190, 200, 230, 400, 320, 200, 178, 300] // SMAZAT PRED RUNEM
    @State private var testCount = 0
    @State private var avaTime: Float = 0
    
    @State private var minWaitTime: Float = 1.5
    @State private var maxWaitTime: Float = 3.0
    @State private var slider1Value: Double = 1.5
    @State private var slider2Value: Double = 3.0
    @State private var slider3Value: Double = 5
    
    @State private var saveMessage: String = "No changes made."
    
    var slider1ValueText: String {
        String(format: "%.1f", slider1Value)
    }
    var slider2ValueText: String {
        String(format: "%.1f", slider2Value)
    }
    var slider3ValueText: String {
        String(format: "%.0f", slider3Value)
    }
    
    @State private var testCountGoal: Int = 5
    
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
                        saveMessage = "No changes made."
                        slider1Value = Double(minWaitTime)
                        slider2Value = Double(maxWaitTime)
                        slider3Value = Double(testCountGoal)
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
                    testCount = 0
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
                
                ZStack {
                    Text("Results")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 530)
                        .padding(.horizontal, 200)
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
                            .padding(.top, 500)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                }.padding(.vertical, 10)
                    .navigationTitle("Skilltester - Reaction time")
                
                VStack {
                    ForEach(0..<clickTimes.count, id: \.self) { index in
                        ZStack {
                            Text("Run: \(index + 1). \(Int(clickTimes[index])) ms.")
                                .foregroundColor(.white)
                                .font(.title3)
                                .padding(.trailing, 550)
                            RoundedRectangle(cornerRadius: 8)
                                .size(width: CGFloat(clickTimes[index]/(clickTimes.max() ?? 150)*520), height: 15)
                                .padding(.top, 100/(CGFloat(clickTimes.count)*CGFloat(clickTimes.count)))
                                .padding(.leading, 130)
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.bottom, 400)
                    .padding(.top, 18 * CGFloat(clickTimes.count))
                    
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
                }.padding(.top, 390)
                
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
                        testCountGoal = Int(slider3Value)
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }.padding(.top, 500)
                        .buttonStyle(.plain)
                    
                    VStack(spacing: 1) {
                        Text("Wait time:")
                            .font(.title2)
                        ZStack {
                            Text("Min. wait time:")
                                .padding(.trailing, 350)
                            Slider(value: $slider1Value, in: 0.5...8, step: 0.5)
                                .tint(.green)
                                .frame(width: 250)
                                .onChange(of: slider1Value) { newValue in
                                    saveMessage = "Click Save to save values."
                                }
                            Text("\(slider1ValueText) ms.")
                                .padding(.leading, 305)
                        }
                        ZStack {
                            Text("Max. wait time:")
                                .padding(.trailing, 350)
                            Slider(value: $slider2Value, in: 1.5...9, step: 0.5)
                                .tint(.green)
                                .frame(width: 250)
                                .onChange(of: slider2Value) { newValue in
                                    saveMessage = "Click Save to save values."
                                }
                            Text("\(slider2ValueText) ms.")
                                .padding(.leading, 305)
                        }
                        HStack {
                            Button(action: {
                                print("Save button clicked.")
                                if slider2Value >= slider1Value + 1 {
                                    minWaitTime = Float(slider1Value)
                                    maxWaitTime = Float(slider2Value)
                                    saveMessage = "Changes Saved."
                                    print("Saved changes.")
                                } else if slider1Value > slider2Value{
                                    saveMessage = "Min. wait time has to be smaller than Max. wait!"
                                    print("Min is large than Max; didnt save.")
                                } else if slider1Value == slider2Value || slider1Value == slider2Value - 0.5 {
                                    saveMessage = "Min. and Max. wait have to be atleast 1 second apart!"
                                    print("Min and Max not 1s or more part; didnt save.")
                                }
                                
                            }) {
                                Text("Save")
                                    .bold()
                                    .font(.title2)
                                    .frame(width: 56, height: 24)
                                    .background(Color.green)
                                    .clipShape(Capsule())
                            }.buttonStyle(.plain)
                            
                            Text(saveMessage)
                        }
                        
                        Text("Number of rounds:")
                            .font(.title2)
                            .padding(.top, 20)
                        ZStack {
                            Slider(value: $slider3Value, in: 3...10, step: 1)
                                .tint(.green)
                                .frame(width: 250)
                            Text("\(slider3ValueText) rounds.")
                                .padding(.leading, 320)
                        }
                        
                    }.padding(.bottom, 320)
                    
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
