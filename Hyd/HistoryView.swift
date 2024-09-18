//
//  History.swift
//  Hyd
//
//  Created by M G on 08/09/2024.
//

import SwiftUI

struct HistoryView: View {
    @State private var waterHistory: [DataPoint] = []
    @State private var totalCompletedDays: Int = 0

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("History")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .fontWidth(.compressed)
                    .foregroundColor(.C_4)
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
                    .padding(.horizontal)
                
                Spacer()
                
                Image("Hdy-Bottle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .rotationEffect(.degrees(30.0))
            }

            ChartView(data: waterHistory)
            
            Text("Weekly Hydration")
                .font(.title2)
                .bold()
                .padding(.horizontal)
                .foregroundColor(.C_1)
                .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)

            Text("\(totalCompletedDays)")
                .font(.system(size: 96, weight: .bold))
                .padding(.horizontal)
                .foregroundColor(.C_1)
                .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
            
            Spacer()

            Text("Weekly Hydration")
                .font(.title2)
                .bold()
                .padding(.horizontal)
                .foregroundColor(.C_1)
                .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
            
            Text("You completed your daily hydration goal for \(calculateWeeklyPercentage())% of the last 7 days.")
                .font(.body)
                .padding(.horizontal)
                .foregroundColor(.C_1)
                .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [.C_0, .C_4]), startPoint: .top, endPoint: .bottom))
        .onAppear {
            loadWaterHistory()
            calculateCompletedDays()
        }
    }

    private func loadWaterHistory() {
        let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        var savedHistory = UserDefaults.standard.object(forKey: "waterHistory") as? [Double] ?? Array(repeating: 0.0, count: 7)
        
        let todayIndex = getTodayIndex()
        if todayIndex == 0 {
            waterHistory = zip(daysOfWeek, savedHistory).map { DataPoint(day: $0, value: $1) }

            UserDefaults.standard.set(Array(repeating: 0.0, count: 7), forKey: "waterHistory")
        } else {

            while savedHistory.count < 7 {
                savedHistory.append(0.0)
            }
            waterHistory = zip(daysOfWeek, savedHistory).map { DataPoint(day: $0, value: $1) }
        }
    }
    
    private func getTodayIndex() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let dayIndex = calendar.dateComponents([.day], from: startOfWeek, to: today).day! % 7
        return (dayIndex + 7) % 7
    }
    
    private func calculateCompletedDays() {
        totalCompletedDays = waterHistory.filter { $0.value >= 2000 }.count
    }
    
    private func calculateWeeklyPercentage() -> Int {
        let completedCount = waterHistory.filter { $0.value >= 2000 }.count
        // Evitar la división por cero
        guard waterHistory.count > 0 else {
            return 0 // O cualquier otro valor que consideres apropiado
        }
        return completedCount * 100 / waterHistory.count
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
