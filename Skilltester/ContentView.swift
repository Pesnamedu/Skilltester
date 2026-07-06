//
//  ContentView.swift
//  Skilltester
//
//  Created by Luky on 02.07.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var state: String = "menu" // nezapomen zmenit na start
    var dynamicEndBarWidth: CGFloat {
        CGFloat(340 * Double(timeElapsed) * 0.001)
    }
    
    @State private var randomWait: Float = 0.0
    @State private var isMeasuring: Bool = false
    @State private var result = 0
    @State private var clickTimes: [Float] = []//[203, 190, 187, 213, 233, 200, 240]// SMAZAT PRED RUNEM , 205, 149, 214
    @State private var testCount = 0
    //@State private var avaTime: Float = 0
    
    var avaTime: Float {
        guard !clickTimes.isEmpty else {return 0}
        return clickTimes.reduce(Float(0.0), +) / Float(clickTimes.count)
    }
    var dynamicAvaLine: CGFloat {
        CGFloat(148 + CGFloat(avaTime/(clickTimes.max() ?? 150)*520))
    }
    var dynamicAvaLinePadding: CGFloat {
        switch clickTimes.count{
        case 3: return 60
        case 4: return 75
        case 5: return 90
        case 6: return 106
        case 7: return 124
        case 8: return 142
        case 9: return 160
        case 10: return 178
        default: return 0
        }
    }
    func getColorById(index: Int) -> Color {
        if clickTimes[index] == clickTimes.min() {
            return .green
        } else if clickTimes[index] == clickTimes.max() {
            return .red
        } else {
            return .white
        }
    }
    
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
    
    // SPAMMING BELOW
    @State private var spamCount: Int = 0
    @State private var spamWaitTime: Int = 5
    @State private var cps = 0
    @State private var sentFrom: String = ""
    
    @State private var slider4Value: Double = 5
    var slider4ValueText: String {
        String(format: "%.0f", slider4Value)
    }

    var actualCps: String {
        String(format: "%.0f", Float(spamCount) / (0.0001 + Float(timeElapsed))*1000)
    }
    //LOG
    @State private var spamLogDates: [String] = []
    @State private var spamLogValues: [Int] = []
    @State private var spamLogDurations: [Int] = []
    
    @State private var reactLogDates: [String] = []
    @State private var reactLogBestV: [Int] = []
    @State private var reactLogAvaV: [Int] = []
    @State private var reactLogWorstV: [Int] = []
    
    //TIMER BELOW
    @State private var timeElapsed = 0
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    // FUNCTIONS BELOW
    func startTest(name: String) -> String {
        
        return "0"
    }

    
    var body: some View {
        
        //MARK: Menu
        if state == "menu" {
            ZStack {
                ZStack (alignment: .top) {
                    Button(action: {
                        print("clicked button 1 (Reflex)")
                        state = "start R"
                    }) {
                        Text("Reflex")
                            .bold()
                            .font(.title2)
                            .frame(width: 200, height: 200)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        
                    }.buttonStyle(.plain)
                        .padding(.bottom, 340)
                        .padding(.trailing, 440)
                    
                    Button(action: {
                        print("clicked button 2")
                        state = "start S"
                    }) {
                        Text("Spam")
                            .bold()
                            .font(.title2)
                            .frame(width: 200, height: 200)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        
                    }.buttonStyle(.plain)
                        .padding(.bottom, 340)
                    
                    Button(action: {
                        print("clicked button 3")
                    }) {
                        Text("Time")
                            .bold()
                            .font(.title2)
                            .frame(width: 200, height: 200)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        
                    }.buttonStyle(.plain)
                        .padding(.bottom, 340)
                        .padding(.leading, 440)
                    

                    
                }
            }.navigationTitle("Menu")
        }
        //MARK: Spam
        ZStack {
            if state == "start S" {
                ZStack {
                    Button(action: {
                        timeElapsed = 0
                        spamCount = 0
                        state = "spamming"
                        print("Started spamming")
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(spamWaitTime * 1_000_000_000))
                            state = "spammed"
                            timeElapsed = 0
                            cps = spamCount / spamWaitTime
                            spamLogValues.append(cps);
                            spamLogDates.append(Date().formatted(date: .omitted, time: .standard));
                            spamLogDurations.append(spamWaitTime)
                            Task {
                                try? await Task.sleep(nanoseconds: UInt64(2 * 1_000_000_000))
                                state = "results S"
                            }
                        }
                    }) {
                        Text("Start spamming to begin.")
                            .bold()
                            .padding(.horizontal, 50)
                            .padding(.vertical, 50)
                            .frame(minWidth: 700, minHeight: 600)
                            .background(Color.green)
                            .font(.largeTitle)
                        
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [])
                    Text("Spam duration is set to \(spamWaitTime) s.")
                        .padding(.top, 45)
                    
                    Button(action: {
                        state = "settings S"
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
                        .keyboardShortcut(.space, modifiers: [.shift])
                    
                    Button(action: {
                        state = "menu"
                        clickTimes.removeAll()
                        print("Pressed back; sending to \(state)")
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.black)
                            .clipShape(Capsule())
                            .padding(.top, 500)
                            .padding(.trailing, 500)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut("b", modifiers: [])
                    Button(action: {
                        sentFrom = state
                        state = "log S"
                    }) {
                        Text("Log")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.black)
                            .clipShape(Capsule())
                            .padding(.leading, 550)
                            .padding(.top, 500)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut("l", modifiers: [])
                }.navigationTitle("Skilltester - Spamming")
                
            }
            
            if state == "spamming" {
                Button(action: {
                    spamCount += 1
                    print(spamCount / timeElapsed)
                }) {
                    Text("Spam!")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.blue)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [])
                Text("\(actualCps) cps.")
                    .padding(.top, 35)
            }
            
            if state == "spammed" {
                
                Button(action: {
                    print("Clicked \(spamCount) times, over \(spamWaitTime) s. (Rate of \(cps) cps.")
                    state = "results S"
                }) {
                    Text("Done.")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.black)
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [.shift])
                
                Text("Click to see results.")
                    .padding(.top, 35)
                
                RoundedRectangle(cornerRadius: 18)
                    .size(width: dynamicEndBarWidth, height: 18)
                    .padding(.trailing, 350)
                    .padding(.top, 586)
            }
            
            if state == "results S" {
                VStack {
                    Text("You spammed at an avarage rate of")
                    Text("\(cps) cps.")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Text("For total length of \(spamWaitTime) s.")
                }
                ZStack {
                    Button(action: {
                        state = "start S"
                    }) {
                        Text("Start again")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    Button(action: {
                        state = "menu"
                        clickTimes.removeAll()
                    }) {
                        Text("Menu")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .padding(.trailing, 550)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut("l", modifiers: [])
                    
                    Button(action: {
                        sentFrom = state
                        state = "log S"
                    }) {
                        Text("Log")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.green)
                            .clipShape(Capsule())
                            .padding(.leading, 550)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut("m", modifiers: [])
                }.padding(.top, 510)
            }
            
            if state == "settings S" {
                ZStack {
                    Text("Settings")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 530)
                    
                    Button(action: {
                        state = "start S"
                        spamWaitTime = Int(slider4Value)
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }.padding(.top, 500)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    
                    ZStack {
                        Text("Spam duration:")
                            .padding(.bottom, 45)
                            .font(.title2)
                        Slider(value: $slider4Value, in: 1...10, step: 1)
                            .tint(.green)
                            .frame(width: 250)
                        Text("\(slider4ValueText) s.")
                            .padding(.leading, 285)
                    }
                    
                
                }
            }
            if state == "log S" {
                    if 0 < spamLogValues.count && 0 < spamLogDates.count {
                        ScrollView {
                            VStack {
                                ForEach(0..<spamLogValues.count, id: \.self) { index in
                                    HStack {
                                        Text("Attempt: \(index + 1)")
                                            .font(.title2)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("\(spamLogValues[index]) cps. (\(spamLogDurations[index]) s.)")
                                            .font(.title2)
                                        Spacer()
                                        Text("\(spamLogDates[index])")
                                            .font(.title2)
                                            .padding(.trailing, 40)
                                    }
                                }
                            }.frame(maxWidth: .infinity)
                        }.frame(height: 400)
                    } else {
                        Text("No log stored.")
                            .font(.title2)
                        }
                
                Button(action: {
                    print(sentFrom)
                    if sentFrom == "results S" {
                        state = "results S"
                    } else if sentFrom == "start S" {
                        state = "start S"
                    }
                }) {
                    Text("Back")
                        .bold()
                        .font(.largeTitle)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }.padding(.top, 510)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [.shift])
                Button(action: {
                    state = "menu"
                }) {
                    Text("Menu")
                        .bold()
                        .font(.largeTitle)
                        .frame(width: 100, height: 50)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .padding(.trailing, 550)
                }.padding(.top, 510)
                    .buttonStyle(.plain)
                    .keyboardShortcut("m", modifiers: [])
                Button(action: {
                    spamLogDates.removeAll()
                    spamLogValues.removeAll()
                    spamLogDurations.removeAll()
                }) {
                    Text("Clear")
                        .bold()
                        .font(.largeTitle)
                        .frame(width: 100, height: 50)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .padding(.leading, 550)
                }.padding(.top, 510)
                    .buttonStyle(.plain)
                    .keyboardShortcut("m", modifiers: [])
                
            }
        }
        
        //MARK: Reaction
        ZStack {
            if state == "start R" {
                ZStack {
                    Button(action: {
                        randomWait = Float.random(in: minWaitTime...maxWaitTime)
                        print("Waiting randomly \(randomWait)")
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
                        .keyboardShortcut(.space, modifiers: [])
                    
                    Text("You will do \(testCountGoal) rounds.")
                        .padding(.top, 45)
                    
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
                        .keyboardShortcut(.space, modifiers: [.shift])
                    
                    Button(action: {
                        state = "menu"
                        clickTimes.removeAll()
                        print("Pressed back; sending to \(state)")
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.black)
                            .clipShape(Capsule())
                            .padding(.top, 500)
                            .padding(.trailing, 500)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.control])
                    
                    Button(action: {
                        sentFrom = state
                        state = "log R"
                    }) {
                        Text("Log")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.black)
                            .clipShape(Capsule())
                            .padding(.top, 500)
                            .padding(.leading, 550)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut("l", modifiers: [])
                    
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
                    .keyboardShortcut(.space, modifiers: [])
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
                    .keyboardShortcut(.space, modifiers: [])
                if isMeasuring == true {
                    Text("\(timeElapsed) ms.")
                        .padding(.top, 35)
                }
            }
            
            if state == "clicked" {
                Button(action: {
                    randomWait = Float.random(in: minWaitTime...maxWaitTime)
                    print("Waiting randomly \(randomWait)")
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
                        print(avaTime)
                        timeElapsed = 0
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
                            state = "results R"
                            reactLogDates.append(Date().formatted(date: .omitted, time: .standard));
                            reactLogAvaV.append(Int(avaTime))
                            reactLogBestV.append(Int(clickTimes.min() ?? 0))
                            reactLogWorstV.append(Int(clickTimes.max() ?? 0))
                        }
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
                    .keyboardShortcut(.space, modifiers: [])
                
                Text("\(result) ms.")
                    .padding(.top, 35)
            }
            
            if state == "prefired" {
                Button(action: {
                    print("starting game..")
                    state = "wait"
                    print("Waiting..")
                    randomWait = Float.random(in: minWaitTime...maxWaitTime)
                    print("Waiting randomly \(randomWait)")
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
                    .keyboardShortcut(.space, modifiers: [])
                
                Text("Click again to start.")
                    .padding(.top, 35)
            }
            
            if state == "end" {
                Button(action: {
                    state = "results R"
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
                    .keyboardShortcut(.space, modifiers: [])
                
                Text("Click to see results.")
                    .padding(.top, 35)
            }
            
            if state == "results R" {
                ZStack {
                    Text("Results")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 530)
                        .padding(.horizontal, 200)
                    ZStack {
                        Button(action: {
                            state = "start R"
                            clickTimes.removeAll()
                        }) {
                            Text("Start again")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .clipShape(Capsule())
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut(.space, modifiers: [.shift])
                        Button(action: {
                            state = "menu"
                            clickTimes.removeAll()
                        }) {
                            Text("Menu")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 100, height: 50)
                                .background(Color.red)
                                .clipShape(Capsule())
                                .padding(.trailing, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("m", modifiers: [])
                        Button(action: {
                            sentFrom = state
                            state = "log R"
                        }) {
                            Text("Log")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 100, height: 50)
                                .background(Color.green)
                                .clipShape(Capsule())
                                .padding(.leading, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("l", modifiers: [])
                    }//.padding(.vertical, 10)
                        .padding(.top, 510)
                        .navigationTitle("Skilltester - Reaction time, Results")
                }
                
                ZStack(alignment: .topLeading) {
                    VStack {
                        ForEach(0..<clickTimes.count, id: \.self) { index in
                            ZStack {
                                Text("Run: \(index + 1). \(Int(clickTimes[index])) ms.")
                                    .foregroundColor(getColorById(index: index))
                                    .font(.title3)
                                    .padding(.trailing, 550)
                                RoundedRectangle(cornerRadius: 8)
                                    .size(width: CGFloat(clickTimes[index]/(clickTimes.max() ?? 150)*520), height: 15)
                                    .padding(.top, 100/(CGFloat(clickTimes.count)*CGFloat(clickTimes.count)))
                                    .padding(.leading, 130)
                                    .foregroundColor(getColorById(index: index))
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.bottom, 400)
                        .padding(.top, 18 * CGFloat(clickTimes.count))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .size(width: 2, height: 25*CGFloat(clickTimes.count) + 20 + 300/pow(CGFloat(clickTimes.count), 2))
                        .padding(.top, dynamicAvaLinePadding)
                        .padding(.leading, dynamicAvaLine)
                        .foregroundColor(.blue)
                    
                    Text("Avarage")
                        .foregroundColor(.blue)
                        .padding(.top, dynamicAvaLinePadding + (25*CGFloat(clickTimes.count)+20 + 300/pow(CGFloat(clickTimes.count), 2)))
                        .padding(.leading, dynamicAvaLine)
                    
                }
                    
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
                    
                    Text("Settings")
                        .bold()
                        .font(.largeTitle)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 550)
                    
                    Button(action: {
                        state = "start R"
                        testCountGoal = Int(slider3Value)
                        print("Pressed back; sending to \(state)")
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }.padding(.top, 500)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    
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
                            Text("\(slider1ValueText) s.")
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
                            Text("\(slider2ValueText) s.")
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
            if state == "log R" {
                if 0 < reactLogBestV.count && 0 < reactLogWorstV.count && 0 < reactLogAvaV.count && 0 < reactLogDates.count {
                    ScrollView {
                        VStack {
                            ForEach(0..<reactLogAvaV.count, id: \.self) { index in
                                HStack {
                                    Text("Attempt: \(index + 1)")
                                        .font(.title2)
                                        .padding(.leading, 40)
                                    Spacer()
                                    Text("Best \(reactLogBestV[index]) ms. Avarge: \(reactLogAvaV[index]) ms. Worst\(reactLogWorstV[index]) ms.")
                                        .font(.title2)
                                    Spacer()
                                    Text("\(reactLogDates[index])")
                                        .font(.title2)
                                        .padding(.trailing, 40)
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.frame(height: 400)
                } else {
                    Text("No log stored.")
                        .font(.title2)
                    }
            
            Button(action: {
                print(sentFrom)
                if sentFrom == "results R" {
                    state = "results R"
                } else if sentFrom == "start R" {
                    state = "start R"
                }
            }) {
                Text("Back")
                    .bold()
                    .font(.largeTitle)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }.padding(.top, 510)
                .buttonStyle(.plain)
                .keyboardShortcut(.space, modifiers: [.shift])
            Button(action: {
                state = "menu"
            }) {
                Text("Menu")
                    .bold()
                    .font(.largeTitle)
                    .frame(width: 100, height: 50)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .padding(.trailing, 550)
            }.padding(.top, 510)
                .buttonStyle(.plain)
                .keyboardShortcut("m", modifiers: [])
            Button(action: {
                reactLogDates.removeAll();
                reactLogAvaV.removeAll();
                reactLogBestV.removeAll();
                reactLogWorstV.removeAll()
            }) {
                Text("Clear")
                    .bold()
                    .font(.largeTitle)
                    .frame(width: 100, height: 50)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .padding(.leading, 550)
            }.padding(.top, 510)
                .buttonStyle(.plain)
                .keyboardShortcut("m", modifiers: [])
            
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
