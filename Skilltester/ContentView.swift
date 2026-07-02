//
//  ContentView.swift
//  Skilltester
//
//  Created by Luky on 02.07.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var timeElapsed = 0
    @State private var state: String = "start" // nezapomen zmenit na start
    @State private var randomWait: Float = 0.0
    @State private var isMeasuring: Bool = false
    @State private var result = 0
    @State private var clickTimes: [Float] = []//[213, 170, 190, 205, 187] // SMAZAT PRED RUNEM
    @State private var testCount = 0
    @State private var avaTime: Float = 0
    let testCountGoal = 5
    
    let graphWh: CGFloat = 50
    let graphCr: CGFloat = 8

    
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    func startTest(name: String) -> String {
        
        return "0"
    }

    
    var body: some View {
        ZStack {
            if state == "start" {
                Button(action: {
                    randomWait = Float.random(in: 3...4)
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
                        .frame(minWidth: 400, minHeight: 300)
                        .background(Color.green)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
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
                        .frame(minWidth: 400, minHeight: 300)
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
                        .frame(minWidth: 400, minHeight: 300)
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
                    randomWait = Float.random(in: 1.5...3.5)
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
                        .frame(minWidth: 400, minHeight: 300)
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
                    Task {
                        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                        
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
                        .frame(minWidth: 400, minHeight: 300)
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
                        .frame(minWidth: 400, minHeight: 300)
                        .background(Color.black)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                
                Text("Click to see results.")
                    .padding(.top, 35)
            }
            
            if state == "results" {
                
                VStack {
                    Text("Results")
                        .bold()
                        .font(.largeTitle)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 200)
                    HStack(spacing: 10) {
                        Text("First: \(Int(clickTimes[0]))ms")
                        Text("Second: \(Int(clickTimes[1]))ms")
                        Text("Third: \(Int(clickTimes[2]))ms")
                        Text("Fourth: \(Int(clickTimes[3]))ms")
                        Text("Fifth: \(Int(clickTimes[4]))ms")

                    }.padding(.vertical, 10)
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
                    }
                }
                
                
            }
            
        }
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
