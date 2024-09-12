//
//  UserInfo.swift
//  Hyd
//
//  Created by M G on 08/09/2024.
//

import SwiftUI

struct UserInfo: View {
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var heightUnit: String = "Centimeters" // "Feet"
    @State private var weightUnit: String = "Kilograms" // "Pounds"
    @State private var volumeUnit: String = "Milliliters" // "Ounces"
    
    private let defaults = UserDefaults.standard

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Your Information")) {
                    TextField("Height", text: $height)
                        .keyboardType(.decimalPad)
                    
                    Picker("Height Unit", selection: $heightUnit) {
                        Text("Centimeters").tag("Centimeters")
                        Text("Feet").tag("Feet")
                    }
                    
                    TextField("Weight", text: $weight)
                        .keyboardType(.decimalPad)
                    
                    Picker("Weight Unit", selection: $weightUnit) {
                        Text("Kilograms").tag("Kilograms")
                        Text("Pounds").tag("Pounds")
                    }
                    
                    Picker("Volume Unit", selection: $volumeUnit) {
                        Text("Milliliters").tag("Milliliters")
                        Text("Ounces").tag("Ounces")
                    }
                }
                
                Button(action: saveUserData) {
                    Text("Save")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("User Info")
        }
    }
    
    private func saveUserData() {
        // Guardar datos en UserDefaults
        if let heightValue = Double(height), let weightValue = Double(weight) {
            defaults.set(heightValue, forKey: "height")
            defaults.set(weightValue, forKey: "weight")
            defaults.set(heightUnit, forKey: "heightUnit")
            defaults.set(weightUnit, forKey: "weightUnit")
            defaults.set(volumeUnit, forKey: "volumeUnit")
            
            // Verificar los datos guardados
            print("Height saved: \(defaults.double(forKey: "height"))")
            print("Weight saved: \(defaults.double(forKey: "weight"))")
            print("Height Unit saved: \(defaults.string(forKey: "heightUnit") ?? "None")")
            print("Weight Unit saved: \(defaults.string(forKey: "weightUnit") ?? "None")")
            print("Volume Unit saved: \(defaults.string(forKey: "volumeUnit") ?? "None")")
        } else {
            print("Invalid height or weight input.")
        }
    }
}
