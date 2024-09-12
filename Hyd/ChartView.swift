//
//  ChartView.swift
//  Hyd
//
//  Created by M G on 11/09/2024.
//

import SwiftUI
import Charts

struct ChartView: View {
    let data: [DataPoint]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(data) { point in
                    BarMark(
                        x: .value("Day", point.day),
                        y: .value("Water Intake", point.value)
                    )
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [.C_0, point.value >= 2000 ? .C_1 : .C_4]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .cornerRadius(5)
                    .annotation(position: .top) {
                        Text("\(Int(point.value)) mL")
                            .font(.caption)
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .fontWidth(.compressed)
                            .foregroundColor(.C_4)
                            .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .font(.caption)
                        .foregroundStyle(.C_4)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine()
                        .foregroundStyle(Color.gray.opacity(0.5))
                    AxisValueLabel()
                        .font(.caption)
                        .foregroundStyle(.C_4)
                }
            }
            .frame(height: 300)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.C_0, .C_1]),
                    startPoint: .top,
                    endPoint: .bottom)
                )
                .shadow(radius: 5)
            )
            .padding()
        }
    }
}

struct DataPoint: Identifiable {
    var id = UUID()
    var day: String
    var value: Double
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(data: [
            DataPoint(day: "Mon", value: 1200),
            DataPoint(day: "Tue", value: 1500),
            DataPoint(day: "Wed", value: 1800),
            DataPoint(day: "Thu", value: 2000),
            DataPoint(day: "Fri", value: 2500),
            DataPoint(day: "Sat", value: 1900),
            DataPoint(day: "Sun", value: 2200)
        ])
    }
}
