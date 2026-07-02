//
//  ContentView.swift
//  Skilltester
//
//  Created by Luky on 02.07.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var timeElapsed = 0
    @State private var state: String = "start"
    @State private var randomWait: Float = 0.0
    @State private var isMeasuring: Bool = false
    @State private var result = 0
    @State private var clickTimes: [Float] = []
    @State private var testCount = 0
    let testCountGoal = 5
    
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
                        state = "end"
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
