//
//  MainView.swift
//  Hyd
//
//  Created by M G on 08/09/2024.
//

import SwiftUI

struct MainView: View {
    @AppStorage("dailyGoal") private var dailyGoal: Double = 2000
    @AppStorage("waterConsumed") private var waterConsumed: Double = 0
    @AppStorage("height") private var height: Double = 170
    @AppStorage("weight") private var weight: Double = 70
    @AppStorage("unitHeight") private var unitHeight: String = "cm"
    @AppStorage("unitWeight") private var unitWeight: String = "kg"
    @AppStorage("unitVolume") private var unitVolume: String = "mL"
    
    @AppStorage("lastResetDate") private var lastResetDate: String = ""
    
    @State private var showHistory = false
    @State private var showSettings = false
    @State private var showCongratulations = false
    
    var convertedHeight: String {
        switch unitHeight {
        case "ft":
            return String(format: "%.1f ft", height * 0.0328084) // cm to feet
        default:
            return String(format: "%.1f cm", height) // cm
        }
    }
    
    var convertedWeight: String {
        switch unitWeight {
        case "lbs":
            return String(format: "%.1f lbs", weight * 2.20462) // kg to lbs
        default:
            return String(format: "%.1f kg", weight) // kg
        }
    }
    
    var waterConsumedInPreferredUnit: Double {
        switch unitVolume {
        case "oz":
            return waterConsumed * 0.033814 // mL to oz
        default:
            return waterConsumed // mL
        }
    }
    
    var dailyGoalInPreferredUnit: Double {
        switch unitVolume {
        case "oz":
            return dailyGoal * 0.033814 // mL to oz
        default:
            return dailyGoal // mL
        }
    }
    
    // New function to calculate daily water intake based on weight
    var calculatedDailyGoal: Double {
        let waterPerKg = 35.0 // Standard: 35 mL per kg of weight
        return weight * waterPerKg
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Water Consumed: \(String(format: "%.1f", waterConsumedInPreferredUnit)) \(unitVolume)")
                    .foregroundColor(.C_4)
                    .font(.system(size: 40))
                    .fontWidth(.compressed)
                    .padding()
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
                
                CircularProgressView(progress: $waterConsumed, goal: calculatedDailyGoal)
                    .frame(width: 150, height: 150)
                    .padding()
                
                Button(action: addWater) {
                    Text("Add Water")
                        .font(.system(size: 30))
                        .fontWidth(.compressed)
                        .padding()
                        .background(Color.C_2)
                        .foregroundColor(.C_1)
                        .cornerRadius(10)
                        .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
                }
                
                let remaining = calculatedDailyGoal - waterConsumedInPreferredUnit
                Text("Water Remaining: \(String(format: "%.1f", remaining)) \(unitVolume)")
                    .font(.system(size: 30))
                    .fontWidth(.compressed)
                    .foregroundColor(.C_4)
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
                    .padding()
                
                Text("Height: \(convertedHeight)")
                    .font(.system(size: 25))
                    .fontWidth(.compressed)
                    .foregroundColor(.C_4)
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
                Text("Weight: \(convertedWeight)")
                    .font(.system(size: 25))
                    .fontWidth(.compressed)
                    .foregroundColor(.C_4)
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        showHistory.toggle()
                    }) {
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color.C_3.opacity(0.1))
                            .clipShape(Circle())
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [.C_2, .C_4]), startPoint: .top, endPoint: .bottom)
                            )
                    }
                    .sheet(isPresented: $showHistory) {
                        HistoryView()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Acción para el ícono del medio si es necesario
                    }) {
                        Image("Hdy-Bottle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding()
                            .background(Color.C_3.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color.C_3.opacity(0.1))
                            .clipShape(Circle())
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [.C_2, .C_4]), startPoint: .top, endPoint: .bottom)
                            )
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                    }
                }
                .padding()
            }
            .background(LinearGradient(gradient: Gradient(colors: [.C_0, .C_1]), startPoint: .top, endPoint: .bottom))
            .alert(isPresented: $showCongratulations) {
                Alert(
                    title: Text("Congratulations!"),
                    message: Text("You have met your daily goal."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                checkReset()
            }
            .onChange(of: waterConsumed) { oldValue, newValue in
                if newValue >= calculatedDailyGoal {
                    showCongratulations = true
                }
            }
        }
    }
    
    func addWater() {
        waterConsumed += 250
        if waterConsumed > calculatedDailyGoal {
            waterConsumed = calculatedDailyGoal
        }
        saveWaterHistory()
    }
    
    func checkReset() {
        let currentDate = getCurrentDateString()
        if lastResetDate != currentDate {
            waterConsumed = 0
            lastResetDate = currentDate
        }
    }
    
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func saveWaterHistory() {
        var history = loadWaterHistory()
        let todayIndex = getTodayIndex()
        
        if todayIndex < history.count {
            history[todayIndex] = waterConsumed
            UserDefaults.standard.set(history, forKey: "waterHistory")
        }
    }

    private func loadWaterHistory() -> [Double] {
        return UserDefaults.standard.object(forKey: "waterHistory") as? [Double] ?? Array(repeating: 0, count: 7)
    }
    
    private func getTodayIndex() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let dayIndex = calendar.dateComponents([.day], from: startOfWeek, to: today).day! % 7
        return (dayIndex + 7) % 7
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
