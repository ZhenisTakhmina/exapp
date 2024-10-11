//
//  SettingsView.swift
//  exappios
//
//  Created by Tami on 04.09.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = UserDefaults.standard.string(forKey: UserDefaultsKeys.name) ?? ""
    @State private var exName  = UserDefaults.standard.string(forKey: UserDefaultsKeys.exName) ?? ""
    @State private var selectedAvatar: String? = UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? ""
    @State private var style = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedChatStyle) ?? ""
    @State private var navigateToPremiumView = false
    @State private var isChanged = false
    
    private var header: ChatHeader {
        ChatHeader(title: userDefaultsManager.savedExName, avatarImage: Image(userDefaultsManager.savedAvatar))
    }
    let userDefaultsManager = UserDefaultsManager.shared
    let avatars = ["avatar", "brokenHeart", "avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7"]
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(ExAppStrings.Onboarding.yourName)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                    
                    ZStack(alignment: .leading) {
                        if name.isEmpty {
                            Text("Michael")
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.leading, 16)
                        }
                        
                        TextField("", text: $name)
                            .padding()
                            .background(Color.clear)
                            .foregroundStyle(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .onChange(of: name) { newValue in
                        checkIfChanged()
                        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.name)
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(ExAppStrings.Settings.exName)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                    
                    ZStack(alignment: .leading) {
                        if exName.isEmpty {
                            Text("Ex")
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.leading, 16)
                        }
                        
                        TextField("", text: $exName)
                            .padding()
                            .foregroundStyle(.white)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .onChange(of: exName) { newValue in
                        checkIfChanged()
                        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.exName)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(ExAppStrings.Settings.exAvatar)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 33) {
                            ForEach(avatars, id: \.self) { avatar in
                                AvatarItemView(avatar: avatar, isSelected: avatar == selectedAvatar)
                                    .onTapGesture {
                                        selectedAvatar = avatar
                                        checkIfChanged()
                                    }
                                    .frame(width: 60, height: 60)
                            }
                        }
                        .padding()
                    }
                    
                    Text(ExAppStrings.Onboarding.chatStyle)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 15)
                    
                    ChatOptionStyle(buttonName: ExAppStrings.Settings.saveButton, buttonColor: isChanged ? Color(hex: "#2A6A07") : .gray, destinationType: .chat, onSelect: {
                        saveSelectedAvatar()
                    })
                    .scaleEffect(0.9)
                    
                }
                
            }
            .fullScreenCover(isPresented: $navigateToPremiumView){
                ExPremiumView()
            }
        }
        .gesture(
            DragGesture(minimumDistance: 30, coordinateSpace: .global)
                .onEnded { gesture in
                    if gesture.translation.width > 0 {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(ExAppStrings.Settings.settings)
                    .font(.system(size: 22))
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }
            
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    navigateToPremiumView = true
                }){
                    Text(ExAppStrings.Settings.premium)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .padding(.trailing, 5)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                }
                .background(Color(hex: "#FDA802").cornerRadius(25))
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                }
                
            }
        }
        .onAppear{
            NotificationCenter.default.addObserver(forName: NSNotification.Name("ChatStyleChanged"), object: nil, queue: .main) { notification in
                if let userInfo = notification.userInfo,
                   let chatStyle = notification.userInfo?["selectedChatStyle"] as? String {
                    style = chatStyle
                    checkIfChanged()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveSelectedAvatar() {
        UserDefaults.standard.set(selectedAvatar, forKey: UserDefaultsKeys.avatar)
    }
    
    private func checkIfChanged() {
        isChanged = (name != userDefaultsManager.savedName || exName != userDefaultsManager.savedExName || selectedAvatar != userDefaultsManager.savedAvatar || style != userDefaultsManager.savedStyle)
      }
}

#Preview {
    SettingsView()
}
