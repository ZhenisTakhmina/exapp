//
//  ChatStyleView.swift
//  exappios
//
//  Created by Tami on 26.08.2024.
//

import SwiftUI

struct ChatStyleView: View {
    @State private var selectedOption: ChatStyle? = .imessage
    @State private var navigateToChatView = false  // State to control navigation

    let options: [ChatStyle] = [.imessage, .telegram, .whatsapp]
    
    private var savedName: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.name) ?? "Unknown"
    }
    
    private var savedAvatar: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? "avatar"
    }
    
    private var header: ChatHeader {
        ChatHeader(title: savedName, subtitle: "был(а) недавно", avatarImage: Image(savedAvatar))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                Image("chatScreen")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(0.9)
                
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#2B2B2B"))
                        .frame(height: 400)
                        .overlay(
                            VStack(alignment: .leading) {
                                Text("Chat Style")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                
                                ForEach(options, id: \.self) { option in
                                    HStack(spacing: 20) {
                                        RadioButton(isSelected: selectedOption == option)
                                        Text(option.rawValue)
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        selectedOption = option
                                    }
                                }
                                
                                if let selectedOption = selectedOption {
                                    Button(action: {
                                        navigateToChatView = true
                                        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
                                    }) {
                                        Text("Continue")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.gray.opacity(0.8))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .padding(.top, 20)
                                    
                                    NavigationLink(
                                        destination: ChatView(style: selectedOption, header: header),
                                        isActive: $navigateToChatView
                                    ) {
                                        EmptyView()
                                    }
                                }
                            }
                            .padding()
                        )
                }
            }
        }
    }
}


struct RadioButton: View {
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.white : Color.gray, lineWidth: 2)
                .frame(width: 25, height: 25)
            
            if isSelected {
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
            }
        }
    }
}

#Preview {
    ChatStyleView()
}
