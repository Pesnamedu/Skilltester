//
//  ContentView.swift
//  Skilltester
//
//  Created by Luky on 02.07.2026.
//

import SwiftUI
import Foundation
import AppKit

struct ContentView: View {
    
    init() {
        print("-startup")
        print("Date -\(formattedDate)")
        if Date().weekDay == "Mon" && !screenTimeReseted {
            for i in 0..<userNames.count {
                screenTimeMon[i] = 0
                screenTimeTue[i] = 0
                screenTimeWed[i] = 0
                screenTimeThu[i] = 0
                screenTimeFri[i] = 0
                screenTimeSat[i] = 0
                screenTimeSun[i] = 0
            }
            screenTimeReseted = true
        }
        if Date().weekDay != "Mon" {
            screenTimeReseted = false
        }
        print(pickerLogAvaV)
        print("Startup bgOpacity: \(bgOpacity)")
        print(UserPreferencesBgOpacity)
        print(screenTimeMon)
        print(screenTimeReseted)
        print(lastStreakDays)
        print(userStreaks)
        print("-")
    }
    
    
    @State private var mouseXY: NSPoint = .zero
    @State private var mouseMonitor: Any?
    private func setupMouse() {
        mouseMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved, .leftMouseDragged]) { event in
            mouseXY = event.locationInWindow
            return event
        }
    }
    private func removeMouse() {
        if let monitor = mouseMonitor {
            NSEvent.removeMonitor(monitor)
            mouseMonitor = nil
        }
    }
    
    
    @State private var graphValList: [Double] = []
    @State private var graphTextList: [String] = []
    func graph(maxWidth: CGFloat, maxHeight: CGFloat, barWidth: CGFloat, color: Color, valueCount: Int, maxValue: Double) -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: barWidth / 3.6)
                .strokeBorder(Color.gray, lineWidth: 1)
                .frame(width: maxWidth + 2, height: maxHeight)
                .padding(.bottom, 11.5)
            ForEach(1...3, id: \.self) { index in
                let basePadding: CGFloat = -12.7
                Rectangle()
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .frame(width: maxWidth, height: 1)
                    .padding(.bottom, CGFloat(index) * maxHeight/4 - basePadding)
            }
            
            
            if !graphValList.isEmpty && !graphTextList.isEmpty {
                HStack(alignment: .bottom, spacing: 25) {
                    ForEach(0..<valueCount, id: \.self) { index in
                        let barHeight: CGFloat = (graphValList[index] / maxValue) * maxHeight
                        let barCornerRadius: CGFloat = barWidth / 3.6
                        let barText: String = graphTextList[index]
                        let barValue: String = String("\(Int(graphValList[index]))m")
                        //let barTextPadding: CGFloat = barHeight / 2 + 20
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: barCornerRadius)
                                .frame(width: barWidth, height: barHeight)
                                .foregroundColor(color)
                                .overlay(alignment: .bottom) {
                                    Text(barText)
                                        .foregroundColor(darkMode ? .white : .black)
                                        .frame(width: 50)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .alignmentGuide(.bottom) { dimensions in
                                            dimensions[.top]
                                        }
                                }
                                .overlay(alignment: .bottom) {
                                    Text(barValue)
                                        .foregroundColor(darkMode ? .white : .black)
                                        .frame(width: 50)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .alignmentGuide(.top) { dimensions in
                                            dimensions[.bottom]
                                        }
                                        .padding(.bottom, barHeight)
                                    /*
                                    Rectangle()
                                        .frame(width: barWidth, height: 1)
                                        .foregroundColor(.white)
                                        .alignmentGuide(.top) { dimensions in
                                            dimensions[.bottom]
                                        }
                                        .padding(.bottom, barHeight - 17)
                                     */
                                }
                            
                        }.padding(.vertical, barWidth/4)
                        
                    }
                }
            }
        }
    }
    
    //MARK: SETUP variables
    @State private var startTutor: Bool = true
    
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
            case "black": return Color.black.opacity(elementOpacity + 0.1)
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
    @State private var showingTarget: Int = 0
    @State private var missedTargets: Int = 0
    @State private var timeToHit: [Int] = []
    @State private var targetSpawnDate: Date = Date()
    @State private var slider6Value: Double = 0
    func getTargetPadding(index: Int) -> CGFloat {
        return CGFloat(index * 50)
    }
    func getTargetBarWidth(index: Int) -> CGFloat {
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
        return -116 + CGFloat(Float(avaTimeToHit) / Float(timeToHit.max()!)) * 725
        
    }
    
    //MARK: COLOR variables
    @State private var colorRound: Int = 0
    @State private var colorOffsetEasing: Double = 0
    @State private var colorOffset: Double = 100
    @State private var rightColor: Int = 0
    @State private var colorsList: [Color] = []
    @State private var randomColor: Color = .white
    func makeColorsList(offset: Double) {
        colorsList.removeAll()
        let r = Double.random(in: 50...255)
        let g = Double.random(in: 50...255)
        let b = Double.random(in: 50...255)
        let oa = Int.random(in: 0...2)
        for i in 0..<16 {
            if i == rightColor {
                if oa == 0 {
                    randomColor = Color(
                        red: (r - offset)/255,
                        green: g/255,
                        blue: b/255
                    )
                } else if oa == 1 {
                    randomColor = Color(
                        red: r/255,
                        green: (g - offset)/255,
                        blue: b/255
                    )
                } else {
                    randomColor = Color(
                        red: r / 255,
                        green: g/255,
                        blue: (b - offset)/255
                    )
                }
            } else {
                randomColor = Color(red: r/255, green: g/255, blue: b/255)
            }
            colorsList.append(randomColor)
        }
    }
    
    //MARK: PICKER variables
    
    var pickerOffsetText: String {
        String("\(pickerOffsets[pickerRound])%")
    }
    
    //MARK: Typing variables
    @State private var randomSentences: [String] = [
        "This is a random sentence for the typing test.",
        "There is a dog that floats up in the sky.",
        "No man ever has fallen into a manhole cover.",
        "USB cable transferes data and can even charge your phone.",
        "Debugging is like detective solving his own crime.",
        "The instructions for the project are attached to this email.",
        "The value of variables can change over time.",
        //"Tuples can be used by functions to return multiple pieces of data at once.",
        "For in loops iterate over a sequence of values.",
        "Adding an exclamation mark is force unwrapping in swift.",
        "Tomorows weather is not looking good acording to Windy."
        //"Variables and constants are always initialized and array bounds are always checked."
    ]
    
    //MARK: LOG LISTS
    
    
    @AppStorage("spamLogDates") private var spamLogDates: [String] = []
    @AppStorage("spamLogValues") private var spamLogValues: [String] = []
    @AppStorage("spamLogDurations") private var spamLogDurations: [String] = []
    
    @AppStorage("reactLogDates") private var reactLogDates: [String] = []
    @AppStorage("reactLogBestV") private var reactLogBestV: [String] = []
    @AppStorage("reactLogAvaV") private var reactLogAvaV: [String] = []
    @AppStorage("reactLogWorstV") private var reactLogWorstV: [String] = []
    
    @AppStorage("timeLogDates") private var timeLogDates: [String] = []
    @AppStorage("timeLogValues") private var timeLogValues: [String] = []
    
    @AppStorage("aimLogDates") private var aimLogDates: [String] = []
    @AppStorage("aimLogBestV") private var aimLogBestV: [String] = []
    @AppStorage("aimLogWorstV") private var aimLogWorstV: [String] = []
    @AppStorage("aimLogAvaV") private var aimLogAvaV: [String] = []
    
    @AppStorage("memoryLogDates") private var memoryLogDates: [String] = []
    @AppStorage("memoryLogValues") private var memoryLogValues: [String] = []
    
    @AppStorage("colorLogDates") private var colorLogDates: [String] = []
    @AppStorage("colorLogValues") private var colorLogValues: [String] = []
    
    @AppStorage("pickerLogDates") private var pickerLogDates: [String] = []
    @AppStorage("pickerLogBestV") private var pickerLogBestV: [String] = []
    @AppStorage("pickerLogWorstV") private var pickerLogWorstV: [String] = []
    @AppStorage("pickerLogAvaV") private var pickerLogAvaV: [String] = []
    
    @AppStorage("typeLogValues") private var typeLogValues: [String] = []
    @AppStorage("typeLogDates") private var typeLogDates: [String] = []
    
    
    @AppStorage("resetetST") private var screenTimeReseted: Bool = true
    @State private var previousDate: Date = Date()
    @State private var signalTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("STmon") private var screenTimeMon: [Int] = []
    @AppStorage("STtue") private var screenTimeTue: [Int] = []
    @AppStorage("STwed") private var screenTimeWed: [Int] = []
    @AppStorage("STthu") private var screenTimeThu: [Int] = []
    @AppStorage("STfri") private var screenTimeFri: [Int] = []
    @AppStorage("STsat") private var screenTimeSat: [Int] = []
    @AppStorage("STsun") private var screenTimeSun: [Int] = []
    
    @AppStorage("streak") private var userStreaks: [Int] = []
    @AppStorage("lastStreak") private var lastStreakDays: [Int] = [6, 6, 6, 6, 6]
    
    func getScreenTimeAvarage() -> String {
        guard userLoggedIn < 100, !graphValList.isEmpty else {return "error"}
        let timeAva: Double = Double((screenTimeMon[userLoggedIn] + screenTimeTue[userLoggedIn] + screenTimeWed[userLoggedIn] + screenTimeThu[userLoggedIn] + screenTimeFri[userLoggedIn] + screenTimeSat[userLoggedIn] + screenTimeSun[userLoggedIn])/(screenTimeMon.count-1))
        
        if timeAva < 60 {
            return "\(timeAva) min."
        } else {
            let h = floor(timeAva/60)
            let m = timeAva - h*60
            return "\(Int(h))h \(Int(m))m"
        }
    }
    
    func dayOfWeek(day: Int) -> String {
        switch day {
        case 0: return "Mon"
        case 1: return "Tue"
        case 2: return "Wed"
        case 3: return "Thu"
        case 4: return "Fri"
        case 5: return "Sat"
        case 6: return "Sun"
        default: return "Err"
        }
    }
    func dayOfWeekNum(day: String) -> Int {
        switch day {
        case "Mon": return 0
        case "Tue": return 1
        case "Wed": return 2
        case "Thu": return 3
        case "Fri": return 4
        case "Sat": return 5
        case "Sun": return 6
        default: return 7
        }
    }
    
    private static let logDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd. MM. HH:mm"
        return formatter
    }()
    let formattedDate = Self.logDateFormat.string(from: Date())
        
    
    //TIMER BELOW
    @State private var timeElapsed = 0
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    var timeElapsedText: String {
        String(format: "%.2f", Double(timeElapsed) / 1000)
    }
    
    //MARK: NAVIGATION bar
    func navigationBar(kind: String) -> some View {
        ZStack {
            if kind == "start" {
                ZStack {
                    if !state.hasSuffix("M") && !state.hasSuffix("C") && !state.hasSuffix("P") && !state.hasSuffix("X") {
                        Button(action: {
                            slider3Value = Double(testCountGoal)
                            state = "settings \(state.suffix(1))"
                            print("sending user to settings \(slider3Value)")
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
                    }
                    
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
                        makeCurrentUserLog(log: String(state.suffix(1)), user: userLoggedIn)
                        state = "log \(state.suffix(1))"
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
            } else if kind == "results" {
                ZStack {
                    Button(action: {
                        state = "start \(state.suffix(1))"
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
                        makeCurrentUserLog(log: String(state.suffix(1)), user: userLoggedIn)
                        state = "log \(state.suffix(1))"
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
            } else if kind == "log" {
                ZStack {
                    Button(action: {
                        print(sentFrom)
                        if sentFrom == "results \(state.suffix(1))" {
                            state = "results \(state.suffix(1))"
                        } else if sentFrom == "start \(state.suffix(1))" {
                            state = "start \(state.suffix(1))"
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
                        deleteUserLog(log: String(state.suffix(1)), user: userLoggedIn)
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
            } else {
                EmptyView()
            }
        }
    }
    
    
    //MARK: - FUNCTIONS BELOW
    func startTest(name: String) -> String {
        
        return "0"
    }
    
    func userInLog(pos: Int) -> Int {
        return (pos + 1) * 2 - 1
    }
    func valueInLog(pos: Int) -> Int {
        return (pos + 1) * 2 - 2
    }
    //MARK: deleteUser
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
        screenTimeMon.remove(at: user)
        screenTimeTue.remove(at: user)
        screenTimeWed.remove(at: user)
        screenTimeThu.remove(at: user)
        screenTimeFri.remove(at: user)
        screenTimeSat.remove(at: user)
        screenTimeSun.remove(at: user)
        lastStreakDays.remove(at: user)
        userStreaks.remove(at: user)
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
        if log == "S" {
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
        } else if log == "R" {
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
        } else if log == "T" {
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
        } else if log == "A" {
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
        } else if log == "M" {
            while idx != memoryLogDates.count/2 {
                if memoryLogDates[userInLog(pos: idx)] != String(user) {
                    idx += 1
                } else {
                    memoryLogDates.remove(at: valueInLog(pos: idx))
                    memoryLogDates.remove(at: valueInLog(pos: idx))
                    memoryLogValues.remove(at: valueInLog(pos: idx))
                    memoryLogValues.remove(at: valueInLog(pos: idx))
                }
            }
        } else if log == "C" {
            while idx != colorLogDates.count/2 {
                if colorLogDates[userInLog(pos: idx)] != String(user) {
                    idx += 1
                } else {
                    colorLogDates.remove(at: valueInLog(pos: idx))
                    colorLogDates.remove(at: valueInLog(pos: idx))
                    colorLogValues.remove(at: valueInLog(pos: idx))
                    colorLogValues.remove(at: valueInLog(pos: idx))
                }
            }
        } else if log == "A" {
            while idx != pickerLogDates.count/2 {
                if pickerLogDates[userInLog(pos: idx)] != String(user) {
                    idx += 1
                } else {
                    pickerLogBestV.remove(at: valueInLog(pos: idx))
                    pickerLogBestV.remove(at: valueInLog(pos: idx))
                    pickerLogWorstV.remove(at: valueInLog(pos: idx))
                    pickerLogWorstV.remove(at: valueInLog(pos: idx))
                    pickerLogAvaV.remove(at: valueInLog(pos: idx))
                    pickerLogAvaV.remove(at: valueInLog(pos: idx))
                    pickerLogDates.remove(at: valueInLog(pos: idx))
                    pickerLogDates.remove(at: valueInLog(pos: idx))
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
    //MARK: makeCurrentLog
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
        if log == "S" {
            while idx != spamLogDates.count/2 {
                if spamLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(spamLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(spamLogValues[valueInLog(pos: idx)])
                    currentLogVal2.append(spamLogDurations[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "R" {
            while idx != reactLogDates.count/2 {
                if reactLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(reactLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(reactLogBestV[valueInLog(pos: idx)])
                    currentLogVal2.append(reactLogWorstV[valueInLog(pos: idx)])
                    currentLogVal3.append(reactLogAvaV[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "T" {
            while idx != timeLogDates.count/2 {
                if timeLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(timeLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(timeLogValues[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "A" {
            while idx != aimLogDates.count/2 {
                if aimLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(aimLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(aimLogBestV[valueInLog(pos: idx)])
                    currentLogVal2.append(aimLogWorstV[valueInLog(pos: idx)])
                    currentLogVal3.append(aimLogAvaV[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "M" {
            while idx != memoryLogDates.count/2 {
                if memoryLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(memoryLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(memoryLogValues[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "C" {
            while idx != colorLogDates.count/2 {
                if colorLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(colorLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(colorLogValues[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "P" {
            while idx != pickerLogDates.count/2 {
                if pickerLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(pickerLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(pickerLogBestV[valueInLog(pos: idx)])
                    currentLogVal2.append(pickerLogWorstV[valueInLog(pos: idx)])
                    currentLogVal3.append(pickerLogAvaV[valueInLog(pos: idx)])
                }
                idx += 1
            }
        } else if log == "X" {
            while idx != typeLogDates.count/2 {
                if typeLogDates[userInLog(pos: idx)] == String(user) {
                    currentLogDates.append(typeLogDates[valueInLog(pos: idx)])
                    currentLogVal1.append(typeLogValues[valueInLog(pos: idx)])
                }
                idx += 1
            }
        }
    }
    //MARK: clearAllLogs
    
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
        
        memoryLogDates.removeAll()
        memoryLogValues.removeAll()
        
        colorLogDates.removeAll()
        colorLogValues.removeAll()
    }
    
    //MARK: makeLogLeaderboard
    @State private var bestSpamValues: [Int] = []
    @State private var bestReactValues: [Int] = []
    @State private var bestTimeValues: [Double] = []
    @State private var bestAimValues: [Int] = []
    @State private var bestMemoryValues: [Int] = []
    @State private var bestColorValues: [Int] = []
    @State private var bestPickerValues: [Int] = []
    @State private var bestTypeValues: [Double] = []
    
    @State private var spamLeaderboard: [Int] = []
    @State private var reactLeaderboard: [Int] = []
    @State private var timeLeaderboard: [Double] = []
    @State private var aimLeaderboard: [Int] = []
    @State private var memoryLeaderboard: [Int] = []
    @State private var colorLeaderboard: [Int] = []
    @State private var pickerLeaderboard: [Int] = []
    @State private var typeLeaderboard: [Double] = []
    
    func makeLogLeaderboard(mode: String) {
        if mode == "spam" {
            bestSpamValues.removeAll()
            spamLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "S", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestSpamValues.append(Int(currentLogVal1.max()!)!)
                } else { bestSpamValues.append(0 - user) }
            }
            spamLeaderboard = bestSpamValues.sorted(by: >)
            print("Best values: \(bestSpamValues)")
            print("Leaderboard: \(spamLeaderboard)")
            
        } else if mode == "react" {
            bestReactValues.removeAll()
            reactLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "R", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestReactValues.append(Int(currentLogVal1.min()!) ?? 67)
                } else { bestReactValues.append(100000 + user) }
            }
            reactLeaderboard = bestReactValues.sorted()
            print("Best values: \(bestReactValues)")
            print("Leaderboard: \(reactLeaderboard)")
        } else if mode == "time" {
            bestTimeValues.removeAll()
            timeLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "T", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestTimeValues.append(floor(100*Double(currentLogVal1.min()!)!)/100)
                } else { bestTimeValues.append(Double(100000 + user)) }
            }
            timeLeaderboard = bestTimeValues.sorted()
            print("Best values: \(bestTimeValues)")
            print("Leaderboard: \(timeLeaderboard)")
        } else if mode == "aim" {
            bestAimValues.removeAll()
            aimLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "A", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestAimValues.append(Int(currentLogVal1.min()!)!)
                } else { bestAimValues.append(100000 + user) }
            }
            aimLeaderboard = bestAimValues.sorted()
            print("Best values: \(bestAimValues)")
            print("Leaderboard: \(aimLeaderboard)")
        } else if mode == "memory" {
            bestMemoryValues.removeAll()
            memoryLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "M", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestMemoryValues.append(Int(currentLogVal1.max()!)!)
                } else { bestMemoryValues.append(0 - user)}
            }
            memoryLeaderboard = bestMemoryValues.sorted(by: >)
            print("Best values: \(bestMemoryValues)")
            print("Leaderboard: \(memoryLeaderboard)")
        }  else if mode == "color" {
            bestColorValues.removeAll()
            colorLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "C", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestColorValues.append(Int(currentLogVal1.max()!)!)
                } else { bestColorValues.append(0 - user)}
            }
            colorLeaderboard = bestColorValues.sorted(by: >)
            print("Best values: \(bestColorValues)")
            print("Leaderboard: \(colorLeaderboard)")
        } else if mode == "picker" {
            print("PICKER")
            bestPickerValues.removeAll()
            pickerLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "P", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestPickerValues.append(Int(Double(currentLogVal1.max()!)!))
                } else { bestPickerValues.append(0 - user) }
            }
            pickerLeaderboard = bestPickerValues.sorted(by: >)
            print("Best values: \(bestPickerValues)")
            print("Leaderboard: \(pickerLeaderboard)")
        } else if mode == "type" {
            print("TYPING")
            bestTypeValues.removeAll()
            typeLeaderboard.removeAll()
            for user in 0...userNames.count - 1 {
                makeCurrentUserLog(log: "X", user: user)
                print("Curren log for user\(user): \(currentLogVal1)")
                if !currentLogVal1.isEmpty {
                    bestTypeValues.append(floor(100*Double(currentLogVal1.max()!)!)/100)
                    print("Added \(floor(100*Double(currentLogVal1.max()!)!)/100)")
                } else { bestTypeValues.append(0.0 - Double(user)) }
            }
            typeLeaderboard = bestTypeValues.sorted(by: >)
            print("Best values: \(bestTypeValues)")
            print("Leaderboard: \(typeLeaderboard)")
        }
    }
    @State private var usersBest: String = ""
    @State private var soloBestValue: [Int] = []
    @State private var soloBestMode: String = ""
    func makeUsersBest(user: Int) {
        print("Making users best for user \(userNames[user])")
        soloBestValue.removeAll()
        makeLogLeaderboard(mode: "spam")
        makeLogLeaderboard(mode: "react")
        makeLogLeaderboard(mode: "time")
        makeLogLeaderboard(mode: "aim")
        makeLogLeaderboard(mode: "memory")
        makeLogLeaderboard(mode: "color")
        makeLogLeaderboard(mode: "picker")
        makeLogLeaderboard(mode: "type")
        soloBestValue.append(spamLeaderboard.firstIndex(of: bestSpamValues[user])!)
        soloBestValue.append(reactLeaderboard.firstIndex(of: bestReactValues[user])!)
        soloBestValue.append(timeLeaderboard.firstIndex(of: bestTimeValues[user])!)
        soloBestValue.append(aimLeaderboard.firstIndex(of: bestAimValues[user])!)
        soloBestValue.append(memoryLeaderboard.firstIndex(of: bestMemoryValues[user])!)
        soloBestValue.append(colorLeaderboard.firstIndex(of: bestColorValues[user])!)
        soloBestValue.append(typeLeaderboard.firstIndex(of: bestTypeValues[user])!)
        let indexPos = soloBestValue.firstIndex(of: soloBestValue.min()!)
        if indexPos == 0 {
            soloBestMode = "spam"
        } else if indexPos == 1 {
            soloBestMode = "react"
        } else if indexPos == 2 {
            soloBestMode = "time"
        } else if indexPos == 3 {
            soloBestMode = "aim"
        } else if indexPos == 4 {
            soloBestMode = "memory"
        } else if indexPos == 5 {
            soloBestMode = "color"
        } else if indexPos == 6 {
            soloBestMode = "picker"
        } else if indexPos == 7 {
            soloBestMode = "typing"
        }
        usersBest = String("#\(soloBestValue.min()! + 1) in \(soloBestMode)")
        print("UsersBest: \(usersBest)")
    }
    
    //MARK: writeToLog
    func writeToLog(log: String) {
        if log == "aim" {
            aimLogDates.append(formattedDate)
            aimLogDates.append(String(userLoggedIn))
            aimLogBestV.append(String(timeToHit.min()!))
            aimLogBestV.append(String(userLoggedIn))
            aimLogWorstV.append(String(timeToHit.max()!))
            aimLogWorstV.append(String(userLoggedIn))
            aimLogAvaV.append(String(avaTimeToHit))
            aimLogAvaV.append(String(userLoggedIn))
            print("Added everything into aim logs")
        } else if log == "memory" {
            memoryLogDates.append(formattedDate)
            memoryLogDates.append(String(userLoggedIn))
            memoryLogValues.append(String(squareCount - 1))
            memoryLogValues.append(String(userLoggedIn))
            print("Added everything into memory logs")
            print(memoryLogDates)
            print(memoryLogValues)
        } else if log == "color" {
            colorLogDates.append(formattedDate)
            colorLogDates.append(String(userLoggedIn))
            colorLogValues.append(String(colorRound))
            colorLogValues.append(String(userLoggedIn))
            print("Added everything into color logs")
        } else if log == "picker" {
            pickerLogDates.append(formattedDate)
            pickerLogDates.append(String(userLoggedIn))
            pickerLogBestV.append(String(format: "%.2f", round(pickerOffsets.min()! * 100)/100))
            pickerLogBestV.append(String(userLoggedIn))
            pickerLogWorstV.append(String(format: "%.2f", round(pickerOffsets.max()! * 100)/100))
            pickerLogWorstV.append(String(userLoggedIn))
            pickerLogAvaV.append(String(format: "%.2f", round(pickerOffsets.reduce(0.0, +)/Double(pickerOffsets.count) * 100)/100))
            pickerLogAvaV.append(String(userLoggedIn))
            print("Added everything into picker logs")
        } else if log == "type" {
            typeLogDates.append(formattedDate)
            typeLogDates.append(String(userLoggedIn))
            typeLogValues.append(String(avgLpsText))
            typeLogValues.append(String(userLoggedIn))
            print("Added everything into color logs")
        }
    }
    func manageStreaks() {
        if lastStreakDays[userLoggedIn] + 1 == dayOfWeekNum(day: Date().weekDay) || lastStreakDays[userLoggedIn] == dayOfWeekNum(day: Date().weekDay) + 6{
            lastStreakDays[userLoggedIn] = dayOfWeekNum(day: Date().weekDay)
            userStreaks[userLoggedIn] = userStreaks[userLoggedIn] + 1
            print("Added a streak to \(userNames[userLoggedIn])")
        } else if abs(lastStreakDays[userLoggedIn] - dayOfWeekNum(day: Date().weekDay)) > 1 {
            print("(\(abs(lastStreakDays[userLoggedIn] - dayOfWeekNum(day: Date().weekDay))) > 1)")
            lastStreakDays[userLoggedIn] = dayOfWeekNum(day: Date().weekDay)
            userStreaks[userLoggedIn] = 0
            print("Removed streak from \(userNames[userLoggedIn])")
            
        } else {
            print("Didnt do anything with \(userNames[userLoggedIn])'s streak bcs the day is same as the day the streak was added")
            print(lastStreakDays)
            print(userStreaks)
        }
    }
    
    //MARK: - MENU
    
    let menuButtonSpacing: CGFloat = 18
    var menuView: some View {
        ZStack {
            //SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
            if state == "menu" {
                
                    Text("Menu")
                        .bold()
                        .foregroundColor(getProfileColor(index: userLoggedIn))
                        .font(.system(size: 61, weight: .bold, design: .default))
                        .padding(.bottom, 581)
                        .onAppear() {print("default menu text")}

                ScrollView(showsIndicators: false) {
                    VStack (spacing: menuButtonSpacing - 140) {
                        HStack (alignment: .top, spacing: menuButtonSpacing) {
                            Button(action: {
                                print("clicked button 1 (Reflex)")
                                state = "start R"
                            }) {
                                Image(systemName: "cursorarrow.rays")
                                    .font(.system(size: 81, weight: .bold, design: .default))
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(alignment: .bottom) {
                                        Text("Spam")
                                            .bold()
                                            .padding(.top, 130)
                                            .font(.title2)
                                            .frame(width: 200, height: 200)
                                            .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                    }
                            }.buttonStyle(.plain)
                                    .padding(.bottom, 140)
                            
                            Button(action: {
                                print("clicked button 2")
                                state = "start S"
                            }) {
                                Image(systemName: "cursorarrow.motionlines")
                                    .font(.system(size: 76, weight: .bold, design: .default))
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(alignment: .bottom) {
                                        Text("Spam")
                                            .bold()
                                            .padding(.top, 130)
                                            .font(.title2)
                                            .frame(width: 200, height: 200)
                                            .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                            
                                    }
                            }.buttonStyle(.plain)
                                .padding(.bottom, 140)
                            
                            Button(action: {
                                print("clicked button 3")
                                state = "start T"
                            }) {
                                Image(systemName: "timer")
                                    .font(.system(size: 76, weight: .bold, design: .default))
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(alignment: .bottom) {
                                        Text("Timer")
                                            .bold()
                                            .padding(.top, 130)
                                            .font(.title2)
                                            .frame(width: 200, height: 200)
                                            .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                            
                                    }
                                
                            }.buttonStyle(.plain)
                                .padding(.bottom, 140)
                        }.padding(.top, 20)
                        
                        HStack (alignment: .top, spacing: menuButtonSpacing) {
                            Button(action: {
                                print("clicked button 4")
                                state = "start A"
                            }) {
                                Image(systemName: "dot.circle.and.cursorarrow")
                                    .font(.system(size: 76, weight: .bold, design: .default))
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(alignment: .bottom) {
                                        Text("Aim")
                                            .bold()
                                            .padding(.top, 130)
                                            .font(.title2)
                                            .frame(width: 200, height: 200)
                                            .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                            
                                    }
                                
                            }.buttonStyle(.plain)
                            .padding(.bottom, 140)
                            Button(action: {
                                print("clicked button 5")
                                state = "start M"
                            }) {
                                Image(systemName: "square.grid.3x3.topleft.filled")
                                    .font(.system(size: 76, weight: .bold, design: .default))
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(alignment: .bottom) {
                                        Text("Memory")
                                            .bold()
                                            .padding(.top, 130)
                                            .font(.title2)
                                            .frame(width: 200, height: 200)
                                            .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                            
                                    }
                                
                            }.buttonStyle(.plain)
                            .padding(.bottom, 140)
                            Button(action: {
                                print("clicked button 6")
                                colorOffset = 100
                                colorOffsetEasing = 0
                                colorRound = 0
                                state = "start C"
                            }) {
                                Image(systemName: "square.grid.3x3.bottomright.filled")
                                    .font(.system(size: 76, weight: .bold, design: .default))
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(alignment: .bottom) {
                                        Text("Color")
                                            .bold()
                                            .padding(.top, 130)
                                            .font(.title2)
                                            .frame(width: 200, height: 200)
                                            .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                            
                                    }
                                
                            }.buttonStyle(.plain)
                            .padding(.bottom, 140)
                        }
                        HStack (alignment: .top, spacing: menuButtonSpacing) {
                            Button(action: {
                                print("clicked button 7")
                                state = "start P"
                            }) {
                                Image(systemName: "eyedropper.halffull")
                                    .font(.system(size: 76, weight: .bold, design: .default))
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(alignment: .bottom) {
                                        Text("Picker")
                                            .bold()
                                            .padding(.top, 130)
                                            .font(.title2)
                                            .frame(width: 200, height: 200)
                                            .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
                                            //.background(getProfileColor(index: userLoggedIn))
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                    }
                            }.buttonStyle(.plain)
                                .padding(.bottom, 140)
                                //.padding(.trailing, menuButtonSpacing)
                            
                            Button(action: {
                                print("clicked button 8")
                                state = "start X"
                            }) {
                                Image(systemName: "character.cursor.ibeam")
                                    .font(.system(size: 76, weight: .bold, design: .default))
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                                    .background(getProfileColor(index: userLoggedIn))
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .overlay(alignment: .bottom) {
                                        Text("Typing")
                                            .bold()
                                            .padding(.top, 130)
                                            .font(.title2)
                                            .frame(width: 200, height: 200)
                                            .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
                                            //.background(getProfileColor(index: userLoggedIn))
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                            
                                    }
                            }.buttonStyle(.plain)
                                .padding(.bottom, 140)
                                .padding(.trailing, 200 + menuButtonSpacing)
                        }
                        
                        
                    }.navigationTitle("Menu")
                        .onAppear() {
                            print("DATE: \(formattedDate)")
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
                            print("MEMORY")
                            makeLogLeaderboard(mode: "memory")
                            print("COLOR")
                            makeLogLeaderboard(mode: "color")
                            print("PICKER")
                            makeLogLeaderboard(mode: "picker")
                            print("TYPING")
                            makeLogLeaderboard(mode: "type")
                            
                        }
                    
                }.frame(width: 635, height: 450)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .padding(.bottom, 40)
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
                        .foregroundColor(darkMode ? textColor.opacity(0.8) : .white)
                        .frame(width: 70, height: 70)
                        .background(getProfileColor(index: userLoggedIn))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                }.buttonStyle(.plain)
                    .padding(.top, 490)
                    .padding(.trailing, 590)
                if startTutor {
                    Text("Scroll down")
                        .font(.title2)
                        .padding(.top, 460)
                    Image(systemName: "arrow.down")
                        .font(.title2)
                        .padding(.top, 500)
                }
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
                            spamLogDates.append(formattedDate)
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
                    
                    navigationBar(kind: "start")
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
                navigationBar(kind: "results")
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
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("\(currentLogVal1[index]) cps. (\(currentLogVal2[index])) s.)")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.trailing, 40)
                                    }.onAppear() {
                                        
                                    }
                                
                                }.onAppear() {
                                    print("Im line number \(index), returned: \(userInLog(pos: index)) ")
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.frame(height: 400)

                } else {
                    Text("No log stored.")
                        .font(.title2)
                }
                
                navigationBar(kind: "log")
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
                    
                    
                    navigationBar(kind: "start")
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
                            reactLogDates.append(formattedDate);
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
                    
                    navigationBar(kind: "results")
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
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("Best: \(currentLogVal1[index]) ms. Avarge: \(currentLogVal3[index]) ms. Worst: \(currentLogVal2[index]) ms.")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
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
                
                navigationBar(kind: "log")
            }
        }
    }
    
    //MARK: Time - start
    @State private var timerStartDate: Date = Date()
    var timerText: String {
        String(format: "%.2f", Double(Date().timeIntervalSince(timerStartDate)*100)/100)
    }
    
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
                    
                    navigationBar(kind: "start")
                }
            }
            
            //MARK: Time - target time
            if state == "make time T" {
                ZStack {
                    Button(action: {
                        state = "count T"
                        timeElapsed = 0
                        timerStartDate = Date()
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
                    print(timerText)
                    timeStopped = Int(Double(timerText)! * 1000)
                    timeLogDates.append(Date().formatted(date: .omitted, time: .standard));
                    timeLogValues.append(String(timeStopped))
                    
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
                    Text("\(timerText) s.")
                        .font(.system(size: 80, weight: .bold, design: .default))
                        .foregroundColor(.white)
                }
            }
            
            if state == "stopped T" {
                Button(action: {
                    state = "results T"
                }) {
                    Text("\(timeStopped) s.")
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
                    
                    Text("You stopped at")
                        .padding(.bottom, 45)
                    Text("\(timeStopped) / \(randomTimeText) s.")
                        .bold()
                        .font(.largeTitle)
                    Text("Difference: \(timeDifferenceText) s.")
                        .padding(.top, 45)
                    
                    navigationBar(kind: "results")
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
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("\(currentLogVal1[index]) second difference. ")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
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
                
                navigationBar(kind: "log")
            }
        }
    }
    
    
    //MARK: Start Aim
    
    
    var aimView: some View {
        ZStack {
            if state == "start A" {
                Button(action: {
                    showingTarget = 0
                    missedTargets = 0
                    print(timeToHit)
                    timeToHit.removeAll()
                    print(timeToHit)
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
                
                
                navigationBar(kind: "start")
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
                    print(timeToHit)
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
                                    print(timeToHit)
                                } else {
                                    state = "end A"
                                    Task {
                                        try? await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
                                        state = "results A"
                                        writeToLog(log: "aim")
                                        //makeCurrentUserLog(log: "aim", user: userLoggedIn)
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
                    VStack {
                        ForEach(0..<timeToHit.count, id: \.self) { index in
                            ZStack {
                                Text("\(index + 1). Target:")
                                    .foregroundColor(getTargetColor(index: index))
                                    .font(.title2)
                                    .padding(.trailing, 500)
                                    //.padding(.top, getTargetPadding(index: index))
                                Text("\(timeToHit[index]) ms.")
                                    .foregroundColor(getTargetColor(index: index))
                                    .font(.title2)
                                    .padding(.trailing, 300)
                                    //.padding(.top, getTargetPadding(index: index))
                                    .onAppear() {
                                        print(timeToHit)
                                    }
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(getTargetColor(index: index))
                                    .frame(width: getTargetBarWidth(index: index), height: 15)
                                    //.padding(.top, getTargetPadding(index: index))
                                    .padding(.leading, getTargetBarWidth(index: index) - 180)
                            }
                        }
                         
                    }.padding(.bottom, 150)
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
                    
                    navigationBar(kind: "results")
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
                                            .foregroundColor(darkMode ? .white : .black)
                                        Spacer()
                                        
                                        Text("Best: \(currentLogVal1[index]), Worst: \(currentLogVal2[index]), Avarage:  \(currentLogVal3[index])")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .padding(.trailing, 40)
                                            .foregroundColor(darkMode ? .white : .black)
                                        
                                    }
                                }
                            }
                        } else {
                            Text("No log stored")
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(height: 400)
                
                navigationBar(kind: "log")
            }
           
            
        }
    }
    
    //MARK: Memory - declarations
    @State private var squareCount: Int = 0
    @State private var squareAnswers: [Int] = []
    @State private var squareQuestions: [Int] = []
    @State private var valsReplaced: [Int] = []
    @State private var randInt: Int = 0
    @State private var regenerate: Bool = false
    @State private var squareRowCount: Int = 0
    func generateSquaresList(count: Int, rows: Int) {
        let posCount = rows * rows - 1
        squareAnswers.removeAll()
        squareQuestions.removeAll()
        valsReplaced.removeAll()
        for _ in 0...posCount {
            squareAnswers.append(0)
            squareQuestions.append(0)
        }
        for _ in 0...count - 1 {
            randInt = Int.random(in: 0...posCount)
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
                        randInt = Int.random(in: 0...posCount)
                    }
                }
            } else {
                print("Changed random position")
                squareAnswers[randInt] = 1
                valsReplaced.append(randInt)
            }
        }
    }
    func getSelectButtonColor(idx: Int, phase: String) -> Color {
        if phase == "guessed M" {
            if squareQuestions[idx] == squareAnswers[idx] && squareQuestions[idx] == 1{
                return Color.white //green
            } else if squareQuestions[idx] != squareAnswers[idx] && squareQuestions[idx] == 1 {
                return Color.red
            } else if squareQuestions[idx] != squareAnswers[idx] && squareQuestions[idx] == 0 {
                return Color.white
            } else {
                return Color.gray.opacity(elementOpacity)
            }
        } else if phase == "showing M" {
            if squareAnswers[idx] == 1 {
                return Color.white
            } else {
                return Color.gray.opacity(elementOpacity)
            }
        } else if phase == "guessing M" {
            if squareQuestions[idx] == 1 {
                return Color.white
            } else {
                return Color.gray.opacity(elementOpacity)
            }
        } else if phase == "guess C" {
            return colorsList[idx]
        } else if phase == "guessed C" {
            if idx == rightColor {
                return .black
            } else {
                return .black
            }
        } else {
            return Color.purple
        }
    }
    
    func buttonGrid(x: Int, y: Int, phase: String) -> some View {
        ZStack (alignment: .topLeading) {
            let numberOfButtons = x*y - 1
            ForEach(0...numberOfButtons, id: \.self) {index in
                let column = index % x
                let row = index / x
                let BS = 500 / x
                let BP = BS + 5
                
                Button(action: {
                    if phase == "showing M" || phase == "guessed M" {
                        
                    } else if phase == "guessing M" {
                        if squareQuestions[index] == 0 {
                            squareQuestions[index] = 1
                        } else {
                            squareQuestions[index] = 0
                        }
                    }  else if phase == "guess C" {
                        if index == rightColor {
                            print("Passed round \(colorRound) with offset \(colorOffset).")
                            state = "guessed C"
                            colorRound += 1
                            Task {
                                if colorOffset > 2 {
                                    colorOffset -= 10 - colorOffsetEasing
                                }
                                if colorOffsetEasing < 9 {
                                    colorOffsetEasing += 1
                                }
                                rightColor = Int.random(in: 0...15)
                                makeColorsList(offset: colorOffset)
                                print("Next up is button \(rightColor); offset \(colorOffset).")
                                try? await Task.sleep(nanoseconds: UInt64(0.25 * 1_000_000_000))
                                state = "guess C"
                            }
                        } else {
                            writeToLog(log: "color")
                            state = "results C"
                        }
                    }
                }) {
                    Text("")
                        .frame(width: CGFloat(BS), height: CGFloat(BS))
                        .font(.largeTitle)
                        .background(getSelectButtonColor(idx: index, phase: phase))
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat(25 - x)))
                }.buttonStyle(.plain)
                    .padding(.leading, CGFloat(column * BP))
                    .padding(.top, CGFloat(row * BP))
            }
        }.padding(.bottom, 50)
            .padding(.leading, 0)
    }
    //MARK: Memory - start
    
    
    var memoryView: some View {
        ZStack {
            if state == "start M" {
                Button(action: {
                    squareCount = 1
                    squareRowCount = 5
                    generateSquaresList(count: squareCount, rows: squareRowCount)
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
                
                navigationBar(kind: "start")
            }
            
            if state == "showing M" {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue.opacity(bgOpacity))
                        .frame(width: 700, height: 650)
                        .ignoresSafeArea()
                    
                    buttonGrid(x: squareRowCount, y: squareRowCount, phase: state)
                    
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
                    
                    buttonGrid(x: squareRowCount, y: squareRowCount, phase: state)
                    
                    Button(action: {
                        state = "guessed M"
                    }) {
                        Text("Check")
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
                    if squareQuestions == squareAnswers {
                        Rectangle()
                            .frame(width: 700, height: 650)
                            .foregroundColor(.green.opacity(bgOpacity))
                            .ignoresSafeArea()
                    } else {
                        Rectangle()
                            .frame(width: 700, height: 650)
                            .foregroundColor(.red.opacity(bgOpacity))
                            .ignoresSafeArea()
                    }
                    
                    buttonGrid(x: squareRowCount, y: squareRowCount, phase: state)
                    
                    Button(action: {
                        if squareQuestions == squareAnswers {
                            squareCount += 1
                            if squareCount >= (squareRowCount * squareRowCount) / 2 {
                                squareRowCount += 1
                            }
                            generateSquaresList(count: squareCount, rows: squareRowCount)
                            print("all good, starting new round with \(squareCount) squares")
                            state = "showing M"
                        } else {
                            print("no good, sending to results")
                            state = "results M"
                            
                            writeToLog(log: "memory")
                            
                        }
                    }) {
                        if squareQuestions == squareAnswers {
                            Text("Next round  \(squareCount).")
                                .font(.largeTitle)
                                .frame(width: 225, height: 50)
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                        } else {
                            Text("Results.")
                                .font(.largeTitle)
                                .frame(width: 225, height: 50)
                                .background(Color.black.opacity(elementOpacity))
                                .clipShape(Capsule())
                        }
                    }.buttonStyle(.plain)
                        .padding(.top, 530)
                }
            }
            
            if state == "end M" {
                
            }
            
            if state == "results M" {
                Text("You memorized \(squareCount - 1) squares.")
                    .font(.largeTitle)
                    .bold()
                
                navigationBar(kind: "results")
            }
            //MARK: Memory - log
            
            if state == "log M" {
                if !currentLogDates.isEmpty {
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
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("\(currentLogVal1[index]) squares memorized.")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
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
                
                navigationBar(kind: "log")
            }
        }
    }
    
    //MARK: Color - start
    
    
    var colorView: some View {
        ZStack {
            if state == "start C" {
                Button(action: {
                    rightColor = Int.random(in: 0...15)
                    makeColorsList(offset: colorOffset)
                    
                    state = "guess C"
                }) {
                    Text("Start")
                        .font(.largeTitle)
                        .bold()
                        .frame(width: 700, height: 650)
                        .background(Color.green.opacity(bgOpacity))
                        .clipShape(Rectangle())
                }.buttonStyle(.plain)
                    .ignoresSafeArea()
                
                navigationBar(kind: "start")
            }
            
            if state == "guess C" {
                Rectangle()
                    .frame(width: 700, height: 650)
                    .foregroundColor(Color.black.opacity(bgOpacity))
                    .ignoresSafeArea()
                buttonGrid(x: 4, y: 4, phase: "guess C")
                Text("Round \(colorRound).")
                    .font(.title2)
                    .padding(.top, 520)
            }
            
            if state == "guessed C" {
                Rectangle()
                    .frame(width: 700, height: 650)
                    .foregroundColor(Color.black.opacity(bgOpacity))
                    .ignoresSafeArea()
                buttonGrid(x: 4, y: 4, phase: "guessed C")
            }
            
            if state == "results C" {
                Text("Results")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 550)
                
                Text("You cleared \(colorRound) rounds.")
                    .font(.largeTitle)
                    .bold()
                
                navigationBar(kind: "results")
            }
            
            if state == "log C" {
                if !currentLogDates.isEmpty {
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
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("\(currentLogVal1[index]) rounds.")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
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
                
                navigationBar(kind: "log")
            }
        }
    }
    //MARK: Picker - start
    
    @State private var hueAList: [Double] = []
    @State private var brightnessAList: [Double] = []
    @State private var hueQList: [Double] = []
    @State private var brightnessQList: [Double] = []
    @State private var pickerOffsets: [Double] = []
    func makeHueAList(count: Int) {
        hueAList.removeAll()
        for _ in 0..<count {
            hueAList.append(Double.random(in: 0...1))
        }
    }
    func makeBrightnessAList(count: Int) {
        brightnessAList.removeAll()
        for _ in 0..<count {
            brightnessAList.append(Double.random(in: 0.3...1))
        }
    }
    func calcColorOffset() {
        let pr = pickerRound
        pickerOffsets.append(round(100 - (100 * (abs(hueAList[pr] - hueQList[pr]) + abs(brightnessAList[pr] - brightnessQList[pr])))))
    }
    @State private var pickerRound: Int = 0
    @State private var colorSlider: Double = 0.2
    @State private var brightnessSlider: Double = 0.8
    var pickerView: some View {
        ZStack {
            if state == "start P" {
                Button(action: {
                    makeHueAList(count: 5)
                    makeBrightnessAList(count: 5)
                    print(hueAList)
                    print(brightnessAList)
                    
                    state = "show P"
                }) {
                    Text("Start")
                        .font(.largeTitle)
                        .bold()
                        .frame(width: 700, height: 650)
                        .background(Color.green.opacity(bgOpacity))
                        .clipShape(Rectangle())
                }.buttonStyle(.plain)
                    .ignoresSafeArea()
                
                navigationBar(kind: "start")
            }
            ZStack {
                //MARK: Picker - show
                if state == "show P" {
                    Rectangle()
                        .frame(width: 700, height: 650)
                        .foregroundColor(.black.opacity(bgOpacity))
                        .ignoresSafeArea()
                        .padding(.top, 50)
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 500, height: 400)
                        .foregroundColor(.black.opacity(elementOpacity))
                        .padding(.top, 180)
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 500, height: 350)
                        .foregroundColor(Color(hue: hueAList[pickerRound], saturation: 1.0, brightness: brightnessAList[pickerRound]))
                        .padding(.bottom, 150)
                    Button(action: {
                        state = "pick P"
                    }) {
                        Text("Continue")
                            .frame(width: 150, height: 50)
                            .font(.title2)
                            .background(Color(hue: hueAList[pickerRound], saturation: 1.0, brightness: brightnessAList[pickerRound]))
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                        .padding(.top, 510)
                }
                //MARK: Picker - pick
                if state == "pick P" {
                    Rectangle()
                        .frame(width: 700, height: 650)
                        .foregroundColor(.black.opacity(bgOpacity))
                        .ignoresSafeArea()
                        .padding(.top, 50)
                    
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 500, height: 400)
                        .foregroundColor(.black.opacity(elementOpacity))
                        .padding(.top, 180)
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 500, height: 350)
                        .foregroundColor(Color(hue: colorSlider, saturation: 1.0, brightness: brightnessSlider))
                        .padding(.bottom, 150)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 450, height: 50)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { drag in
                                    let val = drag.location.x / 450
                                    colorSlider = min(max(val, 0), 1)
                                }
                        )
                        .padding(.top, 270)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .frame(width: 20, height: 40)
                        .offset(x: (colorSlider-0.5) * 430)
                        .allowsHitTesting(false)
                        .padding(.top, 270)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.black, Color(hue: colorSlider, saturation: 1.0, brightness: 1.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 450, height: 50)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { drag in
                                    let val = drag.location.x / 450
                                    brightnessSlider = min(max(val, 0), 1)
                                }
                        )
                        .padding(.top, 390)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .frame(width: 20, height: 40)
                        .offset(x: (brightnessSlider-0.5) * 430)
                        .allowsHitTesting(false)
                        .padding(.top, 390)
                    
                    Button(action: {
                        hueQList.append(colorSlider)
                        brightnessQList.append(brightnessSlider)
                        calcColorOffset()
                        state = "result P"
                    }) {
                        Text("Check")
                            .frame(width: 150, height: 50)
                            .font(.title2)
                            .background(Color(hue: colorSlider, saturation: 1.0, brightness: 1.0).opacity(elementOpacity))
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                        .padding(.top, 510)
                    
                }
            }.padding(.bottom, 50)
            //MARK: Picker - result
            if state == "result P" {
                ZStack {
                    Rectangle()
                        .frame(width: 700, height: 650)
                        .foregroundColor(.black.opacity(bgOpacity))
                        .ignoresSafeArea()
                        .padding(.top, 50)
                    
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 500, height: 400)
                        .foregroundColor(.black.opacity(elementOpacity))
                        .padding(.top, 180)
                     
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 250, height: 350)
                            .foregroundColor(Color(hue: hueAList[pickerRound], saturation: 1.0, brightness: brightnessAList[pickerRound]))
                            .padding(.bottom, 150)
                            .padding(.trailing, 25)
                        Rectangle()
                            .frame(width: 50, height: 350)
                            .foregroundColor(Color(hue: hueAList[pickerRound], saturation: 1.0, brightness: brightnessAList[pickerRound]))
                            .padding(.bottom, 150)
                            .padding(.leading, 175)
                    }.padding(.trailing, 225)
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 250, height: 350)
                            .foregroundColor(Color(hue: hueQList[pickerRound], saturation: 1.0, brightness: brightnessQList[pickerRound]))
                            .padding(.bottom, 150)
                            .padding(.leading, 25)
                        Rectangle()
                            .frame(width: 50, height: 350)
                            .foregroundColor(Color(hue: hueQList[pickerRound], saturation: 1.0, brightness: brightnessQList[pickerRound]))
                            .padding(.bottom, 150)
                            .padding(.trailing, 175)
                    }.padding(.leading, 225)
                    
                    Text(pickerOffsetText)
                        .font(.system(size: 40, weight: .semibold, design: .default))
                        .padding(.top, 300)
                    Button(action: {
                        if pickerRound < 4 {
                            pickerRound += 1
                            state = "show P"
                        } else {
                            writeToLog(log: "picker")
                            state = "results P"
                        }
                        
                    }) {
                        Text("Continue")
                            .frame(width: 150, height: 50)
                            .font(.title2)
                            .background(Color(hue: hueAList[pickerRound], saturation: 1.0, brightness: brightnessAList[pickerRound]))
                            .clipShape(Capsule())
                    }.buttonStyle(.plain)
                        .padding(.top, 510)
                }.padding(.bottom, 50)
            }
            //MARK: Picker - results
            if state == "results P" {
                HStack {
                    ForEach(0..<pickerOffsets.count, id: \.self) { index in
                        let sqS: CGFloat = 110
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .frame(width: sqS/2, height: sqS)
                                .foregroundColor(Color(hue: hueAList[index], saturation: 1.0, brightness: brightnessAList[index]))
                                .padding(.trailing, sqS/2)
                            Rectangle()
                                .frame(width: sqS/4, height: sqS)
                                .foregroundColor(Color(hue: hueAList[index], saturation: 1.0, brightness: brightnessAList[index]))
                                .padding(.trailing, sqS/4)
                            
                            RoundedRectangle(cornerRadius: 18)
                                .frame(width: sqS/2, height: sqS)
                                .foregroundColor(Color(hue: hueQList[index], saturation: 1.0, brightness: brightnessQList[index]))
                                .padding(.leading, sqS/2)
                            Rectangle()
                                .frame(width: sqS/4, height: sqS)
                                .foregroundColor(Color(hue: hueQList[index], saturation: 1.0, brightness: brightnessQList[index]))
                                .padding(.leading, sqS/4)
                            
                            Text("\(String(format: "%.2f", round(pickerOffsets[index]*100)/100))")
                                .padding(.top, sqS + 20)
                                .font(.title2)
                        }.frame(width: sqS, height: sqS)
                        
                    }
                }.padding(.bottom, 420)
                Text("Avarage acuracy: \(String(format: "%.1f", pickerOffsets.reduce(0.0, +) / Double(pickerOffsets.count)))%")
                    .font(.largeTitle)
                    .bold()
                navigationBar(kind: "results")
            }
            if state == "log P" {
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
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.leading, 40)
                                        Spacer()
                                        
                                        Text("Best: \(currentLogVal1[index]), Worst: \(currentLogVal2[index]), Avarage:  \(currentLogVal3[index])")
                                            .foregroundColor(darkMode ? .white : .black)
                                            .font(.title2)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.trailing, 40)
                                        
                                    }
                                }
                            }
                        } else {
                            Text("No log stored")
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(height: 400)
                
                navigationBar(kind: "log")
            }
        }
    }
    //MARK: Typing test
    
    func getCharColor(index: Int) -> Color{
        if index < currentChar {
            return .white
        } else {
            return .gray
        }
    }
    var avgLpsText: String {
        String(format: "%.2f", Double(totalLetters)/totalTime)
    }
    
    @State private var randomSentence: String = "NONE"
    @State private var chosenSentences: [Int] = []
    @State private var randomNum: Int = 0
    @State private var sentenceRound: Int = 0
    @State private var currentChar: Int = 0
    @State private var inputReady: Bool = true
    @State private var keyPressed: String = "None"
    @State private var invisText: String = ""
    @State private var strArray: [String] = []
    @State private var pressDate: Date = Date()
    @State private var totalLetters: Int = 0
    @State private var totalTime: Double = 0
    @State private var startTypingTime: Date = Date()
    @FocusState private var focused: Bool
    var typeTextView: some View {
        ZStack {
            if state == "start X" {
                Button(action: {
                    while chosenSentences.count < 3 {
                        randomNum = Int.random(in: 0..<randomSentences.count)
                        if !chosenSentences.contains(randomNum) {
                            chosenSentences.append(randomNum)
                        }
                    }
                    print(chosenSentences)
                    sentenceRound = 0
                    randomSentence = randomSentences[chosenSentences[sentenceRound]]
                    strArray = randomSentence.map { String($0) }
                    currentChar = 0
                    totalLetters = 0
                    totalTime = 0
                    inputReady = true
                    state = "typing X"
                    startTypingTime = Date()
                }) {
                    Text("Start")
                        .font(.largeTitle)
                        .bold()
                        .frame(width: 700, height: 650)
                        .background(Color.green.opacity(bgOpacity))
                        .clipShape(Rectangle())
                }.buttonStyle(.plain)
                    .ignoresSafeArea()
                
                navigationBar(kind: "start")
            }
            if state == "typing X" {
                
                Rectangle()
                    .frame(width: 700, height: 650)
                    .foregroundColor(.blue.opacity(bgOpacity))
                    .ignoresSafeArea()
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.black.opacity(elementOpacity))
                    .frame(width: 650, height: 25)
                    .padding(.bottom, 10)
                //let charArray: = Array(randomSentence)
                if inputReady {
                    ZStack(alignment: .topLeading) {
                        ForEach(0..<strArray.count, id: \.self) { index in
                            Text(strArray[index])
                                .font(.system(size: 15, weight: .regular, design: .monospaced))
                                .foregroundColor(getCharColor(index: index))
                                .padding(.leading, CGFloat(10*index))
                            //.padding(.top, charArray.count)
                        }
                        if currentChar < strArray.count {
                            Text("_")
                                .font(.system(size: 15, weight: .regular, design: .monospaced))
                                .padding(.leading, CGFloat(10*currentChar))
                                .padding(.bottom, 10)
                        }
                    }
                }
                if sentenceRound-1 == 0 {
                    Text(randomSentences[chosenSentences[sentenceRound-1]])
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.bottom, 60)
                }
                if sentenceRound-2 == 0 {
                    Text(randomSentences[chosenSentences[sentenceRound-2]])
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.bottom, 60)
                    Text(randomSentences[chosenSentences[sentenceRound-1]])
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.bottom, 110)
                }
                
                if sentenceRound+1 < 3 {
                    Text(randomSentences[chosenSentences[sentenceRound + 1]])
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                }
                if sentenceRound+2 < 3 {
                    Text(randomSentences[chosenSentences[sentenceRound + 2]])
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                        .foregroundColor(.gray)
                        .padding(.top, 90)
                }
                
                Text("Avg lps: \(Double(totalLetters)/totalTime)")
                    .font(.title2)
                    .padding(.top, 300)
                ZStack {
                    let invisFielfOffset: CGFloat = 700
                    if currentChar < strArray.count {
                        Text(keyPressed)
                            .padding(.top, invisFielfOffset)
                        TextField("", text: $invisText)
                            .focused($focused)
                            .opacity(0.3)
                            .padding(.top, invisFielfOffset + 30)
                            .onChange(of: invisText) { newValue in
                                if let endChar = newValue.last {
                                    keyPressed = String(endChar)
                                    invisText = ""
                                    if keyPressed == strArray[currentChar] {
                                        totalTime += Double(Date().timeIntervalSince(pressDate))
                                        pressDate = Date()
                                        currentChar += 1
                                        totalLetters += 1
                                    }
                                }
                            }
                            .onAppear() {
                                focused = true
                            }
                    } else {
                        Text("end of sentence")
                            .padding(.top, invisFielfOffset)
                            .onAppear() {
                                if sentenceRound < 2 {
                                    sentenceRound += 1
                                    inputReady = false
                                    randomSentence = randomSentences[chosenSentences[sentenceRound]]
                                    strArray.removeAll()
                                    strArray = randomSentence.map { String($0) }
                                    currentChar = 0
                                    inputReady = true
                                } else {
                                    writeToLog(log: "type")
                                    state = "results X"
                                }
                            }
                    }
                }
                
            }
            if state == "results X" {
                Text("\(avgLpsText) letters per second.")
                    .font(.largeTitle)
                
                navigationBar(kind: "results")
            }
            if state == "log X" {
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
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.leading, 40)
                                        Spacer()
                                        Text("\(currentLogVal1[index]) letters per second.)")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                        Spacer()
                                        Text("\(currentLogDates[index])")
                                            .font(.title2)
                                            .foregroundColor(darkMode ? .white : .black)
                                            .padding(.trailing, 40)
                                    }.onAppear() {
                                        
                                    }
                                
                                }.onAppear() {
                                    print("Im line number \(index), returned: \(userInLog(pos: index)) ")
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.frame(height: 400)

                } else {
                    Text("No log stored.")
                        .font(.title2)
                }
                
                navigationBar(kind: "log")
            }
        }
    }
    
     //MARK: Menu tutor
    
    var tutorView: some View {
        ZStack {
            HStack {
                Image(systemName: "arrow.turn.left.up")
                    .font(.title2)
                Text("Drag the window with the top handle.")
                    .font(.title2)
                    
                Image(systemName: "arrow.turn.right.up")
                    .font(.title2)
            }.padding(.bottom, 580)
            ZStack {
                Image(systemName: "cursorarrow.rays")
                    .font(.system(size: 70, weight: .bold, design: .default))
                    .padding(.bottom, 280)
                Text("Test yourself in capabilities")
                    .font(.title2)
                    .padding(.bottom, 400)
                HStack(spacing: 150) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 70, weight: .thin, design: .default))
                        .padding(.bottom, 280)
                    Image(systemName: "arrow.down")
                        .font(.system(size: 70, weight: .thin, design: .default))
                        .padding(.bottom, 280)
                }
            }
            ZStack {
                Image(systemName: "list.dash")
                    .font(.system(size: 70, weight: .bold, design: .default))
                    .padding(.bottom, 30)
                Text("Get your test results")
                    .font(.title2)
                    .padding(.bottom, 130)
                HStack(spacing: 150) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 70, weight: .thin, design: .default))
                        .padding(.bottom, 30)
                    Image(systemName: "arrow.down")
                        .font(.system(size: 70, weight: .thin, design: .default))
                        .padding(.bottom, 30)
                }
            }
            ZStack {
                Image(systemName: "chart.bar")
                    .font(.system(size: 70, weight: .regular, design: .default))
                    .padding(.top, 200)
                Text("Compete with other users")
                    .font(.title2)
                    .padding(.top, 100)
                /*
                HStack(spacing: 200) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 70, weight: .thin, design: .default))
                        .padding(.top, 200)
                    Image(systemName: "arrow.down")
                        .font(.system(size: 70, weight: .thin, design: .default))
                        .padding(.top, 200)
                }
                 */
            }
            
            Button(action: {
                state = "menu"
            }) {
                Text("Back")
                    .font(.largeTitle)
                    .frame(width: 180, height: 50)
                    .background(Color.gray.opacity(elementOpacity - 0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }.buttonStyle(.plain)
                .padding(.top, 500)
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
                        print("Set bgOpacity to userPreferences \(UserPreferencesBgOpacity[userOnLogin])")
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
                                userCard(at: index, size: 280)
                                    .padding(.bottom, 50)
                            }
                        }
                        
                    }.padding(.bottom, 0)
                }
                

                HStack {
                    Text("Don't have an account?")
                        .font(.title2)
                    Button(action: {
                        usersState = "creating"
                        passwordState = "name"
                    }) {
                        Text("Create new")
                            .font(.title2)
                            .baselineOffset(0.5)
                            .frame(width: 110, height: 30)
                            .background(Color.blue.opacity(0.45))
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                    }.buttonStyle(.plain)
                }.padding(.top, 530)
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
                VStack(spacing: -20) {
                    Text("Welcome to")
                        .font(.largeTitle)
                        .foregroundColor(Color.white.opacity(0.6))
                    Text("Skill tester.")
                        .font(.system(size: 81, weight: .bold, design: .default))
                        .foregroundColor(Color.white.opacity(0.7))
                }.padding(.bottom, 500)
                
                Text(getProfilePicture(index: userOnLogin))
                    .font(.system(size: 125, weight: .thin, design: .default))
                    .foregroundColor(darkMode ? .black.opacity(0.8) : Color.white.opacity(0.8))
                    .frame(width: 250, height: 250)
                    .background(getProfileColor(index: userOnLogin))
                    .clipShape(Circle())
                    .padding(.bottom, 110)
                Text(userNames[userOnLogin])
                    .foregroundColor(darkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                    .font(.largeTitle)
                    .padding(.top, 190)
                HStack(spacing: -35) {
                    SecureField(
                        "Password...",
                        text: $passwordInput,
                        prompt: Text("Password...")
                            .foregroundColor(darkMode ? Color.black : Color.white)
                    )
                        .font(.largeTitle)
                        .foregroundColor(darkMode ? Color.black : Color.white)
                        .padding(.leading, 10)
                        .textFieldStyle(.plain)
                        .frame(width: 190, height: 40)
                        .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.black.opacity(elementOpacity))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Button(action: {
                        if passwordInput == userPass[userOnLogin] {
                            print("USER NAME: \(userNames[userOnLogin]) SIGNED IN")
                            makeUsersBest(user: userOnLogin)
                            usersState = "loggedin"
                            state = "loggedin"
                            userLoggedIn = userOnLogin
                            lastLoggedIn = userLoggedIn
                            bgOpacity = UserPreferencesBgOpacity[userLoggedIn]
                            print("Set bgOpacity to userPreferences \(UserPreferencesBgOpacity[userOnLogin])")
                            elementOpacity = UserPreferencesElementOpacity[userLoggedIn]
                            darkMode = userPreferencesDarkMode[userLoggedIn]
                            setUntriedMode(user: userLoggedIn)
                            manageStreaks()
                            print("Tutor? \(startTutor)")
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
                            .foregroundColor(darkMode ? .black : .white)
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
                    passwordRepeat = ""
                    
                    bgOpacity = 0.6
                    elementOpacity = 0.45
                    print("set bgOpacity to default 0.6")
                }) {
                    Image(systemName: "arrow.left")
                        .font(.largeTitle)
                        .foregroundColor(darkMode ? .black : .white)
                        .frame(width: 40, height: 40)
                        .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.black.opacity(elementOpacity))
                        .clipShape(Circle())
                }.buttonStyle(.plain)
                    .keyboardShortcut(.return, modifiers: [])
                    .padding(.top, 280)
                    .padding(.trailing, 230)
                Toggle("Tutorial on start", isOn: $startTutor)
                    .padding(.top, 380)
                    .onAppear() {
                        startTutor = false
                    }
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
                    Button(action: {
                        usersState = "choosing"
                        passwordState = "done"
                        passwordInput = ""
                        passwordRepeat = ""
                        
                        bgOpacity = 0.6
                        elementOpacity = 0.45
                        print("set bgOpacity to default 0.6 (brandNewScreen)")
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.largeTitle)
                            .foregroundColor(darkMode ? .gray : .white)
                            .frame(width: 40, height: 40)
                            .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.black.opacity(elementOpacity))
                            .clipShape(Circle())
                    }.buttonStyle(.plain)
                        .keyboardShortcut(.return, modifiers: [])
                        .padding(.top, 1)
                        .padding(.trailing, 230)
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
                                    lastStreakDays.append(dayOfWeekNum(day: Date().weekDay))
                                    userStreaks.append(1)
                                    screenTimeMon.append(0)
                                    screenTimeTue.append(0)
                                    screenTimeWed.append(0)
                                    screenTimeThu.append(0)
                                    screenTimeFri.append(0)
                                    screenTimeSat.append(0)
                                    screenTimeSun.append(0)
                                    passwordState = "done"
                                    userOnLogin = userNames.count - 1
                                    usersState = "login"
                                    passwordInput = ""
                                    passwordRepeat = ""
                                    print("Tutor? \(startTutor)")
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
                            manageStreaks()
                            makeUsersBest(user: userLoggedIn)
                            print("UsersBest: \(usersBest)")
                            let charAray = Array(usersBest)
                            print(charAray)
                            print("Int from it: \(Int(String(charAray[1]))!)")
                            startTutor = false
                            setUntriedMode(user: userLoggedIn)
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
                .onAppear() {print("BGOPACITY\(bgOpacity)")}
            userScreen()
            
            ZStack {
                Button(action: {
                    state = "menu"
                }) {
                    Text("Continue")
                        .font(.system(size: 51, weight: .bold, design: .default))
                        .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
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
                        .foregroundColor(darkMode ? textColor.opacity(0.8) : .white.opacity(0.8))
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
                        .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.white.opacity(elementOpacity))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }.buttonStyle(.plain)
                    .padding(.trailing, 420)
                
                Button(action: {
                    makeLogLeaderboard(mode: "spam")
                    makeLogLeaderboard(mode: "react")
                    makeLogLeaderboard(mode: "time")
                    makeLogLeaderboard(mode: "aim")
                    makeLogLeaderboard(mode: "memory")
                    makeLogLeaderboard(mode: "color")
                    makeLogLeaderboard(mode: "picker")
                    makeLogLeaderboard(mode: "type")
                    
                    state = "user results"
                }) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 35, design: .default))
                        .foregroundColor(textColor.opacity(0.8))
                        .frame(width: 70, height: 70)
                        .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.white.opacity(elementOpacity))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }.buttonStyle(.plain)
                    .padding(.trailing, 250)
                
                Button(action: {
                    print("ENTERING ANALYTICS")
                    loadAnalyticsData()
                    print(graphValList)
                    print(graphTextList)
                    state = "analytics"
                }) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 43, design: .default))
                        .foregroundColor(textColor.opacity(0.8))
                        .frame(width: 70, height: 70)
                        .background(darkMode ? Color.gray.opacity(elementOpacity) : Color.white.opacity(elementOpacity))
                        .clipShape(Capsule())
                }.buttonStyle(.plain)
                    .padding(.trailing, 75)
                
            }.frame(width: 680, height: 90)
                .background(Color.black.opacity(0.12))
                .clipShape(Capsule())
                .padding(.top, 490)
            
            
            
            //MARK: Expand profile menu
            
            
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
                            print("Logout (bgOpacity = 0.6)")
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
                if startTutor {
                    VStack(alignment: .leading, spacing: 20) {
                        let tFont: Font = .title2
                        let tCol: Color = .white
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(tFont)
                                .foregroundColor(tCol)
                            Text("Log out of this account")
                                .font(tFont)
                                .foregroundColor(tCol)
                        }
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(tFont)
                                .foregroundColor(tCol)
                            Text("Change account name & password")
                                .font(tFont)
                                .foregroundColor(tCol)
                        }
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(tFont)
                                .foregroundColor(tCol)
                            Text("Close this menu")
                                .font(tFont)
                                .foregroundColor(tCol)
                        }
                    }.padding(.top, 400)
                        .padding(.leading, 50)
                        .zIndex(1)
                }
            }
        }.onAppear() {
            print("UsersBest: \(usersBest)")
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
                                if index != 10 {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(textColor.opacity(0.8))
                                        .frame(width: 40, height: 40)
                                        .background(getButtonColor(index: index))
                                        .clipShape(Circle())
                                } else {
                                    HStack(spacing: 0) {
                                        Color.white
                                        Color.black
                                    }.frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .rotationEffect(.degrees(45))
                                        .overlay() {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(. white.opacity(0.8))
                                                .frame(width: 40, height: 40)
                                        }
                                }
                                
                            } else {
                                
                                Button(action: {
                                    print("Button returned \(getButtonColor(index: index))")
                                    if getButtonColorName(index: index) == "white" && darkMode {
                                        userColor[userLoggedIn] = getButtonColorName(index: index)
                                    } else if getButtonColorName(index: index) == "white" && !darkMode {
                                        userColor[userLoggedIn] = "black"
                                    } else {
                                        userColor[userLoggedIn] = getButtonColorName(index: index)
                                    }
                                }) {
                                    if index != 10 {
                                        Text("")
                                            .frame(width: 40, height: 40)
                                            .background(getButtonColor(index: index))
                                            .clipShape(Circle())
                                    } else {
                                        HStack(spacing: 0) {
                                            Color.white
                                            Color.black
                                        }.frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .rotationEffect(.degrees(45))
                                    }
                                    
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
                                if bgOpacity >= 0.8 {
                                    UserPreferencesBgOpacity[userLoggedIn] = bgOpacity
                                    print("set bgOpacity \(bgOpacity) userPreferences \(UserPreferencesBgOpacity[userLoggedIn])")
                                } else if !darkMode {
                                    bgOpacity = 0.8
                                    print("Changed opacity of background (too small for lightMode)")
                                } else {
                                    UserPreferencesBgOpacity[userLoggedIn] = bgOpacity
                                }
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
                            if userColor[userLoggedIn] == "black" && darkMode {
                                userColor[userLoggedIn] = "white"
                            } else if userColor[userLoggedIn] == "white" && !darkMode {
                                userColor[userLoggedIn] = "black"
                            }
                            if bgOpacity <= 0.8 {
                                bgOpacity = 0.8
                                print("toggle changed bgOpacity")
                            }
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
            //SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
            //    .ignoresSafeArea()
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
                                        
                                        deleteUserLog(log: "S", user: accountUnderEdit)
                                        deleteUserLog(log: "R", user: accountUnderEdit)
                                        deleteUserLog(log: "T", user: accountUnderEdit)
                                        deleteUserLog(log: "A", user: accountUnderEdit)
                                        deleteUserLog(log: "M", user: accountUnderEdit)
                                        deleteUserLog(log: "C", user: accountUnderEdit)
                                        deleteUser(user: accountUnderEdit)
                                        
                                    } else {
                                        usersState = "choosing"
                                        state = "startup"
                                        nameInput = ""
                                        passwordInput = ""
                                        lastLoggedIn = 101
                                        bgOpacity = 0.6
                                        elementOpacity = 0.45
                                        
                                        deleteUserLog(log: "S", user: accountUnderEdit)
                                        deleteUserLog(log: "R", user: accountUnderEdit)
                                        deleteUserLog(log: "T", user: accountUnderEdit)
                                        deleteUserLog(log: "A", user: accountUnderEdit)
                                        deleteUserLog(log: "M", user: accountUnderEdit)
                                        deleteUserLog(log: "C", user: accountUnderEdit)
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
    //MARK: User leaderboard
    
    func getLeaderboardfont(index: Int) -> Font {
        if index == 0 {
            return .system(size: 60, weight: .bold, design: .default)
        } else if index == 1 {
            return .system(size: 55, weight: .bold, design: .default)
        } else if index == 2 {
            return .system(size: 50, weight: .bold, design: .default)
        } else {
            return .system(size: 45, design: .default)
        }
    }
    func getLeaderboardColor(index: Int) -> Color {
        if index == 0 {
            return .yellow
        } else if index == 1 {
            return .orange
        } else if index == 2 {
            if darkMode {
                return .white
            } else {
                return .black
            }
        } else {
            if darkMode {
                return Color(red: 0.8, green: 0.8, blue: 0.8)
            } else {
                return Color(red: 0.2, green: 0.2, blue: 0.2)
            }
        }
    }
    
    @State private var leaderboardText: String = "Spam mode"
    @State private var modePadding: Int = 0
    var userResults: some View {
        ZStack {
            //SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
            //    .ignoresSafeArea()
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
                            if spamLeaderboard.isEmpty {
                                EmptyView()
                            } else if spamLeaderboard[index] <= 0 {
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
                            if reactLeaderboard.isEmpty {
                                EmptyView()
                            } else if reactLeaderboard[index] >= 100000 {
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
                            if timeLeaderboard.isEmpty {
                                EmptyView()
                            } else if timeLeaderboard[index] >= 100000 {
                                Text("#\(index+1). \(userNames[bestTimeValues.firstIndex(of: timeLeaderboard[index])!]) -.--s.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestTimeValues.firstIndex(of: timeLeaderboard[index])!]) \(String(format: "%.2f", timeLeaderboard[index]))s.")
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
                            if aimLeaderboard.isEmpty {
                                EmptyView()
                            } else if aimLeaderboard[index] >= 100000 {
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
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                // MEMORY
                VStack {
                    ScrollView {
                        ForEach(0...userNames.count - 1, id: \.self) {index in
                            if memoryLeaderboard.isEmpty {
                                EmptyView()
                            } else if memoryLeaderboard[index] <= 0 {
                                Text("#\(index+1). \(userNames[bestMemoryValues.firstIndex(of: memoryLeaderboard[index])!]) - squares.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestMemoryValues.firstIndex(of: memoryLeaderboard[index])!]) \(memoryLeaderboard[index]) squares.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            }
                        }
                    }.padding(.top, 5)
                }
            }.frame(width: 600, height: 390)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.leading, CGFloat(5600 - modePadding))
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                // COLOR
                VStack {
                    ScrollView {
                        ForEach(0...userNames.count - 1, id: \.self) {index in
                            if colorLeaderboard.isEmpty {
                                EmptyView()
                            } else if colorLeaderboard[index] <= 0 {
                                Text("#\(index+1). \(userNames[bestColorValues.firstIndex(of: colorLeaderboard[index])!]) - rounds.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestColorValues.firstIndex(of: colorLeaderboard[index])!]) \(colorLeaderboard[index]) rounds.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            }
                        }
                    }.padding(.top, 5)
                }
            }.frame(width: 600, height: 390)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.leading, CGFloat(7000 - modePadding))
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                // PICKER
                VStack {
                    ScrollView {
                        ForEach(0...userNames.count - 1, id: \.self) {index in
                            if pickerLeaderboard.isEmpty {
                                EmptyView()
                            } else if pickerLeaderboard[index] <= 0 {
                                Text("#\(index+1). \(userNames[bestPickerValues.firstIndex(of: pickerLeaderboard[index])!]) -% acur.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestPickerValues.firstIndex(of: pickerLeaderboard[index])!]) \(pickerLeaderboard[index])% acur.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            }
                        }
                    }.padding(.top, 5)
                }
            }.frame(width: 600, height: 390)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.leading, CGFloat(8400 - modePadding))
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                // TYPING
                VStack {
                    ScrollView {
                        ForEach(0...userNames.count - 1, id: \.self) {index in
                            if typeLeaderboard.isEmpty {
                                EmptyView()
                            } else if typeLeaderboard[index] <= 0 {
                                Text("#\(index+1). \(userNames[bestTypeValues.firstIndex(of: typeLeaderboard[index])!]) - lps.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            } else {
                                Text("#\(index+1). \(userNames[bestTypeValues.firstIndex(of: typeLeaderboard[index])!]) \(String(format: "%.2f", typeLeaderboard[index])) lps.")
                                    .font(getLeaderboardfont(index: index))
                                    .foregroundColor(getLeaderboardColor(index: index))
                            }
                        }
                    }.padding(.top, 5)
                }
            }.frame(width: 600, height: 390)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.leading, CGFloat(9800 - modePadding))
            
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
                        } else if modePadding == 5600 {
                            leaderboardText = "Aim mode"
                        } else if modePadding == 7000 {
                            leaderboardText = "Memory mode"
                        } else if modePadding == 8400 {
                            leaderboardText = "Color mode"
                        } else if modePadding == 9800 {
                            leaderboardText = "Picker mode"
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
                    if modePadding != 9800 {
                        if modePadding == 0 {
                            leaderboardText = "Reaction mode"
                        } else if modePadding == 1400 {
                            leaderboardText = "Time mode"
                        } else if modePadding == 2800 {
                            leaderboardText = "Aim mode"
                        } else if modePadding == 4200 {
                            leaderboardText = "Memory mode"
                        } else if modePadding == 5600 {
                            leaderboardText = "Color mode"
                        } else if modePadding == 7000 {
                            leaderboardText = "Picker mode"
                        } else if modePadding == 8400 {
                            leaderboardText = "Typing mode"
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
    
    //MARK: User analyatics
    
    @State private var listIndex: Int = 0
    @State private var maxVal: Int = 0
    func loadAnalyticsData() {
        graphValList.removeAll()
        graphTextList.removeAll()
        
        graphValList.append(Double(screenTimeMon[userLoggedIn]))
        graphTextList.append("Mon")
        graphValList.append(Double(screenTimeTue[userLoggedIn]))
        graphTextList.append("Tue")
        graphValList.append(Double(screenTimeWed[userLoggedIn]))
        graphTextList.append("Wed")
        graphValList.append(Double(screenTimeThu[userLoggedIn]))
        graphTextList.append("Thu")
        graphValList.append(Double(screenTimeFri[userLoggedIn]))
        graphTextList.append("Fri")
        graphValList.append(Double(screenTimeSat[userLoggedIn]))
        graphTextList.append("Sat")
        graphValList.append(Double(screenTimeSun[userLoggedIn]))
        graphTextList.append("Sun")
        
        let currentMax = graphValList.max() ?? 60
        if currentMax <= 30 {
        } else if currentMax <= 60 {
            maxVal = 60
        } else if currentMax <= 120 {
            maxVal = 120
        } else if currentMax <= 180 {
            maxVal = 180
        } else if currentMax <= 240 {
            maxVal = 240
        } else if currentMax <= 300 {
            maxVal = 300
        } else if currentMax <= 420 {
            maxVal = 420
        } else if currentMax <= 540 {
            maxVal = 540
        } else if currentMax <= 720 {
            maxVal = 720
        } else {
            maxVal = 1440
        }
        
        print("LOADED ANALYTICS DATA")
        print(graphValList)
        print(graphTextList)
    }
    
    var analyticsView: some View {
        ZStack {
            //SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
            //    .ignoresSafeArea()
            VStack(spacing: -20) {
                Text("User analytics for")
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
            
            Text("Daily avarage \(getScreenTimeAvarage())")
                .font(.title3)
                .padding(.bottom, 270)
                .onAppear() {
                    print(graphValList)
                    print(graphTextList)
                }
            if maxVal > 0 {
                graph(maxWidth: 500, maxHeight: 300, barWidth: 50, color: .blue, valueCount: graphValList.count, maxValue: Double(maxVal))
            } else {
                graph(maxWidth: 500, maxHeight: 300, barWidth: 50, color: .blue, valueCount: graphValList.count, maxValue: 60)
            }
            
            
            /*
            Text("SCREEN TIME\(screenTimeSat[userLoggedIn])")
                .font(.largeTitle)
                .padding(.top, 450)
            */
            
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
    
    func getStreakColor(index: Int) -> Color {
        if index == 0 {
            if screenTimeMon[userLoggedIn] > 0 { return getProfileColor(index: userLoggedIn) } else { return .gray }
        } else if index == 1 {
            if screenTimeTue[userLoggedIn] > 0 { return getProfileColor(index: userLoggedIn) } else { return .gray }
        } else if index == 2 {
            if screenTimeWed[userLoggedIn] > 0 { return getProfileColor(index: userLoggedIn) } else { return .gray }
        } else if index == 3 {
            if screenTimeThu[userLoggedIn] > 0 { return getProfileColor(index: userLoggedIn) } else { return .gray }
        } else if index == 4 {
            if screenTimeFri[userLoggedIn] > 0 { return getProfileColor(index: userLoggedIn) } else { return .gray }
        } else if index == 5 {
            if screenTimeSat[userLoggedIn] > 0 { return getProfileColor(index: userLoggedIn) } else { return .gray }
        } else if index == 6 {
            if screenTimeSun[userLoggedIn] > 0 { return getProfileColor(index: userLoggedIn) } else { return .gray }
        } else { return .purple }
    }
    
    @State private var untriedMode: String = ""
    func setUntriedMode(user: Int) {
        untriedMode = "none"
        if !spamLogDates.contains(String(userLoggedIn)) {
            untriedMode = "spam"
        }
        if !reactLogDates.contains(String(userLoggedIn)) {
            untriedMode = "spam"
        }
        if !timeLogDates.contains(String(userLoggedIn)) {
            untriedMode = "time"
        }
        if !aimLogDates.contains(String(userLoggedIn)) {
            untriedMode = "aim"
        }
        if !memoryLogDates.contains(String(userLoggedIn)) {
            untriedMode = "memory"
        }
        if !colorLogDates.contains(String(userLoggedIn)) {
            untriedMode = "color"
        }
    }
    //MARK: User screen
    @State private var unimprovedMode: Int = Int.random(in: 0...6)
    func getMode(mode: Int) -> String {
        switch mode {
        case 0: return "spam"
        case 1: return "reaction"
        case 2: return "time"
        case 3: return "memory"
        case 4: return "color"
        case 5: return "picker"
        case 6: return "aim"
        default: return "error"
        }
    }
    func userScreen() -> some View {
        ZStack {
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                HStack {
                    
                    ForEach(0...6, id: \.self) { index in
                        let size: CGFloat = 55
                        VStack {
                            Circle()
                                .frame(width: size, height: size)
                                .foregroundColor(getStreakColor(index: index))
                                
                            Text(dayOfWeek(day: index))
                                .font(.title3)
                        }
                    }
                    
                    
                }.padding(.top, 10)
                HStack {
                    Image(systemName: "flame")
                        .font(.system(size: 40, weight: .regular, design: .default))
                        .foregroundColor(darkMode ? .white : .black)
                    VStack(spacing: -5) {
                        Text("\(userStreaks[userLoggedIn])d")
                            .font(.largeTitle)
                            .foregroundColor(darkMode ? .white : .black)
                        Text("Streak")
                            .foregroundColor(darkMode ? .white : .black)
                    }
                }.padding(.trailing, 560)
                HStack {
                    VStack(spacing: -5) {
                        Text("\(userStreaks[userLoggedIn])d")
                            .font(.largeTitle)
                            .foregroundColor(darkMode ? .white : .black)
                        Text("Total")
                            .foregroundColor(darkMode ? .white : .black)
                    }
                    Image(systemName: "calendar")
                        .font(.system(size: 40, weight: .regular, design: .default))
                        .foregroundColor(darkMode ? .white : .black)
                }.padding(.leading, 560)
            }.frame(width: 680, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.bottom, 270)
            
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                if usersBest != "" {
                    HStack {
                        let charAray = Array(usersBest)
                        Image(systemName: "chart.bar")
                            .font(.system(size: 40, weight: .regular, design: .default))
                            .foregroundColor(darkMode ? .white : .black)
                        VStack(spacing: -10) {
                            Text("\(usersBest) mode")
                                .font(getLeaderboardfont(index: Int(String(charAray[1]))! - 1))
                                .foregroundColor(getLeaderboardColor(index: Int(String(charAray[1]))! - 1))
                            Text("Best rank")
                                .foregroundColor(darkMode ? .white : .black)
                        }.padding(.trailing, 50)
                    }
                }
            }.frame(width: 680, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.bottom, 20)
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                if untriedMode != "none" {
                    Text("You haven't tried \(untriedMode) mode yet, give it a try!")
                        .font(.largeTitle)
                        .foregroundColor(darkMode ? .white : .black)
                        .padding(.trailing, 100)
                    Button(action: {
                        if untriedMode.prefix(1).uppercased() != "" {
                            state = "start \(untriedMode.prefix(1).uppercased())"
                        }
                    }) {
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 40, weight: .regular, design: .default))
                            .frame(width: 60, height: 60)
                            .foregroundColor(darkMode ? textColor : .black)
                            .background(getProfileColor(index: userLoggedIn))
                            .clipShape(Circle())
                    }.buttonStyle(.plain)
                        .padding(.leading, 500)
                } else {
                    
                    Text("Improve your score in \(getMode(mode: unimprovedMode)) mode!")
                        .font(.largeTitle)
                        .foregroundColor(darkMode ? textColor : .white)
                        .padding(.trailing, 100)
                    Button(action: {
                        if untriedMode.prefix(1).uppercased() != "" {
                            state = "start \(getMode(mode: unimprovedMode).prefix(1).uppercased())"
                            unimprovedMode = Int.random(in: 0...6)
                        }
                    }) {
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 40, weight: .regular, design: .default))
                            .frame(width: 60, height: 60)
                            .foregroundColor(darkMode ? textColor : .black)
                            .background(getProfileColor(index: userLoggedIn))
                            .clipShape(Circle())
                    }.buttonStyle(.plain)
                        .padding(.leading, 500)
                }
            }.frame(width: 680, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 230)
            if state == "loggedin" && startTutor {
                userTutor()
            }
        }
    }
    //MARK: User tutorial
    func userTutor() -> some View {
        ZStack{
            ZStack {
                SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
                    .ignoresSafeArea()
                Text("Tutorial")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 80)
                HStack {
                    Image(systemName: "arrow.turn.left.up")
                        .font(.title2)
                    Text("Drag the window with the top handle.")
                        .font(.title2)
                        
                    Image(systemName: "arrow.turn.right.up")
                        .font(.title2)
                }.padding(.bottom, 580)
                if mouseXY.y > 602 {
                    Group {
                        Text("Go to menu")
                            .font(.title2)
                            .padding(.bottom, 505)
                            .padding(.leading, 480)
                        Rectangle()
                            .frame(width: 1, height: 50)
                            .padding(.bottom, 550)
                            .padding(.leading, 615)
                        Rectangle()
                            .frame(width: 20, height: 1)
                            .padding(.bottom, 500)
                            .padding(.leading, 595)
                    }
                    Group {
                        Text("Go home")
                            .font(.title2)
                            .padding(.bottom, 405)
                            .padding(.leading, 500)
                        Rectangle()
                            .frame(width: 1, height: 100)
                            .padding(.bottom, 500)
                            .padding(.leading, 670)
                        Rectangle()
                            .frame(width: 40, height: 1)
                            .padding(.bottom, 400)
                            .padding(.leading, 630)
                    }
                }
                if usersState != "userSettings" {
                    ZStack {
                        Text("Play different gamemodes")
                            .font(.title2)
                            .padding(.leading, 450)
                        Image(systemName: "arrow.down")
                            .padding(.leading, 450)
                            .padding(.top, 30)
                        Group {
                            Text("Customize appearance")
                                .font(.title2)
                                .padding(.trailing, 180)
                                .padding(.bottom, 140)
                            Rectangle()
                                .frame(width: 1, height: 80)
                                .padding(.bottom, 60)
                                .padding(.trailing, 420)
                            
                            Rectangle()
                                .frame(width: 30, height: 1)
                                .padding(.bottom, 140)
                                .padding(.trailing, 390)
                        }
                        Text("View Screen Time")
                            .font(.title2)
                        Image(systemName: "arrow.down")
                            .padding(.trailing, 70)
                            .padding(.top, 30)
                        Group {
                            Text("View leaderboards")
                                .font(.title2)
                                .padding(.bottom, 70)
                                .padding(.trailing, 35)
                            Rectangle()
                                .frame(width: 1, height: 45)
                                .padding(.bottom, 25)
                                .padding(.trailing, 240)
                            Rectangle()
                                .frame(width: 30, height: 1)
                                .padding(.bottom, 70)
                                .padding(.trailing, 210)
                        }
                        Text("Click to expand")
                            .font(.title2)
                            .padding(.trailing, 570)
                        Image(systemName: "arrow.down")
                            .padding(.trailing, 580)
                            .padding(.top, 30)
                    }.padding(.top, 350)
                }
                Button(action: {
                    startTutor = false
                }) {
                    Text("End tutorial")
                        .font(.title2)
                        .frame(width: 150, height: 50)
                        .background(Color.black.opacity(elementOpacity))
                        .clipShape(Capsule())
                }.buttonStyle(.plain)
            }.frame(width: 700, height: 650)
                .padding(.bottom, 5)
        }
    }
    //MARK: TopBar
    
    var topBar: some View {
        ZStack {
            SmoothBlur(material: .hudWindow, blendMode: .withinWindow)
            if state != "startup" && state != "login" {
                Button(action: {
                    state = "loggedin"
                }) {
                    Image(systemName: "house.circle")
                        .frame(width: 22, height: 22)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                }.buttonStyle(.plain)
                    .padding(.leading, 670)
                Button(action: {
                    state = "menu"
                }) {
                    Image(systemName: "list.bullet.circle")
                        .frame(width: 22, height: 22)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                }.buttonStyle(.plain)
                    .padding(.leading, 615)
                
            }
        }.frame(width: 700, height: 30)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom, 630)
            .ignoresSafeArea()
    }
    
    //MARK: BODY
    var body: some View {
        ZStack {
            if darkMode {
                Rectangle()
                    .fill(Color.black.opacity(bgLowOpacity))
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
            } else if state.hasSuffix("C") {
                colorView
            } else if state.hasSuffix("P") {
                pickerView
            } else if state.hasSuffix("X") {
                typeTextView
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
            } else if state == "analytics" {
                analyticsView
            }
            if mouseXY.y > 602 {
                topBar
            }
        }
        .frame(minWidth: 700, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
        .navigationTitle("Skilltester")
        .onReceive(timer) { _ in
            timeElapsed += 1
        }
        .onReceive(signalTimer) { currentTime in
            guard scenePhase == .active, !userNames.isEmpty, userLoggedIn < userNames.count else {return}
            let timePassedS = currentTime.timeIntervalSince(previousDate)
            if timePassedS >= 60 {
                let timePassedM = Int(timePassedS/60)
                previousDate = previousDate.addingTimeInterval(Double(timePassedM * 60))
                let week = Date().weekDay
                if week == "Mon" {
                    screenTimeMon[userLoggedIn] = Int(screenTimeMon[userLoggedIn] + timePassedM)
                } else if week == "Tue" {
                    screenTimeTue[userLoggedIn] = Int(screenTimeTue[userLoggedIn] + timePassedM)
                } else if week == "Wed" {
                    screenTimeWed[userLoggedIn] = Int(screenTimeMon[userLoggedIn] + timePassedM)
                } else if week == "Thu" {
                    screenTimeThu[userLoggedIn] = Int(screenTimeThu[userLoggedIn] + timePassedM)
                } else if week == "Fri" {
                    screenTimeFri[userLoggedIn] = Int(screenTimeFri[userLoggedIn] + timePassedM)
                } else if week == "Sat" {
                    screenTimeSat[userLoggedIn] = Int(screenTimeSat[userLoggedIn] + timePassedM)
                } else if week == "Sun" {
                    screenTimeSun[userLoggedIn] = Int(screenTimeSun[userLoggedIn] + timePassedM)
                }
            }
        }
        .onAppear() {
            print(userNames)
            print(userPass)
            setupMouse()
        }
        .onDisappear() {
            removeMouse()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


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

extension Date {
    var weekDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
}
