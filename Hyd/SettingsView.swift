//
//  Settings.swift
//  Hyd
//
//  Created by M G on 08/09/2024.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("height") private var height: Double = 0.0 // Default height in cm
    @AppStorage("weight") private var weight: Double = 0.0   // Default weight in kg
    @AppStorage("unitHeight") private var unitHeight: String = "cm" // "cm" or "ft"
    @AppStorage("unitWeight") private var unitWeight: String = "kg" // "kg" or "lb"
    @AppStorage("unitVolume") private var unitVolume: String = "mL" // "mL" or "oz"
    
    @State private var newHeight: String = ""
    @State private var newWeight: String = ""
    @State private var selectedHeightUnit: String = "cm"
    @State private var selectedWeightUnit: String = "kg"
    @State private var selectedVolumeUnit: String = "mL"
    @State private var showAlert: Bool = false
    @State private var date = Date()
    
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Text("Settings")
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
            
            Form {
                Section(header: Text("Height")
                    .font(.system(size: 20))
                    .fontWidth(.compressed)
                    .foregroundColor(.C_4)
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)) {
                        
                        
                        TextField("Height", text: $newHeight)
                            .keyboardType(.decimalPad)
                        
                        Picker("Unit", selection: $selectedHeightUnit) {
                            Text("cm").tag("cm")
                            Text("ft").tag("ft")
                        }
                        .foregroundColor(.C_4)
                        .pickerStyle(SegmentedPickerStyle())
                    }
                
                Section(header: Text("Weight")
                    .font(.system(size: 20))
                    .fontWidth(.compressed)
                    .foregroundColor(.C_4)
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2))
                {
                    
                    TextField("Weight", text: $newWeight)
                        .keyboardType(.decimalPad)
                    
                    Picker("Unit", selection: $selectedWeightUnit) {
                        Text("kg").tag("kg")
                        Text("lbs").tag("lbs")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Volume Unit")
                    .font(.system(size: 20))
                    .fontWidth(.compressed)
                    .foregroundColor(.C_4)
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)) {
                        
                        Picker("Volume Unit", selection: $selectedVolumeUnit) {
                            Text("mL").tag("mL")
                            Text("oz").tag("oz")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                
                Section(header: Text("Hyd Time")
                    .font(.system(size: 20))
                    .fontWidth(.compressed)
                    .foregroundColor(.C_4)
                    .shadow(color: Color.primary.opacity(0.3), radius: 3, x: 0, y: 2)){
                    
                    DatePicker("Alarm", selection: $date)
                }
                
                Button(action: {
                    // Guardar los datos nuevos
                    if let heightValue = Double(newHeight) {
                        height = heightValue
                    }
                    if let weightValue = Double(newWeight) {
                        weight = weightValue
                    }
                    
                    unitHeight = selectedHeightUnit
                    unitWeight = selectedWeightUnit
                    unitVolume = selectedVolumeUnit
                    
                    scheduleNotification()
                    
                    showAlert = true
                }) { Text("Save") }
                
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Saved"),
                        message: Text("Your data has been saved successfully."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.C_0, .C_1]), startPoint: .top, endPoint: .bottom))
        .onAppear {
            // Cargar los valores actuales
            newHeight = "\(height)"
            newWeight = "\(weight)"
            selectedHeightUnit = unitHeight
            selectedWeightUnit = unitWeight
            selectedVolumeUnit = unitVolume
            
            // Solicitar permisos para notificaciones
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Error requesting notification permissions: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hyd time"
        content.body = "It's time to hydrate"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "hydrationReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
