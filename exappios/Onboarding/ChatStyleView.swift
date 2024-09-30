//
//  ChatStyleView.swift
//  exappios
//
//  Created by Tami on 26.08.2024.
//

import SwiftUI

struct ChatStyleView: View {
    
    @State private var selectedIndex: Int = 0
    @AppStorage("onboarding") var onboarding = true
    
    let avatars = ["phone_tg", "phone_wa", "phone_im"]
    let chatStyleMap: [String: Int] = [
        "Like iMessage" : 2,
        "Like Telegram" : 0,
        "Like WhatsApp" : 1
    ]
    
    @Namespace private var animationNamespace

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    ForEach(0..<avatars.count, id: \.self) { index in
                        if index == selectedIndex {
                            Image(avatars[index])
                                .resizable()
                                .scaledToFill()
                                .scaleEffect(0.9)
                                .animation(.easeInOut, value: selectedIndex)
                        }
                    }
                }

                VStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(hex: "#2B2B2B"))
                        .frame(height: 420)
                        .overlay(
                            VStack(alignment: .leading) {
                                Text(ExAppStrings.Onboarding.chatStyle)
                                    .font(.system(size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.top, 25)
                                
                                ChatOptionStyle(buttonName: ExAppStrings.Onboarding.continueButton, buttonColor: Color(hex: "#2A6A07"), destinationType: .premium, onSelect: {
                                    onboarding = false
                                })
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal)
                        )
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("ChatStyleChanged"), object: nil, queue: .main) { notification in
                        if let userInfo = notification.userInfo,
                           let chatStyle = notification.userInfo?["selectedChatStyle"] as? String {
                            
                            if let index = chatStyleMap[chatStyle] {
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
                        }
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ChatStyleChanged"), object: nil)
                }
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
