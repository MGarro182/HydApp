//
//  Settings.swift
//  Hyd
//
//  Created by M G on 08/09/2024.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("height") private var height: Double = 0.0
    @AppStorage("weight") private var weight: Double = 0.0
    @AppStorage("unitHeight") private var unitHeight: String = "cm"
    @AppStorage("unitWeight") private var unitWeight: String = "kg"
    @AppStorage("unitVolume") private var unitVolume: String = "mL"
    
    @State private var newHeight: String = ""
    @State private var newWeight: String = ""
    @State private var selectedHeightUnit: String = "cm"
    @State private var selectedWeightUnit: String = "kg"
    @State private var selectedVolumeUnit: String = "mL"
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var date = Date()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case height, weight
    }
    
    var isDataComplete: Bool {
        guard let _ = Double(newHeight), !newHeight.isEmpty,
              let _ = Double(newWeight), !newWeight.isEmpty else {
            return false
        }
        return true
    }

    var body: some View {
        VStack {
            HStack {
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
            
            VStack {
                Form {
                    Section(header: Text("Height")) {
                        TextField("Height", text: $newHeight)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .height)
                        
                        Picker("Unit", selection: $selectedHeightUnit) {
                            Text("cm").tag("cm")
                            Text("ft").tag("ft")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Weight")) {
                        TextField("Weight", text: $newWeight)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .weight)
                        
                        Picker("Unit", selection: $selectedWeightUnit) {
                            Text("kg").tag("kg")
                            Text("lbs").tag("lbs")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Volume Unit")) {
                        Picker("Volume Unit", selection: $selectedVolumeUnit) {
                            Text("mL").tag("mL")
                            Text("oz").tag("oz")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Hyd Time")) {
                        DatePicker("Alarm", selection: $date, displayedComponents: [.hourAndMinute])
                    }
                    
                    Button(action: {
                        print("Save button pressed") // Debug statement
                        
                        if isDataComplete {
                            print("Data is complete") // Debug statement
                            
                            if let heightValue = Double(newHeight) {
                                print("Height value: \(heightValue)") // Debug statement
                                height = heightValue
                            }
                            if let weightValue = Double(newWeight) {
                                print("Weight value: \(weightValue)") // Debug statement
                                weight = weightValue
                            }
                            
                            unitHeight = selectedHeightUnit
                            unitWeight = selectedWeightUnit
                            unitVolume = selectedVolumeUnit
                            
                            alertMessage = "Your data has been saved successfully."
                            showAlert = true
                        } else {
                            print("Data is incomplete") // Debug statement
                            alertMessage = "Please complete both height and weight fields before saving."
                            showAlert = true
                        }
                        
                    }) {
                        Text("Save Settings")
                    }
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .fontWidth(.compressed)
                    .background(isDataComplete ? Color.C_0 : Color.gray)
                    .foregroundColor(.C_4)
                    .cornerRadius(10)
                    .disabled(!isDataComplete)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Saved"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .background(Color(.systemGray6)) // Cambiar el color de fondo del Form
                .cornerRadius(10) // Opcional: Añadir bordes redondeados al Form
            }
            .padding()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.C_0, .C_4]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        
        .onAppear {
            // Initialize fields with current values
            newHeight = "\(height)"
            newWeight = "\(weight)"
            selectedHeightUnit = unitHeight
            selectedWeightUnit = unitWeight
            selectedVolumeUnit = unitVolume
            
            print("Initialized values - Height: \(newHeight), Weight: \(newWeight), Height Unit: \(selectedHeightUnit), Weight Unit: \(selectedWeightUnit), Volume Unit: \(selectedVolumeUnit)")
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Notification permissions error: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
