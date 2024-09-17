//
//  SettingsView.swift
//  exappios
//
//  Created by Tami on 04.09.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var name = UserDefaults.standard.string(forKey: UserDefaultsKeys.name) ?? ""
    @State private var exName  = UserDefaults.standard.string(forKey: UserDefaultsKeys.exName) ?? ""
    @State private var selectedAvatar: String? = UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? "avatar"
    @State private var navigateToPremiumView = false

    
    let avatars = ["avatar", "brokenHeart", "avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7"]
    
    
    var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your name")
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
                            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.name)
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ex's name")
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
                            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.exName)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Ex's avatar")
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
                                        }
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .padding()
                        }
                        
                        Text("Chat Style")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 25)
                        
                        ChatOptionStyle(buttonName: "Save & Close", destinationType: .chat, onSelect: {
                            saveSelectedAvatar()
                        })
                        .scaleEffect(0.9)
                        
                        NavigationLink(destination: ExPremiumView(), isActive: $navigateToPremiumView){
                            EmptyView()
                        }
                    }
                    
                }
                
            }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(.system(size: 22))
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }
            
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    navigateToPremiumView = true
                }){
                    Text("Premium")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                }
                .background(Color(hex: "#FDA802").cornerRadius(25))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveSelectedAvatar() {
        UserDefaults.standard.set(selectedAvatar, forKey: UserDefaultsKeys.avatar)
    }
}

#Preview {
    SettingsView()
}
