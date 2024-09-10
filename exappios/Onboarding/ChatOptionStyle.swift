//
//  ChatOptionStyle.swift
//  exappios
//
//  Created by Tami on 04.09.2024.
//

import SwiftUI

enum DestinationType {
    case premium
    case chat
}

struct ChatOptionStyle: View {
    
    let buttonName: String
    let onSelect: () -> Void
    let destination: DestinationType
    
    @State private var navigateToPremiumView = false
    @State private var navigateToChatView = false    
    @State private var selectedOption: ChatStyle? = .telegram
    
    private var savedExName: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.exName) ?? "Ex"
    }
    
    private var savedAvatar: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? "avatar"
    }
    
    private var savedStyle: String {
        UserDefaults.standard.string(forKey: "selectedChatStyle") ?? "Like Telegram"
    }
    
    private var header: ChatHeader {
        ChatHeader(title: savedExName, subtitle: "был(а) недавно", avatarImage: Image(savedAvatar))
    }

    
    let options: [ChatStyle] = [.imessage, .telegram, .whatsapp]
    
    
    init(buttonName: String, destinationType: DestinationType, onSelect: @escaping () -> Void) {
        self.buttonName = buttonName
        self.onSelect = onSelect
        self.destination = destinationType
        if let savedOption = UserDefaults.standard.string(forKey: "selectedChatStyle") {
            self._selectedOption = State(initialValue: ChatStyle(rawValue: savedOption))
        }
    }
    
    var body: some View {
        
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
                UserDefaults.standard.set(option.rawValue, forKey: "selectedChatStyle")
            }
        }
        
        if let selectedOption = selectedOption {
            Button(action: {
                onSelect()
                switch destination {
                case .premium:
                    navigateToPremiumView = true
                case .chat:
                    navigateToChatView = true
                }
            }
            ) {
                Text(buttonName)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            if destination == .premium {
                NavigationLink(
                    destination: ExPremiumView(),
                    isActive: $navigateToPremiumView
                ) {
                    EmptyView()
                }
            }
            
            if destination == .chat {
                NavigationLink(
                    destination: ChatView(style: selectedOption, header: header),
                    isActive: $navigateToChatView
                ) {
                    EmptyView()
                }
            }
        }
    }
    
}

