//
//  AboutExView.swift
//  exappios
//
//  Created by Tami on 25.08.2024.
//

import SwiftUI

struct AboutExView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedAvatar: String? = UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? "avatar"
    @State private var savedName = UserDefaults.standard.string(forKey: UserDefaultsKeys.name)
    @State private var savedBirthday = UserDefaults.standard.string(forKey: UserDefaultsKeys.birthday)
    
    let avatars = ["avatar", "brokenHeart", "avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6", "avatar7", "brokenHeartYellow", "video", "telephone"]
    
    @State private var isNavigationActive = false
    
    var body: some View {
        ZStack {
            Image(selectedAvatar ?? "avatar")
                .resizable()
                .scaleEffect(1.7)
                .ignoresSafeArea()
                .blur(radius: 10)
            
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack(spacing: 70) {
                if let selectedAvatar = selectedAvatar {
                    Image(selectedAvatar)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                
            
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color(hex: "#2B2B2B").opacity(0.8))
                    .frame(height: 510)
                    .overlay(
                        VStack(alignment: .leading){
                            Text("Choose avatar")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 22) {
                                ForEach(avatars, id: \.self) { avatar in
                                    AvatarItemView(avatar: avatar, isSelected: avatar == selectedAvatar)
                                        .onTapGesture {
                                            selectedAvatar = avatar
                                        }
                                }
                            }
                            
                            
                            Spacer()
                            
                            PrimaryButton(title: "Continue", onSelect: {
                                saveSelectedAvatar()
                                isNavigationActive = true
                            })
                            .padding(.bottom, 35)
                            .background(
                                NavigationLink(destination: ChatStyleView(), isActive: $isNavigationActive) {
                                    EmptyView()
                                }
                            )
                        }
                        .padding()
                    )
            }
            .padding(.top, 60)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About Ex")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss()}) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        
    }
    
    private func saveSelectedAvatar() {
        UserDefaults.standard.set(selectedAvatar, forKey: UserDefaultsKeys.avatar)
    }
}

struct AvatarItemView: View {
    let avatar: String
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Image(avatar)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
                Circle()
                .stroke(!isSelected ? .clear : Color.white, lineWidth: 4)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(!isSelected ? .clear : .white)
                            .background(!isSelected ? .clear : Color.black)
                            .clipShape(Circle())
                            .offset(x: 30, y: 30)
                        )
        }
    }
}

#Preview {
    AboutExView()
}
