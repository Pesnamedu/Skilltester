//
//  ContentView.swift
//  Skilltester
//
//  Created by Luky on 02.07.2026.
//

import SwiftUI

struct ContentView: View {
    //MARK: SETUP variables
    @State private var state: String = "startup" // nezapomen zmenit na startup
    @AppStorage("users") private var users: [String] = []
    @State private var passwordInput: String = ""
    @State private var passwordState: String = "none"
    @State private var nameInput: String = ""
    @State private var passwordRepeat: String = ""
    func getProfilePicture(index: Int) -> String {
        if index < userNames.count + 1 {
            if index < userNames.count {
                return String(String(userNames[index]).prefix(1))
            } else {
                print("index out of range")
                return "%"
            }
            
        } else {
            return "%"
        }
    }
    func getProfileName(index: Int) -> String {
        if index < userNames.count {
            return String(userNames[index])
        } else {
            return "%"
        }
    }
    func getProfileColor(index: Int) -> Color {
        if index < userColor.count {
            switch userColor[index] {
            case "yellow": return Color.yellow.opacity(elementOpacity + 0.1)
            case "orange": return Color.orange.opacity(elementOpacity + 0.1)
            case "red": return Color.red.opacity(elementOpacity + 0.1)
            case "pink": return Color.pink.opacity(elementOpacity + 0.1)
            case "purple": return Color.purple.opacity(elementOpacity + 0.1)
            case "indigo": return Color.indigo.opacity(elementOpacity + 0.1)
            case "blue": return Color.blue.opacity(elementOpacity + 0.1)
            case "teal": return Color.teal.opacity(elementOpacity + 0.1)
            case "cyan": return Color.cyan.opacity(elementOpacity + 0.1)
            case "green": return Color.green.opacity(elementOpacity + 0.1)
            case "white": return Color.white.opacity(elementOpacity + 0.1)
            case "gray": return Color.gray.opacity(elementOpacity + 0.1)
            case "black": return Color.blue.opacity(elementOpacity + 0.1)
            default: return Color.blue.opacity(elementOpacity + 0.1)
            }
        } else {
            return Color.brown
        }
    }
    func getButtonColor(index: Int) -> Color {
        switch index {
        case 0: return Color.yellow.opacity(elementOpacity + 0.1)
        case 1: return Color.orange.opacity(elementOpacity + 0.1)
        case 2: return Color.red.opacity(elementOpacity + 0.1)
        case 3: return Color.pink.opacity(elementOpacity + 0.1)
        case 4: return Color.purple.opacity(elementOpacity + 0.1)
        case 5: return Color.indigo.opacity(elementOpacity + 0.1)
        case 6: return Color.blue.opacity(elementOpacity + 0.1)
        case 8: return Color.teal.opacity(elementOpacity + 0.1)
        case 7: return Color.cyan.opacity(elementOpacity + 0.1)
        case 9: return Color.green.opacity(elementOpacity + 0.1)
        case 10: return Color.white.opacity(elementOpacity + 0.1)
        case 11: return Color.gray.opacity(elementOpacity + 0.1)
        case 12: return Color.blue.opacity(elementOpacity + 0.1)
        default: return Color.blue.opacity(elementOpacity + 0.1)
        }
    }
    func getButtonColorName(index: Int) -> String {
        switch index {
        case 0: return "yellow"
        case 1: return "orange"
        case 2: return "red"
        case 3: return "pink"
        case 4: return "purple"
        case 5: return "indigo"
        case 6: return "blue"
        case 8: return "teal"
        case 7: return "cyan"
        case 9: return "green"
        case 10: return "white"
        case 11: return "gray"
        case 12: return "blue"
        default: return "blue"
        }
    }
    func adminStatus(index: Int) -> String {
        if isAdmin.contains(index) {
            return "Admin"
        } else {
            return "User"
        }
    }
    @State private var usersState: String = "none"
    var howManyButtons: Int {
        Int(userNames.count) + 2
    }
    @State private var userOnLogin: Int = 0
    @State private var userLoggedIn: Int = 0
    @AppStorage("isAdmin") private var isAdmin: [Int] = [0]
    @State private var adminEditState: String = "none"
    @State private var accountUnderEdit: Int = 101
    @State private var isPasswordVisible: Bool = false
    @State private var saveUserError: String = "none"
    @State private var saveUserMessage: String = "none"
    
    @AppStorage("keepLoggedIn") private var keepLoggedIn: [Int] = []
    @State private var keepLoggedInSwitch: Bool = false
    @AppStorage("lastLoggedIn") private var lastLoggedIn: Int = 101
    
    @AppStorage("userNames") private var userNames: [String] = []
    @AppStorage("userPass") private var userPass: [String] = []
    @AppStorage("userColor") private var userColor: [String] = []
    @State private var isOnFresh: Bool = true
    
    @State private var resetOnLaunch: Bool = false
    
    //MARK: DESIGN variables
    @State private var darkMode: Bool = true
    @AppStorage("userPreferencesDarkMode") private var userPreferencesDarkMode: [Bool] = []
    var dynamicEndBarWidth: CGFloat {
        CGFloat(700 * Double(timeElapsed) * 0.00121)
    }
    @State private var bgOpacity: Double = 0.6
    @State private var elementOpacity: Double = 0.45
    @AppStorage("UserPreferencesBgOpacity") private var UserPreferencesBgOpacity: [Double] = []
    @AppStorage("UserPreferencesElementOpacity") private var UserPreferencesElementOpacity: [Double] = []
    @State private var textColor: Color = .white
    
    let scrollSpace = "myScrollSpace"
    var bgLowOpacity: Double {
        Double(max(0, (2.5 * bgOpacity - 1.5)))
    }
    
    //MARK: REACTION variables
    @State private var randomWait: Double = 0.0
    @State private var isMeasuring: Bool = false
    @State private var result = 0
    @State private var clickTimes: [Float] = []
    @AppStorage("testCount") private var testCount: Int = 0
    @State private var startTimer: Date = Date()
    
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
    func getExistenceById(index: Int) -> Double{
        if index % 2 == 0 {
            return 0
        } else {
            return 0.1
        }
    }
    
    @AppStorage("minWaitTime") private var minWaitTime: Double = 1.5
    @AppStorage("maxWaitTime") private var maxWaitTime: Double = 3.0
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
    
    //MARK: SPAMMING variables
    @State private var spamCount: Int = 0
    @AppStorage("spamWaitTime") private var spamWaitTime: Int = 5
    @State private var cps = 0
    @State private var sentFrom: String = ""
    
    @State private var slider4Value: Double = 5
    var slider4ValueText: String {
        String(format: "%.0f", slider4Value)
    }
    
    var actualCps: String {
        String(format: "%.0f", Float(spamCount) / (0.0001 + Float(timeElapsed))*1000)
    }
    //MARK: TIME variables
    @State private var timeStopped: Int = 0
    @State private var isViewBlocked: Bool = false
    @State private var timeStopGoal: Int = 0
    @State private var randomTime: Int = 0
    @State private var slider5Value: Double = 1
    @State private var minTime: Int = 6000
    @State private var maxTime: Int = 18000
    
    var randomTimeText: String {
        String(format: "%.1f", round(Float(randomTime) / 100)/10)
    }
    var timeStoppedText: String {
        String(format: "%.1f", round(Float(timeStopped) / 100)/10)
    }
    var timeDifference: Int {
        Int(abs(randomTime - timeStopped))
    }
    var timeDifferenceText: String {
        String(format: "%.2f", abs((Float(timeStoppedText) ?? 1) - (Float(randomTimeText) ?? 1)))
        //round(Float(timeDifference) / 100)/10)
    }
    var slider5Text: String {
        if slider5Value < 1 {
            return "Short"
        } else if slider5Value > 2 {
            return "Long"
        } else if slider5Value >= 1 && slider5Value <= 2{
            return "Medium"
        } else {
            return "error"
        }
    }
    //MARK: AIM variables
    @State private var targetCount: Int = 10
    @State private var targetRandomX: Int = 0
    @State private var targetRandomY: Int = 0
    
    
    //MARK: LOG variables
    @AppStorage("spamLogDates") private var spamLogDates: [String] = []
    @AppStorage("spamLogValues") private var spamLogValues: [String] = []
    @AppStorage("spamLogDurations") private var spamLogDurations: [String] = []
    
    @AppStorage("reactLogDates") private var reactLogDates: [String] = []
    @AppStorage("reactLogBestV") private var reactLogBestV: [String] = []
    @AppStorage("reactLogAvaV") private var reactLogAvaV: [String] = []
    @AppStorage("reactLogWorstV") private var reactLogWorstV: [String] = []
    
    @AppStorage("timeLogDates") private var timeLogDates: [String] = []
    @AppStorage("timeLogValues") private var timeLogValues: [String] = []
    @AppStorage("timeLogDurations") private var timeLogDurations: [String] = []
    
    @AppStorage("aimLogDates") private var aimLogDates: [String] = []
    @AppStorage("aimLogBestV") private var aimLogBestV: [String] = []
    @AppStorage("aimLogWorstV") private var aimLogWorstV: [String] = []
    @AppStorage("aimLogAvaV") private var aimLogAvaV: [String] = []
    
    @State private var realIdx: Int = 0
    
    //TIMER BELOW
    @State private var timeElapsed = 0
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    var timeElapsedText: String {
        String(format: "%.2f", Double(timeElapsed) / 1000)
    }
    
    // FUNCTIONS BELOW
    func startTest(name: String) -> String {
        
        return "0"
    }
    
    func userInLog(pos: Int) -> Int {
        return (pos + 1) * 2 - 1
    }
    func valueInLog(pos: Int) -> Int {
        return (pos + 1) * 2 - 2
    }
    func deleteUser(user: Int) {
        print("Before delete (deleting user number \(user))")
        print(userNames)
        print(userPass)
        print(userColor)
        print(keepLoggedIn)
        print(UserPreferencesBgOpacity)
        print(UserPreferencesElementOpacity)
        userNames.remove(at: user)
        userPass.remove(at: user)
        userColor.remove(at: user)
        if keepLoggedIn.contains(user) {
            keepLoggedIn.remove(at: keepLoggedIn.firstIndex(of: user)!)
        }
        UserPreferencesBgOpacity.remove(at: user)
        UserPreferencesElementOpacity.remove(at: user)
        print("After delete (deleting user number \(user))")
        print(userNames)
        print(userPass)
        print(userColor)
        print(keepLoggedIn)
        print(UserPreferencesBgOpacity)
        print(UserPreferencesElementOpacity)
    }
    @State private var idx: Int = 0
    func deleteUserLog(log: String, user: Int) {
        idx = 0
        if log == "spam" {
            while idx != spamLogDates.count/2 {
                if spamLogValues[userInLog(pos: idx)] != String(user) {
                    idx += 1
                } else {
                    spamLogValues.remove(at: valueInLog(pos: idx)) //delete value
                    spamLogValues.remove(at: valueInLog(pos: idx)) //delete user
                    spamLogDates.remove(at: valueInLog(pos: idx))
                    spamLogDates.remove(at: valueInLog(pos: idx))
                    spamLogDurations.remove(at: valueInLog(pos: idx))
                    spamLogDurations.remove(at: valueInLog(pos: idx))
                }
            }
        } else if log == "react" {
            while idx != reactLogDates.count/2 {
                if reactLogDates[userInLog(pos: idx)] != String(user) {
                    idx += 1
                } else {
                    reactLogBestV.remove(at: valueInLog(pos: idx))
                    reactLogBestV.remove(at: valueInLog(pos: idx))
                    reactLogWorstV.remove(at: valueInLog(pos: idx))
                    reactLogWorstV.remove(at: valueInLog(pos: idx))
                    reactLogAvaV.remove(at: valueInLog(pos: idx))
                    reactLogAvaV.remove(at: valueInLog(pos: idx))
                    reactLogDates.remove(at: valueInLog(pos: idx))
                    reactLogDates.remove(at: valueInLog(pos: idx))
                }
            }
        } else if log == "time" {
            while idx != timeLogDates.count/2 {
                if timeLogDates[userInLog(pos: idx)] != String(user) {
                    idx += 1
                } else {
                    timeLogDates.remove(at: valueInLog(pos: idx))
                    timeLogDates.remove(at: valueInLog(pos: idx))
                    timeLogValues.remove(at: valueInLog(pos: idx))
                    timeLogValues.remove(at: valueInLog(pos: idx))
                }
            }
        } else if log == "aim" {
            while idx != aimLogDates.count/2 {
                if aimLogDates[userInLog(pos: idx)] != String(user) {
                    idx += 1
                } else {
                    aimLogBestV.remove(at: valueInLog(pos: idx))
                    aimLogBestV.remove(at: valueInLog(pos: idx))
                    aimLogWorstV.remove(at: valueInLog(pos: idx))
                    aimLogWorstV.remove(at: valueInLog(pos: idx))
                    aimLogAvaV.remove(at: valueInLog(pos: idx))
                    aimLogAvaV.remove(at: valueInLog(pos: idx))
                    aimLogDates.remove(at: valueInLog(pos: idx))
                    aimLogDates.remove(at: valueInLog(pos: idx))
                }
            }
        }
    }
    @State private var logLen: Int = 1
    func getUserLogLength(log: String, user: Int) -> Int {
        idx = 0
        if log == "spam" {
            while idx != spamLogDates.count/2 {
                if spamLogDates[userInLog(pos: idx)] == String(user) {
                    logLen += 1
                }
                idx += 1
            }
        } else if log == "react" {
            while idx != reactLogDates.count/2 {
                if reactLogDates[userInLog(pos: idx)] == String(user) {
                    logLen += 1
                }
                idx += 1
            }
        } else if log == "time" {
            while idx != reactLogDates.count/2 {
                if reactLogDates[userInLog(pos: idx)] == String(user) {
                    logLen += 1
                }
                idx += 1
            }
        }
        return logLen
    }
    @State private var currentLogDates: [String] = []
    @State private var currentLogVal1: [String] = []
    @State private var currentLogVal2: [String] = []
    @State private var currentLogVal3: [String] = []
    
    func makeCurrentUserLog(log: String, user: Int) {
        idx = 0
        currentLogDates.removeAll()
        currentLogVal1.removeAll()
        currentLogVal2.removeAll()
        currentLogVal3.removeAll()
        if log == "spam" {
            while idx != spamLogDates.count/2 {
                if spamLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(spamLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(spamLogValues[valueInLog(pos: idx)])
                    currentLogVal2.append(spamLogDurations[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "react" {
            while idx != reactLogDates.count/2 {
                if reactLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(reactLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(reactLogBestV[valueInLog(pos: idx)])
                    currentLogVal2.append(reactLogWorstV[valueInLog(pos: idx)])
                    currentLogVal3.append(reactLogAvaV[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "time" {
            while idx != timeLogDates.count/2 {
                if timeLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(timeLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(timeLogValues[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "aim" {
            while idx != aimLogDates.count/2 {
                if aimLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(aimLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(aimLogBestV[valueInLog(pos: idx)])
                    currentLogVal2.append(aimLogWorstV[valueInLog(pos: idx)])
                    currentLogVal3.append(aimLogAvaV[valueInLog(pos: idx)])
                }
                idx += 1
            }
        }
    }
    func clearAllLogs() {
        spamLogDates.removeAll()
        spamLogValues.removeAll()
        spamLogDurations.removeAll()
        
        reactLogDates.removeAll()
        reactLogBestV.removeAll()
        reactLogWorstV.removeAll()
        reactLogAvaV.removeAll()
        
        timeLogDates.removeAll()
        timeLogValues.removeAll()
        
        aimLogDates.removeAll()
        aimLogBestV.removeAll()
        aimLogWorstV.removeAll()
        aimLogAvaV.removeAll()
    }
    
    @State private var bestSpamValues: [String] = []
    @State private var bestReactValues: [String] = []
    @State private var bestTimeValues: [String] = []
    @State private var bestAimValues: [String] = []
    
    @State private var spamLeaderboard: [String] = []
    @State private var reactLeaderboard: [String] = []
    @State private var timeLeaderboard: [String] = []
    @State private var aimLeaderboard: [String] = []
    
    func makeLogLeaderboard(mode: String) {
        if mode == "spam" {
            bestSpamValues.removeAll()
            spamLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "spam", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestSpamValues.append(currentLogVal1.max()!)
                } else { bestSpamValues.append("0%\(user)") }
            }
            spamLeaderboard = bestSpamValues.sorted(by: >)
            print("Best values: \(bestSpamValues)")
            print("Leaderboard: \(spamLeaderboard)")
            
        } else if mode == "react" {
            bestReactValues.removeAll()
            reactLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "react", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestReactValues.append(currentLogVal1.min()!)
                } else { bestReactValues.append("None\(user)") }
            }
            reactLeaderboard = bestReactValues.sorted()
            print("Best values: \(bestReactValues)")
            print("Leaderboard: \(reactLeaderboard)")
        } else if mode == "time" {
            bestTimeValues.removeAll()
            timeLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "time", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestTimeValues.append(currentLogVal1.min()!)
                } else { bestTimeValues.append("None\(user)") }
            }
            timeLeaderboard = bestTimeValues.sorted()
            print("Best values: \(bestTimeValues)")
            print("Leaderboard: \(timeLeaderboard)")
        } else if mode == "aim" {
            bestAimValues.removeAll()
            aimLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "react", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestAimValues.append(currentLogVal1.min()!)
                } else { bestAimValues.append("None\(user)") }
            }
            aimLeaderboard = bestAimValues.sorted()
            print("Best values: \(bestAimValues)")
            print("Leaderboard: \(aimLeaderboard)")
        } else {

        }
    }
    
    //MARK: Menu
    
    let menuButtonSpacing: CGFloat = 18
    var menuView: some View {
        ZStack {
            SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
            if state == "menu" {
                if getProfileColor(index: userLoggedIn) == Color.white.opacity(elementOpacity + 0.1) {
                    Text("Menu")
                        .bold()
                        .foregroundColor(.black.opacity(0.8))
                        .font(.system(size: 61, weight: .bold, design: .default))
                        .padding(.bottom, 581)
                } else {
                    Text("Menu")
                        .bold()
                        .foregroundColor(getProfileColor(index: userLoggedIn))
                        .font(.system(size: 61, weight: .bold, design: .default))
                        .padding(.bottom, 581)
                }
                ScrollView {
                    VStack (spacing: menuButtonSpacing) {
                        HStack (alignment: .top, spacing: menuButtonSpacing) {
                            Button(action: {
                                print("clicked button 1 (Reflex)")
                                state = "start R"
                            }) {
                                Text("Reflex")
                                    .bold()
                                    .font(.title2)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(textColor.opacity(0.8))
                                //.background(.ultraThinMaterial)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                
                            }.buttonStyle(.plain)
                            
                            Button(action: {
                                print("clicked button 2")
                                state = "start S"
                            }) {
                                Text("Spam")
                                    .bold()
                                    .font(.title2)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(textColor.opacity(0.8))
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                            }.buttonStyle(.plain)
                            
                            Button(action: {
                                print("clicked button 3")
                                state = "start T"
                            }) {
                                Text("Time")
                                    .bold()
                                    .font(.title2)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(textColor.opacity(0.8))
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                
                            }.buttonStyle(.plain)
                        }.padding(.top, 20)
                        
                        HStack (alignment: .top, spacing: menuButtonSpacing) {
                            Button(action: {
                                print("clicked button 4")
                                state = "start A"
                            }) {
                                Text("Aim")
                                    .bold()
                                    .font(.title2)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(textColor.opacity(0.8))
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                
                            }.buttonStyle(.plain)
                            
                            Button(action: {
                                print("clicked button 5")
                                state = "start M"
                            }) {
                                Text("Memory")
                                    .bold()
                                    .font(.title2)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(textColor.opacity(0.8))
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                
                            }.buttonStyle(.plain)
                            
                            Button(action: {
                                print("clicked button 6")
                                //state = "start A"
                            }) {
                                Text("Unused button")
                                    .bold()
                                    .font(.title2)
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(textColor.opacity(0.8))
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                
                            }.buttonStyle(.plain)
                        }
                        
                        
                    }.navigationTitle("Menu")
                        .onAppear() {
                            print("In Menu.")
                            //clearAllLogs()
                            print("SPAM")
                            makeLogLeaderboard(mode: "spam")
                            print("REACTION")
                            makeLogLeaderboard(mode: "react")
                            print("TIME")
                            makeLogLeaderboard(mode: "time")
                            print("AIM")
                            makeLogLeaderboard(mode: "aim")
                            
                        }
                    
                }.frame(width: 600, height: 600)
                    .padding(.top, 81)
                
                Button(action: {
                    state = "tutor"
                }) {
                    Text("?")
                        .font(.largeTitle)
                        .foregroundColor(textColor.opacity(0.8))
                        .frame(width: 30, height: 30)
                        .background(getProfileColor(index: userLoggedIn))
                        .clipShape(Circle())
                        .padding(.top, 550)
                        .padding(.leading, 650)
                }.buttonStyle(.plain)
                Button(action: {
                    state = "loggedin"
                    usersState = "loggedin"
                }) {
                    Text(getProfilePicture(index: userLoggedIn))
                        .font(.system(size: 51, weight: .thin, design: .default))
                        .foregroundColor(textColor.opacity(0.8))
                        .frame(width: 70, height: 70)
                        .background(getProfileColor(index: userLoggedIn))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                }.buttonStyle(.plain)
                    .padding(.top, 490)
                    .padding(.trailing, 590)
            }
        }
    }
    
    //MARK: Spam - start
    
    
    
    var spamView: some View {
        ZStack {
            if state == "start S" {
                ZStack {
                    Button(action: {
                        timeElapsed = 0
                        spamCount = 0
                        state = "spamming S"
                        print("Started spamming")
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(spamWaitTime * 1_000_000_000))
                            state = "spammed S"
                            timeElapsed = 0
                            cps = spamCount / spamWaitTime
                            print("saving spam data to log")
                            spamLogValues.append(String(cps))
                            spamLogValues.append(String(userLoggedIn))
                            spamLogDates.append(Date().formatted(date: .omitted, time: .standard))
                            spamLogDates.append(String(userLoggedIn))
                            spamLogDurations.append(String(spamWaitTime))
                            spamLogDurations.append(String(userLoggedIn))
                            
                            Task {
                                try? await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
                                state = "results S"
                            }
                        }
                    }) {
                        Text("Start spamming to begin.")
                            .bold()
                            .padding(.horizontal, 50)
                            .padding(.vertical, 50)
                            .frame(minWidth: 700, minHeight: 600)
                            .background(Color.green.opacity(bgOpacity))
                            .font(.largeTitle)
                        
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [])
                    Text("Spam duration is set to \(spamWaitTime) s.")
                        .padding(.top, 45)
                    
                    ZStack {
                        Button(action: {
                            state = "settings S"
                        }) {
                            Text("Settings")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 200, height: 50)
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
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
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.trailing, 550)
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
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.leading, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("l", modifiers: [])
                    }.frame(width: 670, height: 70)
                        .background(Color.black.opacity(0.12))
                        .clipShape(Capsule())
                        .padding(.top, 500)
                }.navigationTitle("Skilltester - Spamming")
                
            }
            
            //MARK: Spam - spamming
            if state == "spamming S" {
                Button(action: {
                    spamCount += 1
                    //print(spamCount / (timeElapsed + 0.00001))
                }) {
                    Text("Spam!")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.blue.opacity(bgOpacity))
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [])
                Text("\(actualCps) cps.")
                    .padding(.top, 35)
            }
            
            //MARK: Spam - end
            if state == "spammed S" {
                
                Button(action: {
                    print("Clicked \(spamCount) times, over \(spamWaitTime) s. (Rate of \(cps) cps.")
                    state = "results S"
                }) {
                    Text("Done.")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.black.opacity(0.1))
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [.shift])
                
                Text("Test is over.")
                    .padding(.top, 35)
                
                RoundedRectangle(cornerRadius: 18)
                    .size(width: dynamicEndBarWidth, height: 18)
                    .padding(.trailing, 350)
                    .padding(.top, 600)
                    .foregroundColor(Color.black.opacity(elementOpacity))
            }
            
            //MARK: Spam - results
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
                            .background(Color.blue.opacity(elementOpacity))
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
                            .background(Color.red.opacity(elementOpacity))
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
                            .background(Color.green.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .padding(.leading, 550)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut("m", modifiers: [])
                }.frame(width: 670, height: 70)
                    .background(Color.black.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.top, 500)
            }
            
            //MARK: Spam - settings
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
                            .background(Color.green.opacity(elementOpacity))
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
                            .onAppear() {
                                slider4Value = Double(spamWaitTime)
                            }
                        Text("\(slider4ValueText) s.")
                            .padding(.leading, 285)
                    }
                    
                    
                }
            }
            
            //MARK: Spam - log
            if state == "log S" {
                if 0 < spamLogValues.count && 0 < spamLogDates.count {
                    ScrollView {
                        VStack {
                            ForEach(0..<currentLogDates.count, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundColor(Color.black.opacity(getExistenceById(index: index)))
                                        .padding(.horizontal, 35)
                                    
                                    HStack {
                                        Text("Attempt: \(index + 1)")
                                            .font(.title2)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("\(currentLogVal1[index]) cps. (\(currentLogVal2[index])) s.)")
                                            .font(.title2)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .padding(.trailing, 40)
                                    }.onAppear() {
                                        
                                    }
                                
                                }.onAppear() {
                                    print("Im line number \(index), returned: \(userInLog(pos: index)) ")
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.frame(height: 400)
                        .onAppear() {
                            makeCurrentUserLog(log: "spam", user: userLoggedIn)
                        }
                } else {
                    Text("No log stored.")
                        .font(.title2)
                }
                
                ZStack {
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
                            .background(Color.blue.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    Button(action: {
                        state = "menu"
                    }) {
                        Text("Menu")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                            .padding(.trailing, 550)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut("m", modifiers: [])
                    Button(action: {
                        deleteUserLog(log: "spam", user: userLoggedIn)
                    }) {
                        Text("Clear")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                            .padding(.leading, 550)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut("x", modifiers: [])
                }.frame(width: 670, height: 70)
                    .background(Color.black.opacity(0.2))
                    .clipShape(Capsule())
                    .padding(.top, 500)
            }
        }
    }
    
    //MARK: Reaction - start
    
    
    var reactView: some View {
        ZStack {
            if state == "start R" {
                ZStack {
                    Button(action: {
                        randomWait = Double.random(in: minWaitTime...maxWaitTime)
                        print("Waiting randomly \(randomWait)")
                        print("starting game..")
                        state = "wait R"
                        print("Waiting..")
                        testCount += 1
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(randomWait * 1_000_000_000))
                            
                            if state == "wait R" {
                                print("Done waiting!")
                                isMeasuring = true
                                state = "click R"
                                timeElapsed = 0
                                startTimer = Date()
                                Task {
                                    try? await Task.sleep(nanoseconds: UInt64(3 * 1_000_000_000))
                                    if state == "click R" {
                                        state = "clicked R"
                                        result = 3000
                                        //clickTimes.append(Float(result))
                                        //testCount += 1
                                        print("user didnt to click")
                                    }
                                }
                            }
                        }
                        
                    }) {
                        Text("Start")
                            .bold()
                            .padding(.horizontal, 50)
                            .padding(.vertical, 50)
                            .frame(minWidth: 700, minHeight: 600)
                            .background(Color.green.opacity(bgOpacity))
                            .font(.largeTitle)
                        
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [])
                    
                    Text("You will do \(testCountGoal) rounds.")
                        .padding(.top, 45)
                    
                    ZStack {
                        Button(action: {
                            state = "settings R"
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
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                                
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
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.trailing, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut(.space, modifiers: [.control])
                        
                        Button(action: {
                            makeCurrentUserLog(log: "react", user: userLoggedIn)
                            sentFrom = state
                            state = "log R"
                        }) {
                            Text("Log")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 100, height: 50)
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.leading, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("l", modifiers: [])
                    }.frame(width: 670, height: 70)
                        .background(Color.black.opacity(0.12))
                        .clipShape(Capsule())
                        .padding(.top, 500)
                    
                }.navigationTitle("Skilltester - Reaction time")
            }
            
            //MARK: Reaction - waiting
            if state == "wait R" {
                Button(action: {
                    state = "prefired R"
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
            
            //MARK: Reaction - click
            if state == "click R" {
                Button(action: {
                    result = Int(Date().timeIntervalSince(startTimer) * 1000)
                    isMeasuring = false
                    clickTimes.append(Float(result))
                    testCount += 1
                    
                    print("Clicked at \(result) ms!")
                    state = "clicked R"
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
            
            //MARK: Reaction - click end
            if state == "clicked R" {
                Button(action: {
                    randomWait = Double.random(in: minWaitTime...maxWaitTime)
                    print("Waiting randomly \(randomWait)")
                    if testCount <= testCountGoal {
                        print("starting new game.. (\(testCount)/5)")
                        state = "wait R"
                        print("Waiting..")
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(randomWait * 1_000_000_000))
                            
                            if state == "wait R" {
                                print("Done waiting!")
                                isMeasuring = true
                                state = "click R"
                                timeElapsed = 0
                                startTimer = Date()
                                Task {
                                    try? await Task.sleep(nanoseconds: UInt64(3 * 1_000_000_000))
                                    if state == "click R" {
                                        state = "clicked R"
                                        result = 3000
                                        //clickTimes.append(Float(result))
                                        //testCount += 1
                                        print("user didnt to click")
                                    }
                                }
                            }
                        }
                    } else {
                        print("End")
                        print(clickTimes)
                        state = "end R"
                        print(avaTime)
                        timeElapsed = 0
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
                            state = "results R"
                            testCount = 0
                            reactLogDates.append(Date().formatted(date: .omitted, time: .standard));
                            reactLogAvaV.append(String(round(avaTime)))
                            reactLogBestV.append(String(clickTimes.min() ?? 0))
                            reactLogWorstV.append(String(clickTimes.max() ?? 0))
                            
                            reactLogAvaV.append(String(userLoggedIn));
                            reactLogDates.append(String(userLoggedIn));
                            reactLogBestV.append(String(userLoggedIn));
                            reactLogWorstV.append(String(userLoggedIn))
                        }
                    }
                    
                }) {
                    Text("Click to continue")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.blue.opacity(elementOpacity))
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [])
                
                if result != 3000 {
                    Text("\(result) ms.")
                        .padding(.top, 35)
                } else {
                    Text("You need to click to get result.")
                        .padding(.top, 35)
                }
            }
            
            //MARK: Reaction prefire
            if state == "prefired R" {
                Button(action: {
                    print("starting game..")
                    state = "wait R"
                    print("Waiting..")
                    randomWait = Double.random(in: minWaitTime...maxWaitTime)
                    print("Waiting randomly \(randomWait)")
                    Task {
                        try? await Task.sleep(nanoseconds: UInt64(randomWait) * 1_000_000_000)
                        
                        if state == "wait R" {
                            print("Done waiting!")
                            isMeasuring = true
                            state = "click R"
                            timeElapsed = 0
                            startTimer = Date()
                        }
                    }
                }) {
                    Text("Too soon!")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.red.opacity(elementOpacity))
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [])
                
                Text("Click again to start.")
                    .padding(.top, 35)
            }
            
            //MARK: Reaction end
            if state == "end R" {
                Button(action: {
                    state = "results R"
                    testCount = 0
                }) {
                    Text("End")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.black.opacity(0.1))
                        .font(.largeTitle)
                    
                }.foregroundColor(.white)
                    .buttonStyle(.plain)
                
                Text("Test ended.")
                    .padding(.top, 35)
                
                RoundedRectangle(cornerRadius: 18)
                    .size(width: dynamicEndBarWidth, height: 18)
                    .padding(.trailing, 350)
                    .padding(.top, 586)
                    .foregroundColor(Color.black.opacity(elementOpacity))
            }
            
            //MARK: Reaction results
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
                                .background(Color.blue.opacity(elementOpacity))
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
                                .background(Color.red.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.trailing, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("m", modifiers: [])
                        Button(action: {
                            makeCurrentUserLog(log: "react", user: userLoggedIn)
                            sentFrom = state
                            state = "log R"
                        }) {
                            Text("Log")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 100, height: 50)
                                .background(Color.green.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.leading, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("l", modifiers: [])
                    }.frame(width: 670, height: 70)
                        .background(Color.black.opacity(0.12))
                        .clipShape(Capsule())
                        .padding(.top, 500)
                    .navigationTitle("Skilltester - Reaction time, Results")
                    
                }
                
                ZStack(alignment: .topLeading) {
                    VStack {
                        ForEach(0..<clickTimes.count, id: \.self) { index in
                            ZStack {
                                if clickTimes[index] <= 3000 {
                                    Text("Run: \(index + 1). \(Int(clickTimes[index])) ms.")
                                        .foregroundColor(getColorById(index: index))
                                        .font(.title3)
                                        .padding(.trailing, 550)
                                    RoundedRectangle(cornerRadius: 8)
                                        .size(width: CGFloat(clickTimes[index]/(clickTimes.max() ?? 150)*520), height: 15)
                                        .padding(.top, 100/(CGFloat(clickTimes.count)*CGFloat(clickTimes.count)))
                                        .padding(.leading, 130)
                                        .foregroundColor(getColorById(index: index))
                                } else {
                                    Text("error")
                                }
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
            
            //MARK: Reaction settings
            if state == "settings R" {
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
                            .background(Color.green.opacity(elementOpacity))
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
                                    saveMessage = "Press Save to save values."
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
                                    saveMessage = "Press Save to save values."
                                }
                            Text("\(slider2ValueText) s.")
                                .padding(.leading, 305)
                        }
                        HStack {
                            Button(action: {
                                print("Save button clicked.")
                                if slider2Value >= slider1Value + 1 {
                                    minWaitTime = Double(slider1Value)
                                    maxWaitTime = Double(slider2Value)
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
                                .onAppear() {
                                    slider3Value = Double(testCount)
                                }
                            Text("\(slider3ValueText) rounds.")
                                .padding(.leading, 320)
                        }
                        
                    }.padding(.bottom, 320)
                    
                }.padding(.vertical, 10)
                    .navigationTitle("Skilltester - Reaction time, Settings")
                
            }
            
            //MARK: Reaction log
            if state == "log R" {
                if 0 < reactLogDates.count {
                    ScrollView {
                        VStack {
                            ForEach(0..<currentLogDates.count, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundColor(Color.black.opacity(getExistenceById(index: index)))
                                        .padding(.horizontal, 35)
                                    HStack {
                                        Text("Attempt: \(index + 1)")
                                            .font(.title2)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("Best: \(currentLogVal1[index]) ms. Avarge: \(currentLogVal3[index]) ms. Worst: \(currentLogVal2[index]) ms.")
                                            .font(.title2)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .padding(.trailing, 40)
                                    
                                    }
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.frame(height: 400)
                } else {
                    Text("No log stored.")
                        .font(.title2)
                }
                
                ZStack {
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
                            .background(Color.blue.opacity(elementOpacity))
                            .clipShape(Capsule())
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    Button(action: {
                        state = "menu"
                    }) {
                        Text("Menu")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .padding(.trailing, 550)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut("m", modifiers: [])
                    Button(action: {
                        deleteUserLog(log: "react", user: userLoggedIn)
                    }) {
                        Text("Clear")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .padding(.leading, 550)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut("x", modifiers: [])
                }.frame(width: 670, height: 70)
                    .background(Color.black.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.top, 500)
            }
        }
    }
    
    //MARK: Time - start
    
    
    var timeView: some View {
        ZStack {
            if state == "start T" {
                ZStack {
                    Button(action: {
                        randomTime = Int.random(in: minTime...maxTime)
                        // timeStopGoal = randomTimeText //smazat az udelam nastaveni
                        state = "make time T"
                        isViewBlocked = false
                        timeElapsed = 0
                        print("Random time is \(randomTime) ms")
                    }) {
                        Text("Start")
                            .bold()
                            .padding(.horizontal, 50)
                            .padding(.vertical, 50)
                            .frame(minWidth: 700, minHeight: 600)
                            .background(Color.green.opacity(bgOpacity))
                            .font(.largeTitle)
                    }.buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [])
                    Text("Timer duration is set to \(slider5Text).")
                        .padding(.top, 45)
                    
                    ZStack {
                        Button(action: {
                            state = "settings T"
                        }) {
                            Text("Settings")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 200, height: 50)
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
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
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.trailing, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("b", modifiers: [])
                        
                        Button(action: {
                            sentFrom = state
                            state = "log T"
                        }) {
                            Text("Log")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 100, height: 50)
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.leading, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("l", modifiers: [])
                    }.frame(width: 670, height: 70)
                        .background(Color.black.opacity(0.12))
                        .clipShape(Capsule())
                        .padding(.top, 500)
                }
            }
            
            //MARK: Time - target time
            if state == "make time T" {
                ZStack {
                    Button(action: {
                        state = "count T"
                        timeElapsed = 0
                        Task {
                            try? await Task.sleep(nanoseconds: UInt64((Float(minTime) / 2) * 1_000_000))
                            isViewBlocked = true
                        }
                    }) {
                        Text("\(randomTimeText) s.")
                            .padding(.horizontal, 50)
                            .padding(.vertical, 50)
                            .frame(minWidth: 700, minHeight: 600)
                            .background(Color.blue.opacity(bgOpacity))
                            .font(.system(size: 80, weight: .bold, design: .default))
                    }.buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [])
                    Text("Stop timer at")
                        .padding(.bottom, 75)
                }
            }
            
            //MARK: Time - timer screen
            if state == "count T" {
                Button(action: {
                    state = "stopped T"
                    timeStopped = timeElapsed
                    timeLogDates.append(Date().formatted(date: .omitted, time: .standard));
                    timeLogValues.append(timeDifferenceText)
                    
                    timeLogDates.append(String(userLoggedIn))
                    timeLogValues.append(String(userLoggedIn))
                }) {
                    Text("")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.red.opacity(bgOpacity))
                        .font(.largeTitle)
                }.buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [])
                if isViewBlocked == false {
                    Text("\(timeElapsedText) s.")
                        .font(.system(size: 80, weight: .bold, design: .default))
                        .foregroundColor(.white)
                }
            }
            
            if state == "stopped T" {
                Button(action: {
                    state = "results T"
                }) {
                    Text("\(timeStoppedText) s.")
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.blue.opacity(bgOpacity))
                        .font(.system(size: 80, weight: .bold, design: .default))
                }.buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [])
                
                Text("You stopped timer at")
                    .padding(.bottom, 75)
            }
            
            //MARK: Time - results
            if state == "results T" {
                ZStack {
                    Text("Results")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 530)
                        .padding(.horizontal, 200)
                    ZStack {
                        Button(action: {
                            state = "start T"
                            clickTimes.removeAll()
                        }) {
                            Text("Start again")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 200, height: 50)
                                .background(Color.blue.opacity(elementOpacity))
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
                                .background(Color.red.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.trailing, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("m", modifiers: [])
                        Button(action: {
                            sentFrom = state
                            state = "log T"
                        }) {
                            Text("Log")
                                .bold()
                                .font(.largeTitle)
                                .frame(width: 100, height: 50)
                                .background(Color.green.opacity(elementOpacity))
                                .clipShape(Capsule())
                                .padding(.leading, 550)
                        }.foregroundColor(.white)
                            .buttonStyle(.plain)
                            .keyboardShortcut("l", modifiers: [])
                    }.frame(width: 670, height: 70)
                        .background(Color.black.opacity(0.12))
                        .clipShape(Capsule())
                        .padding(.top, 500)
                    Text("You stopped at")
                        .padding(.bottom, 45)
                    Text("\(timeStoppedText) / \(randomTimeText) s.")
                        .bold()
                        .font(.largeTitle)
                    Text("Difference: \(timeDifferenceText) s.")
                        .padding(.top, 45)
                    
                }
            }
            
            //MARK: Time - settings
            if state == "settings T" {
                ZStack {
                    Text("Settings")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 530)
                    
                    Button(action: {
                        state = "start T"
                        if slider5Text == "Short" {
                            minTime = 5000
                            maxTime = 10000
                        } else if slider5Text == "Medium" {
                            minTime = 7000
                            maxTime = 15000
                        } else {
                            minTime = 10000
                            maxTime = 25000
                        }
                        spamWaitTime = Int(slider5Value)
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.green.opacity(elementOpacity))
                            .clipShape(Capsule())
                    }.padding(.top, 500)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    ZStack {
                        Slider(value: $slider5Value, in: 0...3)
                            .tint(.green)
                            .frame(width: 250)
                        Text("Wait time: ")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.trailing, 330)
                        Text("\(slider5Text)")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.leading, 300)
                    }
                }
            }
            
            //MARK: Time - log
            if state == "log T" {
                if 0 < timeLogValues.count && 0 < timeLogDates.count {
                    ScrollView {
                        VStack {
                            ForEach(0..<currentLogDates.count, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundColor(Color.black.opacity(getExistenceById(index: index)))
                                        .padding(.horizontal, 35)
                                    HStack {
                                        Text("Attempt: \(index + 1)")
                                            .font(.title2)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("\(currentLogVal1[index]) second difference. ")
                                            .font(.title2)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .padding(.trailing, 40)
                                    }
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.frame(height: 400)
                        .onAppear() {
                            makeCurrentUserLog(log: "time", user: userLoggedIn)
                        }
                } else {
                    Text("No log stored.")
                        .font(.title2)
                }
                
                ZStack {
                    Button(action: {
                        print(sentFrom)
                        if sentFrom == "results T" {
                            state = "results T"
                        } else if sentFrom == "start T" {
                            state = "start T"
                        }
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.blue.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    Button(action: {
                        state = "menu"
                    }) {
                        Text("Menu")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .padding(.trailing, 550)
                            .foregroundColor(.white)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut("m", modifiers: [])
                    Button(action: {
                        deleteUserLog(log: "time", user: userLoggedIn)
                    }) {
                        Text("Clear")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .padding(.leading, 550)
                            .foregroundColor(.white)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut("x", modifiers: [])
                }.frame(width: 670, height: 70)
                    .background(Color.black.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.top, 500)
            }
        }
    }
    
    //MARK: Aim
    
    @State private var showingTarget: Int = 0
    @State private var missedTargets: Int = 0
    @State private var timeToHit: [Int] = []
    @State private var targetSpawnDate: Date = Date()
    @State private var slider6Value: Double = 0
    func getTargetPadding(index: Int) -> CGFloat {
        return CGFloat(index * 50)
    }
    func getTargetBarWidth(index: Int) -> CGFloat {
        print("Index: \(index) line length: \(CGFloat((Float(timeToHit[index]) / Float(timeToHit.max()!)) * 420))")
        return CGFloat((Float(timeToHit[index]) / Float(timeToHit.max()!)) * 420)
    }
    func getTargetColor(index: Int) -> Color {
        if timeToHit[index] ==  timeToHit.min() {
            return .green
        } else if timeToHit[index] == timeToHit.max() {
            return .red
        } else {
            return .white
        }
    }
    var avaTimeToHit: Int {
        guard !timeToHit.isEmpty else {return 0}
        return Int(Float(timeToHit.reduce(0, +)) / Float(timeToHit.count))
    }
    func getTargetAvaLinePos() -> CGFloat {
        guard !timeToHit.isEmpty else {return 0}
        print("avarage time to hit")
        print(avaTimeToHit)
        print("therefore ofset is \(CGFloat(Float(avaTimeToHit) / Float(timeToHit.max()!)) * 420)")
        return -116 + CGFloat(Float(avaTimeToHit) / Float(timeToHit.max()!)) * 725
        
    }
    func writeToLog(log: String) {
        if log == "aim" {
            aimLogDates.append(Date().formatted(date: .omitted, time: .standard))
            aimLogDates.append(String(userLoggedIn))
            aimLogBestV.append(String(timeToHit.min()!))
            aimLogBestV.append(String(userLoggedIn))
            aimLogWorstV.append(String(timeToHit.max()!))
            aimLogWorstV.append(String(userLoggedIn))
            aimLogAvaV.append(String(avaTimeToHit))
            aimLogAvaV.append(String(userLoggedIn))
            print("Added everything into aim logs")
            print(aimLogDates)
            print(aimLogBestV)
            print(aimLogWorstV)
            print(aimLogAvaV)
        }
    }
    //MARK: Start Aim
    
    
    var aimView: some View {
        ZStack {
            if state == "start A" {
                Button(action: {
                    showingTarget = 0
                    missedTargets = 0
                    state = "shooting A"
                }) {
                    Text("start")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.green.opacity(bgOpacity))
                        .font(.largeTitle)
                }.buttonStyle(.plain)
                
                
                ZStack {
                    //SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                    Button(action: {
                        state = "menu"
                    }) {
                        Text("Back")
                            .font(.largeTitle)
                            .bold()
                            .frame(width: 100, height: 50)
                            .background(Color.black.opacity(elementOpacity))
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                        //.padding(.top, 500)
                        .padding(.trailing, 550)
                    Button(action: {
                        state = "settings A"
                    }) {
                        Text("Settings")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 200, height: 50)
                            .background(Color.black.opacity(elementOpacity))
                            .clipShape(Capsule())
                            //.padding(.top, 500)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    Button(action: {
                        makeCurrentUserLog(log: "aim", user: userLoggedIn)
                        sentFrom = state
                        state = "log A"
                    }) {
                        Text("Log")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.black.opacity(elementOpacity))
                            .clipShape(Capsule())
                            //.padding(.top, 500)
                            .padding(.leading, 550)
                    }.foregroundColor(.white)
                        .buttonStyle(.plain)
                        .keyboardShortcut("l", modifiers: [])
                }.frame(width: 670, height: 70)
                    .background(Color.black.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.top, 500)
            }
            //MARK: Aim - settings
            if state == "settings A" {
                ZStack {
                    Slider(value: $slider6Value, in: 3...15, step: 1)
                        .frame(width: 250)
                        .onChange(of: slider6Value) { newValue in
                            targetCount = Int(slider6Value)
                        }
                        .onAppear() {slider6Value = Double(targetCount)}
                    Text("\(targetCount) targets")
                        .padding(.leading, 325)
                }
                Button(action: {
                    state = "start A"
                    
                }) {
                    Text("Back")
                        .bold()
                        .font(.largeTitle)
                        .frame(width: 200, height: 50)
                        .background(Color.green.opacity(elementOpacity))
                        .clipShape(Capsule())
                }.padding(.top, 500)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space, modifiers: [.shift])
                
            }
            
            
            //MARK: Aim - shooting
            
            
            if state == "shooting A" {
                Button(action: {
                    missedTargets += 1
                    print("Missed!")
                }) {
                    Rectangle()
                        .frame(width: 700, height: 800)
                        .foregroundColor(Color.blue.opacity(bgOpacity))
                }.buttonStyle(.plain)
                ZStack {
                    ForEach(0...targetCount, id: \.self) { index in
                        if index == showingTarget {
                            Button(action: {
                                print("shot target")
                                if showingTarget < targetCount {
                                    showingTarget += 1
                                    timeToHit.append(Int(Date().timeIntervalSince(targetSpawnDate) * 1000))
                                } else {
                                    state = "end A"
                                    Task {
                                        try? await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
                                        state = "results A"
                                        writeToLog(log: "aim")
                                        makeCurrentUserLog(log: "aim", user: userLoggedIn)
                                        print(currentLogVal1)
                                        print(currentLogVal2)
                                        print(currentLogVal3)
                                        print(currentLogDates)
                                    }
                                }
                            }) {
                                Image(systemName: "target")
                                    .frame(width: 50, height: 50)
                                    .font(.system(size: 50, weight: .thin, design: .default))
                                    .clipShape(Circle())
                            }.buttonStyle(.plain)
                                .onAppear() {
                                    targetRandomX = Int.random(in: 20...680)
                                    targetRandomY = Int.random(in: 20...580)
                                    targetSpawnDate = Date()
                                }
                                .padding(.top, CGFloat(targetRandomY))
                                .padding(.leading, CGFloat(targetRandomX))
                        }
                    }
                }.padding(.bottom, 300)
                    .padding(.trailing, 350)
            }
            //MARK: Aim - end
            
            
            if state == "end A" {
                Rectangle()
                    .frame(width: 700, height: 650)
                    .foregroundColor(Color.black.opacity(bgOpacity))
                    .ignoresSafeArea()
                Text("End")
                    .font(.largeTitle)
                    .bold()
            }
            //MARK: Aim - results
            
            
            if state == "results A" {
                ZStack {
                    Text("Results")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 580)
                    ZStack {
                        ForEach(0..<timeToHit.count, id: \.self) { index in
                            Text("\(index + 1). Target:")
                                .foregroundColor(getTargetColor(index: index))
                                .font(.title2)
                                .padding(.trailing, 500)
                                .padding(.top, getTargetPadding(index: index))
                            Text("\(timeToHit[index]) ms.")
                                .foregroundColor(getTargetColor(index: index))
                                .font(.title2)
                                .padding(.trailing, 300)
                                .padding(.top, getTargetPadding(index: index))
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(getTargetColor(index: index))
                                .frame(width: getTargetBarWidth(index: index), height: 15)
                                .padding(.top, getTargetPadding(index: index))
                                .padding(.leading, getTargetBarWidth(index: index) - 180)
                        }
                    }.padding(.bottom, 450)
                        .padding(.trailing, 50)
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 2, height: CGFloat(26 * timeToHit.count))
                        .foregroundColor(.blue)
                        .padding(.leading, getTargetAvaLinePos())
                        .padding(.bottom, CGFloat(460 - 24 * targetCount))
                    Text("Avarage")
                        .foregroundColor(.blue)
                        .padding(.top, CGFloat(-270 + 40*targetCount))
                        .padding(.leading, getTargetAvaLinePos())
                    
                    ZStack {
                        Button(action: {
                            state = "menu"
                            timeToHit.removeAll()
                        }) {
                            Text("Menu")
                                .font(.largeTitle)
                                .bold()
                                .frame(width: 100, height: 50)
                                .background(Color.red.opacity(elementOpacity))
                                .clipShape(Capsule())
                        }.buttonStyle(.plain)
                            .padding(.trailing, 550)
                        
                        Button(action: {
                            state = "start A"
                            timeToHit.removeAll()
                        }) {
                            Text("Start again")
                                .font(.largeTitle)
                                .bold()
                                .frame(width: 180, height: 50)
                                .background(Color.blue.opacity(elementOpacity))
                                .clipShape(Capsule())
                        }.buttonStyle(.plain)
                        
                        Button(action: {
                            sentFrom = state
                            state = "log A"
                            
                        }) {
                            Text("Log")
                                .font(.largeTitle)
                                .bold()
                                .frame(width: 100, height: 50)
                                .background(Color.green.opacity(elementOpacity))
                                .clipShape(Capsule())
                        }.buttonStyle(.plain)
                            .padding(.leading, 550)
                    }.frame(width: 670, height: 70)
                        .background(Color.black.opacity(0.12))
                        .clipShape(Capsule())
                        .padding(.top, 500)
                    HStack(spacing: 21) {
                        Text("Best: \(timeToHit.min()!)ms")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.green)
                        Text("Avarage: \(avaTimeToHit)ms")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                        Text("Worst \(timeToHit.max()!)ms")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                    }.padding(.top, 400)
                }
            }
            //MARK: Aim - log
            
            
            if state == "log A" {
                ScrollView {
                    VStack {
                        if currentLogDates.count > 0 {
                            ForEach(0..<currentLogDates.count, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundColor(Color.black.opacity(getExistenceById(index: index)))
                                        .padding(.horizontal, 35)
                                    HStack {
                                        Text("Attempt: \(index + 1)")
                                            .font(.title2)
                                            .padding(.leading, 40)
                                        Spacer()
                                        
                                        Text("Best: \(currentLogVal1[index]), Worst: \(currentLogVal2[index]), Avarage:  \(currentLogVal3[index])")
                                            .font(.title2)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .padding(.trailing, 40)
                                        
                                    }
                                }
                            }
                        } else {
                            Text("No log stored")
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(height: 400)
                
                ZStack {
                    Button(action: {
                        print(sentFrom)
                        if sentFrom == "results A" {
                            state = "results A"
                        } else if sentFrom == "start A" {
                            state = "start A"
                        }
                    }) {
                        Text("Back")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 180, height: 50)
                            .background(Color.blue.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut(.space, modifiers: [.shift])
                    Button(action: {
                        state = "menu"
                        timeToHit.removeAll()
                    }) {
                        Text("Menu")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .padding(.trailing, 550)
                            .foregroundColor(.white)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut("m", modifiers: [])
                    Button(action: {
                        deleteUserLog(log: "aim", user: userLoggedIn)
                        makeCurrentUserLog(log: "aim", user: userLoggedIn)
                    }) {
                        Text("Clear")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: 100, height: 50)
                            .background(Color.red.opacity(elementOpacity))
                            .clipShape(Capsule())
                            .padding(.leading, 550)
                            .foregroundColor(.white)
                    }
                        .buttonStyle(.plain)
                        .keyboardShortcut("x", modifiers: [])
                }.frame(width: 670, height: 70)
                    .background(Color.black.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.top, 500)
            }
            
        }
    }
    
    //MARK: Memory - start
    
    
    @State private var squareCount: Int = 0
    @State private var squareAnswers: [Int] = []
    @State private var squareQuestions: [Int] = []
    @State private var valsReplaced: [Int] = []
    @State private var randInt: Int = 0
    @State private var regenerate: Bool = false
    func generateSquaresList(count: Int) {
        squareAnswers.removeAll()
        squareQuestions.removeAll()
        valsReplaced.removeAll()
        for _ in 0...35 {
            squareAnswers.append(0)
            squareQuestions.append(0)
        }
        for _ in 0...count - 1 {
            randInt = Int.random(in: 0...35)
            if valsReplaced.contains(randInt) {
                print("ValsRelpaced contained randInt, searching for new RANDOM one.")
                regenerate = true
                while regenerate {
                    print(randInt)
                    print(valsReplaced)
                    if !valsReplaced.contains(randInt) {
                        print("Found and changed random position.")
                        squareAnswers[randInt] = 1
                        valsReplaced.append(randInt)
                        regenerate = false
                    } else {
                        print("List contains randInt, regenerated it.")
                        randInt = Int.random(in: 0...35)
                    }
                }
            } else {
                print("Changed random position")
                squareAnswers[randInt] = 1
                valsReplaced.append(randInt)
            }
        }
    }
    func checkValid(q: Int, a: Int) -> Color {
        if q == a && q == 1{
            return .green
        } else if q != a && q == 1 {
            return .red
        } else if q != a && q == 0 {
            return .white
        } else {
            return .gray.opacity(elementOpacity)
        }
    }
    var memoryView: some View {
        ZStack {
            if state == "start M" {
                Button(action: {
                    squareCount = 1
                    generateSquaresList(count: squareCount)
                    state = "showing M"
                }) {
                    Text("start")
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.vertical, 50)
                        .frame(minWidth: 700, minHeight: 600)
                        .background(Color.green.opacity(bgOpacity))
                        .font(.largeTitle)
                }.buttonStyle(.plain)
            }
            
            if state == "showing M" {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue.opacity(bgOpacity))
                        .frame(width: 700, height: 650)
                        .ignoresSafeArea()
                    ZStack (alignment: .topLeading) {
                        ForEach(0...35, id: \.self) {index in
                            let column = index % 6
                            let row = index / 6
                            let isLit: Bool = squareAnswers[index] == 1
                            
                            Button(action: {
                                
                            }) {
                                Text("")
                                    .frame(width: 80, height: 80)
                                    .font(.largeTitle)
                                    .background(isLit ? Color.white : Color.gray.opacity(elementOpacity))
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }.buttonStyle(.plain)
                                .padding(.leading, CGFloat(column * 85))
                                .padding(.top, CGFloat(row * 85))
                        }
                    }.padding(.bottom, 50)
                        .padding(.leading, 0)
                    Button(action: {
                        state = "guessing M"
                    }) {
                        Text("Continue")
                            .font(.largeTitle)
                            .frame(width: 130, height: 50)
                            .background(Color.black.opacity(elementOpacity))
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                        .padding(.top, 530)
                }
            }
            
            if state == "guessing M" {
                ZStack {
                    Rectangle()
                        .frame(width: 700, height: 650)
                        .foregroundColor(.blue.opacity(bgOpacity))
                        .ignoresSafeArea()
                    
                    ZStack (alignment: .topLeading) {
                        ForEach(0...35, id: \.self) {index in
                            let column = index % 6
                            let row = index / 6
                            let isLit: Bool = squareQuestions[index] == 1
                            
                            Button(action: {
                                if squareQuestions[index] == 0 {
                                    squareQuestions[index] = 1
                                } else {
                                    squareQuestions[index] = 0
                                }
                            }) {
                                Text("")
                                    .frame(width: 80, height: 80)
                                    .font(.largeTitle)
                                    .background(isLit ? Color.white : Color.gray.opacity(elementOpacity))
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }.buttonStyle(.plain)
                                .padding(.leading, CGFloat(column * 85))
                                .padding(.top, CGFloat(row * 85))
                        }
                    }.padding(.bottom, 50)
                        .padding(.leading, 0)
                    
                    Button(action: {
                        state = "guessed M"
                    }) {
                        Text("Continue")
                            .font(.largeTitle)
                            .frame(width: 130, height: 50)
                            .background(Color.black.opacity(elementOpacity))
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                        .padding(.top, 530)
                }
            }
            
            if state == "guessed M" {
                ZStack {
                    Rectangle()
                        .frame(width: 700, height: 650)
                        .foregroundColor(.blue.opacity(bgOpacity))
                        .ignoresSafeArea()
                    
                    ZStack (alignment: .topLeading) {
                        ForEach(0...35, id: \.self) {index in
                            let column = index % 6
                            let row = index / 6
                            
                            Button(action: {
                                
                            }) {
                                Text("")
                                    .frame(width: 80, height: 80)
                                    .font(.largeTitle)
                                    .background(checkValid(q: squareQuestions[index], a: squareAnswers[index]))
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }.buttonStyle(.plain)
                                .padding(.leading, CGFloat(column * 85))
                                .padding(.top, CGFloat(row * 85))
                        }
                    }.padding(.bottom, 50)
                    
                    Button(action: {
                        if squareQuestions == squareAnswers {
                            squareCount += 1
                            generateSquaresList(count: squareCount)
                            print("all good, starting new round with \(squareCount) squares")
                            state = "showing M"
                        } else {
                            print("no good, sending to results")
                            state = "results M"
                        }
                    }) {
                        Text("Continue")
                            .font(.largeTitle)
                            .frame(width: 130, height: 50)
                            .background(Color.black.opacity(elementOpacity))
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                        .padding(.top, 530)
                }
            }
            
            if state == "end M" {
                
            }
            
            if state == "results M" {
                Text("You memorized \(squareCount) squares.")
                    .font(.largeTitle)
                    .bold
            }
            
            if state == "log M" {
                
            }
        }
    }
    
    
    
    var tutorView: some View {
        ZStack {
            Text("ts is tutorial")
            Button(action: {
                state = "menu"
            }) {
                Text("Back")
                
            }.padding(.top, 500)
        }
    }
    
    
    //MARK: usercard
    @ViewBuilder
    func userCard(at index: Int, size: CGFloat) -> some View {
        ZStack {
            if userNames.count > index - 1 {
                Button(action: {
                    if usersState == "choosing" {
                        usersState = "login"
                        userOnLogin = Int(index - 1)
                        bgOpacity = UserPreferencesBgOpacity[userOnLogin]
                        elementOpacity = UserPreferencesElementOpacity[userOnLogin]
                        darkMode = userPreferencesDarkMode[userOnLogin]
                        if elementOpacity > 0.7 || userColor[userOnLogin] == "white" {
                            textColor = .black
                        } else {
                            textColor = .white
                        }
                    } else if state == "userSettings" {
                        print("clicked me inside of user settings")
                        adminEditState = "editing"
                        accountUnderEdit = Int(index - 1)
                        nameInput = getProfileName(index: accountUnderEdit)
                        passwordInput = userPass[accountUnderEdit]
                    }
                }) {
                    Text(getProfilePicture(index: Int(index - 1)))
                        .font(.system(size: CGFloat(size / 2), weight: .thin, design: .default))
                        .frame(width: size, height: size)
                        .background(getProfileColor(index: index - 1))
                        .clipShape(Circle())
                        .padding(.bottom, 1)
                }.buttonStyle(.plain)
                Text(userNames[index - 1])
                    .padding(.top, size * 1.195)
                    .font(.largeTitle)
            } else {
                EmptyView()
            }
        }
    }
    
    //MARK: STARTUP
    var StartupView: some View {
        ZStack {
            VStack(spacing: -20) {
                Text("Welcome to")
                    .font(.largeTitle)
                    .foregroundColor(Color.white.opacity(0.6))
                Text("Skill tester.")
                    .font(.system(size: 81, weight: .bold, design: .default))
                    .foregroundColor(Color.white.opacity(0.7))
            }.padding(.bottom, 500)
            
            //MARK: Chosing users
            if usersState == "choosing" {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<howManyButtons, id: \.self) { index in
                            if index == 0 {
                                Text("FIRST")
                                    .foregroundColor(.clear)
                                    .padding(.leading, 180)
                            } else if index == userNames.count + 1 {
                                Text("LAST")
                                    .foregroundColor(.clear)
                                    .padding(.trailing, 180)
                            } else {
                                userCard(at: index, size: 250)
                            }
                        }
                        
                    }.padding(.bottom, 109)
                }
                
//                Text("or")
//                    .font(.system(size: 50, design: .default))
//                    .baselineOffset(0.5)
//                    .padding(.top, 300)

                Button(action: {
                    usersState = "creating"
                    passwordState = "name"
                }) {
                    Text("Add User")
                        .font(.system(size: 50, weight: .thin, design: .default))
                        .baselineOffset(0.5)
                        .frame(width: 220, height: 60)
                        .background(Color.blue.opacity(0.45))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                }.buttonStyle(.plain)
                    .padding(.top, 485)
                    .padding(.trailing, 1)
            }
            //MARK: Creating user
            if usersState == "creating" {
                Button(action: {
                    print("ADD USER")
                }) {
                    Text("+")
                        .font(.system(size: 110, weight: .thin, design: .default))
                        .baselineOffset(13)
                        .frame(width: 250, height: 250)
                        .background(Color.blue.opacity(0.45))
                        .clipShape(Circle())
                }.buttonStyle(.plain)
                    .padding(.bottom, 110)
                    .disabled(passwordState != "none")
            }
            //MARK: Login user
            if usersState == "login" {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                    .ignoresSafeArea()
                Text(getProfilePicture(index: userOnLogin))
                    .font(.system(size: 125, weight: .thin, design: .default))
                    .foregroundColor(darkMode ? textColor.opacity(0.8) : Color.black.opacity(0.8))
                    .frame(width: 250, height: 250)
                    .background(getProfileColor(index: userOnLogin))
                    .clipShape(Circle())
                    .padding(.bottom, 110)
                Text(userNames[userOnLogin])
                    .foregroundColor(darkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                    .font(.largeTitle)
                    .padding(.top, 190)
                HStack(spacing: -35) {
                    SecureField("Password...", text: $passwordInput)
                        .font(.largeTitle)
                        .foregroundColor(darkMode ? Color.gray : Color.white)
                        .padding(.leading, 10)
                        .textFieldStyle(.plain)
                        .frame(width: 190, height: 40)
                        .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.black.opacity(elementOpacity))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Button(action: {
                        if passwordInput == userPass[userOnLogin] {
                            print("USER NAME: \(userNames[userOnLogin]) SIGNED IN")
                            usersState = "loggedin"
                            state = "loggedin"
                            userLoggedIn = userOnLogin
                            lastLoggedIn = userLoggedIn
                            bgOpacity = UserPreferencesBgOpacity[userLoggedIn]
                            elementOpacity = UserPreferencesElementOpacity[userLoggedIn]
                            darkMode = userPreferencesDarkMode[userLoggedIn]

                            passwordInput = ""
                            passwordRepeat = ""
                            print("Last logged in: \(lastLoggedIn)")
                        } else {
                            print("INCORRECT PASSWORD ON LOGIN")
                            passwordInput = ""
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.largeTitle)
                            .foregroundColor(darkMode ? .gray : .white)
                            .frame(width: 30, height: 30)
                            .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.black.opacity(elementOpacity))
                            .clipShape(Circle())
                    }.buttonStyle(.plain)
                        .keyboardShortcut(.return, modifiers: [])
                }.padding(.top, 280)
                
                Button(action: {
                    usersState = "choosing"
                    passwordState = "done"
                    passwordInput = ""
                    
                    bgOpacity = 0.6
                    elementOpacity = 0.45
                }) {
                    Image(systemName: "arrow.left")
                        .font(.largeTitle)
                        .foregroundColor(darkMode ? .gray : .white)
                        .frame(width: 40, height: 40)
                        .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.black.opacity(elementOpacity))
                        .clipShape(Circle())
                }.buttonStyle(.plain)
                    .keyboardShortcut(.return, modifiers: [])
                    .padding(.top, 280)
                    .padding(.trailing, 230)
            }
            //MARK: Brand new screen
            ZStack {
                if usersState == "none" {
                    Text("Add User")
                        .font(.largeTitle)
                        .foregroundColor(Color.white.opacity(0.8))
                    Button(action: {
                        print("Pressed add user.")
                        usersState = "creating"
                        passwordState = "name"
                    }) {
                        Text("+")
                            .font(.system(size: 110, weight: .thin, design: .default))
                            .baselineOffset(13)
                            .frame(width: 250, height: 250)
                            .background(Color.blue.opacity(0.45))
                            .clipShape(Circle())
                    }.buttonStyle(.plain)
                        .padding(.bottom, 310)
                        .disabled(passwordState != "none")
                } else if passwordState == "name" {
                    HStack(spacing: -35) {
                        TextField("Name...", text: $nameInput)
                            .font(.largeTitle)
                            .padding(.leading, 10)
                            .textFieldStyle(.plain)
                            .frame(width: 190, height: 40)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Button(action: {
                            if nameInput.count >= 4 {
                                print("USER NAME: \(nameInput)")
                                passwordState = "input"
                            } else {
                                print("USER NAME NOT LONG ENOUGH")
                            }
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }.buttonStyle(.plain)
                            .keyboardShortcut(.return, modifiers: [])
                    }.padding(.top, 1)
                } else {
                    if usersState == "creating" {
                        Text(nameInput)
                            .font(.largeTitle)
                            .foregroundColor(Color.white.opacity(0.8))
                            .padding(.top, -8)
                    }
                }
            
            //MARK: + Name & Password
                if passwordState == "input" || passwordState == "repeat"{
                    HStack(spacing: -35) {
                        SecureField("Password...", text: $passwordInput)
                            .font(.largeTitle)
                            .padding(.leading, 10)
                            .textFieldStyle(.plain)
                            .frame(width: 190, height: 40)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Button(action: {
                            if nameInput.count > 0 {
                                print("USER PASSWORD: \(passwordInput)")
                                passwordState = "repeat"
                            } else {
                                print("PASSWORD NOT LONG ENOUGH")
                            }
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }.buttonStyle(.plain)
                            .keyboardShortcut(.return, modifiers: [])
                    }.padding(.top, 65)
                    if passwordState == "repeat" {
                        HStack(spacing: -35) {
                            SecureField("Repeat...", text: $passwordRepeat)
                                .font(.largeTitle)
                                .padding(.leading, 10)
                                .textFieldStyle(.plain)
                                .frame(width: 190, height: 40)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Button(action: {
                                if passwordInput == passwordRepeat {
                                    //MARK: User created
                                    print("USER PASSWORD (final): \(passwordRepeat)")
                                    print("USER PROFILE CREATED")
                                    userNames.append(nameInput)
                                    userPass.append(passwordInput)
                                    userColor.append("blue")
                                    UserPreferencesBgOpacity.append(0.6)
                                    UserPreferencesElementOpacity.append(0.45)
                                    userPreferencesDarkMode.append(true)
                                    passwordState = "done"
                                    usersState = "choosing"
                                    passwordInput = ""
                                    passwordRepeat = ""
                                } else {
                                    print("PASSWORDS ARE NOT MATCHING")
                                }
                            }) {
                                Image(systemName: "arrow.right")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                    .frame(width: 30, height: 30)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                            }.buttonStyle(.plain)
                                .keyboardShortcut(.return, modifiers: [])
                        }.padding(.top, 150)
                    }
                }
            }.padding(.top, 200)
            
        //MARK: Auto login
        }.onAppear {
            print(userPreferencesDarkMode)
            if isOnFresh {
                if resetOnLaunch {
                    userNames.removeAll()
                    userPass.removeAll()
                    userColor.removeAll()
                    keepLoggedIn = []
                    UserPreferencesBgOpacity = []
                    UserPreferencesElementOpacity = []
                    
                    clearAllLogs()
                }
                
                print("\(howManyButtons) buttons")
                print("\(userNames.count) users")
                
                print("Keep logged in: \(keepLoggedIn)")
                print(lastLoggedIn)
                if userNames.count > 0 {
                    if keepLoggedIn.isEmpty || !keepLoggedIn.contains(lastLoggedIn){
                        passwordState = "done"
                        usersState = "choosing"
                        print(elementOpacity)
                        
                    } else {
                        if lastLoggedIn < 100 {
                            //print("Trying to get \(lastLoggedIn) from \(keepLoggedIn)")
                            userLoggedIn = lastLoggedIn
                            bgOpacity = UserPreferencesBgOpacity[userLoggedIn]
                            elementOpacity = UserPreferencesElementOpacity[userLoggedIn]
                            darkMode = userPreferencesDarkMode[userLoggedIn]
                            usersState = "loggedin"
                            state = "loggedin"
                            //passwordState = "done"
                            
                            if elementOpacity > 0.7 || userColor[userLoggedIn] == "white" {
                                textColor = .black
                            } else {
                                textColor = .white
                            }
                        }
                        
                    }
                } else {
                    passwordState = "none"
                    usersState = "none"
                }
                isOnFresh = false
            }
        }
    }
    //MARK: User main screen
    
    
    var userView: some View {
        ZStack {
            VStack(spacing: -20) {
                Text("Welcome back,")
                    .font(.largeTitle)
                    .foregroundColor(darkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                Text(getProfileName(index:userLoggedIn))
                    .font(.system(size: 81, weight: .bold, design: .default))
                    .foregroundColor(darkMode ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
            }.padding(.bottom, 500)
            
            ZStack {
                Button(action: {
                    state = "menu"
                }) {
                    Text("Continue")
                        .font(.system(size: 51, weight: .bold, design: .default))
                        .foregroundColor(textColor.opacity(0.8))
                        .frame(width: 250, height: 70)
                        .background(getProfileColor(index: userLoggedIn))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                }.buttonStyle(.plain)
                    .padding(.leading, 410)
                
                Button(action: {
                    usersState = "userSettings"
                }) {
                    Text(getProfilePicture(index: userLoggedIn))
                        .font(.system(size: 51, weight: .thin, design: .default))
                        .foregroundColor(textColor.opacity(0.8))
                        .frame(width: 70, height: 70)
                        .background(getProfileColor(index: userLoggedIn))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                }.buttonStyle(.plain)
                    .padding(.trailing, 590)
                
                Button(action: {
                    state = "designSettings"
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 41, design: .default))
                        .foregroundColor(textColor.opacity(0.8))
                        .frame(width: 70, height: 70)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }.buttonStyle(.plain)
                    .padding(.trailing, 400)
                
                Button(action: {
                    makeLogLeaderboard(mode: "spam")
                    makeLogLeaderboard(mode: "react")
                    makeLogLeaderboard(mode: "time")
                    makeLogLeaderboard(mode: "aim")
                    
                    state = "user results"
                }) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 33, design: .default))
                        .foregroundColor(textColor.opacity(0.8))
                        .frame(width: 70, height: 70)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }.buttonStyle(.plain)
                    .padding(.trailing, 210)
            }.frame(width: 680, height: 90)
                .background(Color.black.opacity(0.12))
                .clipShape(Capsule())
                .padding(.top, 490)
            
            //MARK: Click profile menu
            
            
            if usersState == "userSettings" {
                ZStack {
                    SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                    VStack {
                     
                        Button(action: {
                            usersState = "choosing"
                            state = "startup"
                            if !keepLoggedIn.isEmpty {
                                print("Users to keep logged in: \(keepLoggedIn)")
                            }
                            nameInput = ""
                            passwordInput = ""
                            lastLoggedIn = 101
                            bgOpacity = 0.6
                            elementOpacity = 0.45
                        }) {
                            Text("Log out")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                                .frame(width: 180, height: 50)
                                .background(Color.gray.opacity(elementOpacity - 0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }.buttonStyle(.plain)
                        
                        Button(action: {
                            state = "userSettings"
                        }) {
                            Text("Manage")
                                .font(.largeTitle)
                                .frame(width: 180, height: 50)
                                .background(Color.gray.opacity(elementOpacity - 0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }.buttonStyle(.plain)
                        
                        
                        Button(action: {
                            usersState = "loggedin"
                        }) {
                            Text("Back")
                                .font(.largeTitle)
                                .frame(width: 180, height: 50)
                                .background(Color.gray.opacity(elementOpacity - 0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }.buttonStyle(.plain)
                        
                    }.frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }.frame(width: 200, height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                    .padding(.top, 370)
                    .padding(.trailing, 461)
            }
        }
    }
    
    //MARK: Appearance Settings
    var designSettingsView: some View {
        ZStack {
            Text("")
                .frame(width: 400, height: 400)
                .background(getProfileColor(index: userLoggedIn))
                .clipShape(Circle())
            
            SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                .ignoresSafeArea()
            
            VStack(spacing: -20) {
                Text("Settings for")
                    .font(.largeTitle)
                    .foregroundColor(darkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                HStack(spacing: 20) {
                    Text(adminStatus(index:userLoggedIn))
                        .font(.system(size: 81, weight: .thin, design: .default))
                        .foregroundColor(darkMode ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                    Text(getProfileName(index:userLoggedIn))
                        .font(.system(size: 81, weight: .bold, design: .default))
                        .foregroundColor(darkMode ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                }
            }.padding(.bottom, 500)
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                VStack(spacing: -20) {
                    Text("Accent color:")
                        .font(.largeTitle)
                        .foregroundColor(Color.white.opacity(0.67))
                    
                    HStack {
                        ForEach(0..<12, id: \.self) {index in
                            if userColor[userLoggedIn] == getButtonColorName(index: index) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(textColor.opacity(0.8))
                                    .frame(width: 40, height: 40)
                                    .background(getButtonColor(index: index))
                                    .clipShape(Circle())
                                
                            } else {
                                Button(action: {
                                    print("Button returned \(getButtonColor(index: index))")
                                    userColor[userLoggedIn] = getButtonColorName(index: index)
                                }) {
                                    Text("")
                                        .frame(width: 40, height: 40)
                                        .background(getButtonColor(index: index))
                                        .clipShape(Circle())
                                    
                                }.buttonStyle(.plain)
                            }
                            
                        }
                    }.padding(.top, 20)
                    
                    Text("Appearance:")
                        .font(.largeTitle)
                        .foregroundColor(Color.white.opacity(0.67))
                        .padding(.top, 40)
                    
                    Text("Elements")
                        .font(.title3)
                        .foregroundColor(Color.white.opacity(0.67))
                        .padding(.top, 40)
                    
                    HStack {
                        Text("Less opaque")
                            .font(.title3)
                        Slider(value: $elementOpacity, in: 0.3...1)
                            .frame(width: 250)
                            .tint(getProfileColor(index: userLoggedIn))
                            .onChange(of: elementOpacity) { newElValue in
                                UserPreferencesElementOpacity[userLoggedIn] = elementOpacity
                                if elementOpacity > 0.7 || userColor[userLoggedIn] == "white" {
                                    textColor = .black
                                } else {
                                    textColor = .white
                                }
                            }
                        Text("More opaque")
                            .font(.title3)
                    }.padding(.top, 20)
                    
                    Text("Background")
                        .font(.title3)
                        .foregroundColor(Color.white.opacity(0.67))
                        .padding(.top, 40)
                    
                    HStack {
                        Text("Less opaque")
                            .font(.title3)
                        Slider(value: $bgOpacity, in: 0.3...1)
                            .frame(width: 250)
                            .tint(getProfileColor(index: userLoggedIn))
                            .onChange(of: bgOpacity) { newBgValue in
                                UserPreferencesBgOpacity[userLoggedIn] = bgOpacity
                                print("Background opacity changed!")
                            }
                        Text("More opaque")
                            .font(.title3)
                    }.padding(.top, 20)
                    
                    
                }.padding(.bottom, 11)
            }.frame(width: 600, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.bottom, 61)
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                HStack {
                    Toggle("Dark mode", isOn: $darkMode)
                        .tint(darkMode ? Color.white : Color.black)
                        .toggleStyle(.switch)
                        .onChange(of: darkMode) {newMode in
                            userPreferencesDarkMode[userLoggedIn] = darkMode
                        }
                        
                }
            }.frame(width: 600, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 340)
            
            Button(action: {
                print("Back to userView")
                state = "loggedin"
                usersState = "loggedin"
            }) {
                Text("Back")
                    .font(.largeTitle)
                    .frame(width: 120, height: 50)
                    .background(Color.black.opacity(elementOpacity))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }.buttonStyle(.plain)
                .padding(.top, 500)
                .padding(.trailing, 1)
            Text("")
                .frame(width: 40, height: 40)
                .background(getProfileColor(index: userLoggedIn))
                .opacity(elementOpacity)
                .clipShape(Circle())
                .padding(.top, -8)
                .padding(.leading, 510)
            Text("")
                .frame(width: 40, height: 40)
                .background(getProfileColor(index: userLoggedIn))
                .opacity(bgOpacity)
                .clipShape(Circle())
                .padding(.top, 131)
                .padding(.leading, 510)
        }
    }
    
    //MARK: User settings
    var userSettingsView: some View {
        ZStack {
            SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                .ignoresSafeArea()
            VStack(spacing: -20) {
                Text("User settings for")
                    .font(.largeTitle)
                    .foregroundColor(darkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                HStack(spacing: 20) {
                    Text(adminStatus(index:userLoggedIn))
                        .font(.system(size: 81, weight: .thin, design: .default))
                        .foregroundColor(darkMode ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                    Text(getProfileName(index:userLoggedIn))
                        .font(.system(size: 81, weight: .bold, design: .default))
                        .foregroundColor(darkMode ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                }
            }.padding(.bottom, 500)
            
            
            // if isAdmin.contains(userLoggedIn) {
                ZStack {
                    if adminEditState == "editing" && accountUnderEdit < 101 {
                        Text(getProfilePicture(index: accountUnderEdit))
                            .font(.system(size: 41, weight: .thin, design: .default))
                            .foregroundColor(Color.white.opacity(0.8))
                            .frame(width: 360, height: 360)
                            .background(getProfileColor(index: accountUnderEdit))
                            .clipShape(Circle())
                            .padding(.top, 1)
                            .padding(.leading, 1)
                    }
                    SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                    ZStack {
                        if adminEditState == "none" {
                            Text("All accounts")
                                .font(.largeTitle)
                                .padding(.bottom, 215)
                        } else {
                            Text(getProfileName(index: accountUnderEdit))
                                .font(.largeTitle)
                                .padding(.bottom, 215)
                        }
                        if adminEditState == "none" && isAdmin.contains(userLoggedIn) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(0..<userNames.count + 2, id: \.self) { index in
                                        if index == 0 {
                                            Text("FIRST")
                                                .foregroundColor(.clear)
                                                .padding(.leading, 1)
                                        } else if index == userNames.count + 1 {
                                            Text("LAST")
                                                .foregroundColor(.clear)
                                                .padding(.trailing, 1)
                                        } else {
                                            userCard(at: index, size: 160)
                                        }
                                    }
                                }
                            }
                        } else if adminEditState == "editing" {

                            if isAdmin.contains(userLoggedIn) {
                                Button(action: {
                                    print("Chosing users to edit")
                                    adminEditState = "none"
                                    isPasswordVisible = false
                                    saveUserMessage = "none"
                                    saveUserError = "none"
                                    
                                    nameInput = ""
                                    passwordInput = ""
                                }) {
                                    Text("Back")
                                        .font(.largeTitle)
                                        .frame(width: 120, height: 50)
                                        .background(Color.black.opacity(elementOpacity))
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                }.buttonStyle(.plain)
                                    .padding(.top, 205)
                                    .padding(.trailing, 466)
                            }
                            //MARK: Deleting user
                            Button(action: {
                                print("Delete user pressed.")
                                if !isAdmin.contains(accountUnderEdit) {
                                    if isAdmin.contains(userLoggedIn) {
                                        adminEditState = "none"
                                        
                                        deleteUserLog(log: "spam", user: accountUnderEdit)
                                        deleteUserLog(log: "react", user: accountUnderEdit)
                                        deleteUserLog(log: "time", user: accountUnderEdit)
                                        deleteUser(user: accountUnderEdit)
                                        
                                    } else {
                                        usersState = "choosing"
                                        state = "startup"
                                        nameInput = ""
                                        passwordInput = ""
                                        lastLoggedIn = 101
                                        bgOpacity = 0.6
                                        elementOpacity = 0.45
                                        
                                        deleteUserLog(log: "spam", user: accountUnderEdit)
                                        deleteUserLog(log: "react", user: accountUnderEdit)
                                        deleteUserLog(log: "time", user: accountUnderEdit)
                                        deleteUser(user: accountUnderEdit)
                                    }
                                } else {
                                    saveUserError = "Can not delete an admin accout!"
                                }
                            }) {
                                Text("Delete user")
                                    .font(.largeTitle)
                                    .frame(width: 180, height: 50)
                                    .background(Color.red.opacity(elementOpacity))
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                            }.buttonStyle(.plain)
                                .padding(.top, 205)
                                .padding(.trailing, 1)
                            
                            //MARK: Save user change
                            Button(action: {
                                print("Saved users name & password.")
                                if nameInput.count >= 4 {
                                    userNames[accountUnderEdit] = nameInput
                                    saveUserError = "none"
                                    saveUserMessage = "Updated \(getProfileName(index: accountUnderEdit))'s details."
                                } else { saveUserError = "Name has to be atleast 4 characters long!" }
                                
                                if passwordInput.count > 0 {
                                    userPass[accountUnderEdit] = passwordInput
                                    saveUserError = "none"
                                    saveUserMessage = "Updated \(getProfileName(index: accountUnderEdit))'s details."
                                } else { saveUserError = "Password has to be atleast 1 character." }
                                
                                isPasswordVisible = false
                            }) {
                                Text("Save")
                                    .font(.largeTitle)
                                    .frame(width: 120, height: 50)
                                    .background(Color.black.opacity(elementOpacity))
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                            }.buttonStyle(.plain)
                                .padding(.top, 205)
                                .padding(.leading, 466)
                            
                            Text("User name")
                                .font(.largeTitle)
                                .padding(.bottom, 135)
                                .padding(.trailing, 331)
                            //MARK: Password & Name
                            
                            
                            TextField(getProfileName(index: accountUnderEdit), text: $nameInput)
                                .font(.largeTitle)
                                .padding(.leading, 10)
                                .textFieldStyle(.plain)
                                .frame(width: 190, height: 40)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 50)
                                .padding(.trailing, 330)
                                .onChange(of: nameInput) { NewName in
                                    saveUserMessage = "none"
                                }
                            
                            Text("Password")
                                .font(.largeTitle)
                                .padding(.bottom, 135)
                                .padding(.leading, 331)
                            
                            if isPasswordVisible {
                                TextField("Password", text: $passwordInput)
                                    .font(.largeTitle)
                                    .padding(.leading, 10)
                                    .textFieldStyle(.plain)
                                    .frame(width: 190, height: 40)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.bottom, 50)
                                    .padding(.leading, 330)
                                    .onChange(of: passwordInput) { NewPassword in
                                        saveUserMessage = "none"
                                    }
                                
                                Button(action: {
                                    isPasswordVisible = false
                                }) {
                                    Image(systemName: "eye")
                                        .frame(width: 40, height: 40)
                                        .background(Color.gray.opacity(0.3))
                                        .clipShape(Circle())
                                        .padding(.bottom, 50)
                                }.buttonStyle(.plain)
                                
                            } else {
                                SecureField("Password", text: $passwordInput)
                                    .font(.largeTitle)
                                    .padding(.leading, 10)
                                    .textFieldStyle(.plain)
                                    .frame(width: 190, height: 40)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.bottom, 50)
                                    .padding(.leading, 330)
                                    .onChange(of: passwordInput) { NewPassword in
                                        saveUserMessage = "none"
                                    }
                                Button(action: {
                                    isPasswordVisible = true
                                }) {
                                    Image(systemName: "eye.slash")
                                        .frame(width: 40, height: 40)
                                        .background(Color.gray.opacity(0.3))
                                        .clipShape(Circle())
                                        .padding(.bottom, 50)
                                }.buttonStyle(.plain)
                            }
                            
                            if saveUserError != "none" {
                                Text(saveUserError)
                                    .font(.title2)
                                    .frame(width: 586, height: 50)
                                    .background(Color.red.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 31))
                                    .padding(.top, 71)
                                
                            }
                            if saveUserMessage != "none" && saveUserError == "none" {
                                Text(saveUserMessage)
                                    .font(.title2)
                                    .frame(width: 586, height: 50)
                                    .background(Color.green.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 31))
                                    .padding(.top, 71)
                            }
                        }
                    }
                }.frame(width: 600, height: 270)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.bottom, -140)
            //MARK: Keep logged in
            
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                VStack {
                    Text("Your account")
                        .font(.largeTitle)
                    HStack {
                        Toggle("Stay logged in", isOn: $keepLoggedInSwitch)
                            .toggleStyle(.switch)
                            .tint(getProfileColor(index: userLoggedIn))
                            .onChange(of: keepLoggedInSwitch) { turnedOn in
                                if turnedOn {
                                    keepLoggedIn.append(userLoggedIn)
                                } else {
                                    keepLoggedIn.remove(at: keepLoggedIn.firstIndex(of: userLoggedIn) ?? 0)
                                }
                                print(keepLoggedIn)
                            }
                        
                    }
                }
            }.frame(width: 600, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.bottom, 270)
                .onAppear {
                    saveUserError = "none"
                    adminEditState = "none"
                    if keepLoggedIn.contains(userLoggedIn) {
                        keepLoggedInSwitch = true
                    } else {
                        keepLoggedInSwitch = false
                    }
                    if !isAdmin.contains(userLoggedIn) {
                        adminEditState = "editing"
                        accountUnderEdit = userLoggedIn
                        nameInput = userNames[userLoggedIn]
                        passwordInput = userPass[userLoggedIn]
                    }
                }
            
            Button(action: {
                print("Back to userView")
                state = "loggedin"
                usersState = "loggedin"
                adminEditState = "none"
            }) {
                Text("Back")
                    .font(.largeTitle)
                    .frame(width: 120, height: 50)
                    .background(Color.black.opacity(elementOpacity))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }.buttonStyle(.plain)
                .padding(.top, 500)
        }
    }
    //MARK: User results
    
    func getLeaderboardfont(index: Int) -> Font {
        if index == 0 {
            return .system(size: 60, weight: .bold, design: .default)
        } else if index == 1 {
            return .system(size: 50, weight: .bold, design: .default)
        } else if index == 2 {
            return .system(size: 50, weight: .bold, design: .default)
        } else {
            return .system(size: 50, design: .default)
        }
    }
    func getLeaderboardColor(index: Int) -> Color {
        if index == 0 {
            return .yellow
        } else if index == 1 {
            return .orange
        } else if index == 2 {
            return .white
        } else {
            return .gray
        }
    }
    
    @State private var leaderboardText: String = "Spam mode"
    @State private var modePadding: Int = 0
    var userResults: some View {
        ZStack {
            SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                .ignoresSafeArea()
            VStack(spacing: -20) {
                Text("Leaderboard for")
                    .font(.largeTitle)
                    .foregroundColor(darkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                HStack(spacing: 20) {
                    Text(leaderboardText)
                        .font(.system(size: 81, weight: .bold, design: .default))
                        .foregroundColor(darkMode ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                        
                }
            }.padding(.bottom, 500)
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                // SPAM
                VStack {
                    ScrollView {
                        ForEach(0...userNames.count - 1, id: \.self) {index in
                            if spamLeaderboard[index].hasPrefix("0") {
                                Text("#\(index+1). \(userNames[bestSpamValues.firstIndex(of: spamLeaderboard[index])!]) -cps.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestSpamValues.firstIndex(of: spamLeaderboard[index])!]) \(spamLeaderboard[index])cps.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            }
                        }
                    }.padding(.top, 15)
                }
            }.frame(width: 600, height: 390)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.leading, CGFloat(0 - modePadding))
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                // REACTION
                VStack {
                    ScrollView {
                        ForEach(0...userNames.count - 1, id: \.self) {index in
                            if reactLeaderboard[index].hasPrefix("N") {
                                Text("#\(index+1). \(userNames[bestReactValues.firstIndex(of: reactLeaderboard[index])!]) ---ms.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestReactValues.firstIndex(of: reactLeaderboard[index])!]) \(reactLeaderboard[index])ms.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            }
                        }
                    }.padding(.top, 15)
                }
            }.frame(width: 600, height: 390)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.leading, CGFloat(1400 - modePadding))
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                // TIME
                VStack {
                    ScrollView {
                        ForEach(0...userNames.count - 1, id: \.self) {index in
                            if timeLeaderboard[index].hasPrefix("N") {
                                Text("#\(index+1). \(userNames[bestTimeValues.firstIndex(of: timeLeaderboard[index])!]) -.-s.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestTimeValues.firstIndex(of: timeLeaderboard[index])!]) \(timeLeaderboard[index])s.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            }
                        }
                    }.padding(.top, 15)
                }
            }.frame(width: 600, height: 390)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.leading, CGFloat(2800 - modePadding))
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                // AIM
                VStack {
                    ScrollView {
                        ForEach(0...userNames.count - 1, id: \.self) {index in
                            if aimLeaderboard[index].hasPrefix("N") {
                                Text("#\(index+1). \(userNames[bestAimValues.firstIndex(of: aimLeaderboard[index])!]) ---ms.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestAimValues.firstIndex(of: aimLeaderboard[index])!]) \(aimLeaderboard[index])ms.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            }
                        }
                    }.padding(.top, 5)
                }
            }.frame(width: 600, height: 390)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.leading, CGFloat(4200 - modePadding))
            
            ZStack {
                Button(action: {
                    print("Back to userView")
                    state = "loggedin"
                    usersState = "loggedin"
                    adminEditState = "none"
                }) {
                    Text("Back")
                        .font(.largeTitle)
                        .frame(width: 120, height: 50)
                        .background(Color.black.opacity(elementOpacity))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }.buttonStyle(.plain)
                    
                Button(action: {
                    if modePadding != 0 {
                        if modePadding == 4200 {
                            leaderboardText = "Time mode"
                        } else if modePadding == 2800 {
                            leaderboardText = "Reaction mode"
                        } else if modePadding == 1400 {
                            leaderboardText = "Spam mode"
                        }
                        withAnimation(.easeInOut(duration: 0.7)) {
                            modePadding -= 1400
                        }
                    }
                    print("Left arrow pressed; paddding: \(modePadding)")
                }) {
                    Image(systemName: "arrow.left")
                        .font(.largeTitle)
                        .frame(width: 80, height: 50)
                        .background(Color.black.opacity(elementOpacity))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }.buttonStyle(.plain)
                    .padding(.trailing, 520)
                
                Button(action: {
                    if modePadding != 4200 {
                        if modePadding == 0 {
                            leaderboardText = "Reaction mode"
                        } else if modePadding == 1400 {
                            leaderboardText = "Time mode"
                        } else if modePadding == 2800 {
                            leaderboardText = "Aim mode"
                        }
                        withAnimation(.easeInOut(duration: 0.7)) {
                            modePadding += 1400
                        }
                    }
                    print("Right arrow pressed; paddding: \(modePadding)")
                }) {
                    Image(systemName: "arrow.right")
                        .font(.largeTitle)
                        .frame(width: 80, height: 50)
                        .background(Color.black.opacity(elementOpacity))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }.buttonStyle(.plain)
                    .padding(.leading, 520)

            }.padding(.top, 500)
        }
    }
    
    //MARK: BODY
    var body: some View {
        ZStack {
            if darkMode {
                Rectangle()
                    .fill(Color(white: 0.15).opacity(bgLowOpacity))
                    .frame(width: 700, height: 630)
                    .ignoresSafeArea()
            } else {
                Rectangle()
                    .fill(Color.white.opacity(bgLowOpacity))
                    .frame(width: 700, height: 630)
                    .ignoresSafeArea()
            }
                
            if state == "menu" {
                menuView
            } else if state.hasSuffix("S") {
                spamView
            } else if state.hasSuffix("R") {
                reactView
            } else if state.hasSuffix("T") {
                timeView
            } else if state.hasSuffix("A") {
                aimView
            } else if state.hasSuffix("M") {
                memoryView
            } else if state == "tutor" {
                tutorView
            } else if state == "startup" {
                StartupView
            } else if state == "loggedin" {
                userView
            } else if state == "designSettings" {
                designSettingsView
            } else if state == "userSettings" {
                userSettingsView
            } else if state == "user results" {
                userResults
            }
        }
        .frame(minWidth: 700, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
        .navigationTitle("Skilltester")
        .onReceive(timer) { _ in
            timeElapsed += 1
        }
        .onAppear() {
            print(userNames)
            print(userPass)
            
            print("Spam logs:")
            print(spamLogDates)
            print(spamLogValues)
            print(spamLogDurations)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import Foundation

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}
