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
    let avatars = ["avatar", "brokenHeart", "avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack{
                        Spacer().frame(width: 160)
                        Text("Settings")
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your name")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.leading, 15)
                        
                        ZStack(alignment: .leading) {
                            if name.isEmpty {
                                Text("Michael")
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .padding(.leading, 8)
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
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Ex's name")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.leading, 15)
                        
                        
                        ZStack(alignment: .leading) {
                            if exName.isEmpty {
                                Text("Ex")
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .padding(.leading, 8)
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
                            .padding(.leading, 15)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 45) {
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
                        
                        ChatOptionStyle(buttonName: "Save & Close")
                            .onChange(of: selectedAvatar) {
                                saveSelectedAvatar()
                            }
                            .scaleEffect(0.9)
                    }
                }
            }
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveSelectedAvatar() {
        UserDefaults.standard.set(selectedAvatar, forKey: UserDefaultsKeys.avatar)
    }
}



#Preview {
    SettingsView()
}
