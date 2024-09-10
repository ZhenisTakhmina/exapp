//
//  ChatStyleView.swift
//  exappios
//
//  Created by Tami on 26.08.2024.
//

import SwiftUI

struct ChatStyleView: View {
    
    @State private var selectedAvatar: String = "chatScreen"
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                Image(selectedAvatar)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(0.9)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: "#2B2B2B"))
                    .frame(height: 420)
                    .overlay(
                        VStack(alignment: .leading) {
                            Text("Chat Style")
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 25)
                                                        
                            ChatOptionStyle(buttonName: "Continue", destinationType: .premium, onSelect: {
                                UserDefaults.standard.set(true, forKey: "onboardingCompleted")

                            })
                            
                            Spacer()

                        }
                        .padding(.horizontal)
                    )
            }
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
    }
}

struct RadioButton: View {
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.green : Color.gray, lineWidth: 2)
                .frame(width: 25, height: 25)
            
            if isSelected {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
        }
    }
}

#Preview {
    ChatStyleView()
}
