//
//  ContentView.swift
//  Hyd
//
//  Created by M G on 08/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showUserInfo = false
    @State private var showHistory = false

    var body: some View {
        TabView {
            WelcomeView()
                .tabItem {
                    Label("Welcome", systemImage: "star")
                }
            
            MainView()
                .tabItem {
                    Label("Main", systemImage: "house")
                }
            
            Button(action: {
                showUserInfo = true
            }) {
                Text("Open User Info")
            }
            .tabItem {
                Label("User Info", systemImage: "person")
            }
            .sheet(isPresented: $showUserInfo) {
                UserInfo()
            }
            
            Button(action: {
                showHistory = true
            }) {
                Text("Open History")
            }
            .tabItem {
                Label("History", systemImage: "clock")
            }
            .sheet(isPresented: $showHistory) {
                HistoryView()
            }
        }
    }
}
