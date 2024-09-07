//
//  ChatOptionStyle.swift
//  exappios
//
//  Created by Tami on 04.09.2024.
//

import SwiftUI

struct ChatOptionStyle: View {
    
    let buttonName: String
    
    @State private var navigateToChatView = false
    @State private var selectedOption: ChatStyle? = .imessage
    let options: [ChatStyle] = [.imessage, .telegram, .whatsapp]
    
    private var savedExName: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.exName) ?? "Ex"
    }
    
    private var savedAvatar: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? "avatar"
    }
    
    private var header: ChatHeader {
        ChatHeader(title: savedExName, subtitle: "был(а) недавно", avatarImage: Image(savedAvatar))
    }
    
    var body: some View {
        Text("Chat Style")
            .font(.system(size: 30))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.bottom, 10)
        
        ForEach(options, id: \.self) { option in
                HStack(spacing: 20){
                    RadioButton(isSelected: selectedOption == option)
                    Text(option.rawValue)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .background(Color(selectedOption == option ? .gray.opacity(0.5) : .clear))
                .cornerRadius(15)
                .onTapGesture {
                    selectedOption = option
                }
        }
        
        if let selectedOption = selectedOption {
            Button(action: {
                navigateToChatView = true
                UserDefaults.standard.set(true, forKey: "onboardingCompleted")
            }) {
                Text(buttonName)
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
    
}

