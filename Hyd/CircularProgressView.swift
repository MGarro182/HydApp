//
//  CircularProgressView.swift
//  Hyd
//
//  Created by M G on 17/09/2024.
//

import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: Double
    var goal: Double
    
    var body: some View {
        let percentage = min(progress / goal, 1.0)
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.4)
                .foregroundColor(.C_4)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(.C_4)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: percentage)
            
            Text(String(format: "%.0f%%", percentage * 100))
                .font(.headline)
                .bold()
                .foregroundColor(.C_4)
                .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)
        }
    }
}
