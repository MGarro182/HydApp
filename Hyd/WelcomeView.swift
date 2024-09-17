//
//  WelcomeView.swift
//  Hyd
//
//  Created by M G on 08/09/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.C_0.edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    Image("Hyd-Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 360, height: 400)
                        .scaleEffect(scale)
                        .offset(offset)
                        .padding()
                }
                
                if isActive {
                    MainView()
                        .transition(.opacity)
                        .padding(.top, -360)
                        .padding(.bottom, 0)
                }
            }
            .animation(.easeInOut(duration: 1.0), value: isActive)

            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.scale = 0.3
                        self.offset = CGSize(width: 0, height: -155)
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
