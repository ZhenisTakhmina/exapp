//
//  ExPremiumViewCopy.swift
//  exappios
//
//  Created by Tami on 26.09.2024.
//

import SwiftUI

struct ExPremiumViewCopy: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToChatView = false
    @State private var selectedOption: String = "Annual"
    let userDefaultsManager = UserDefaultsManager.shared

    
    private var header: ChatHeader {
        ChatHeader(title: userDefaultsManager.savedExName, avatarImage: Image(userDefaultsManager.savedAvatar))
    }
    
    private let premiumTexts = ["Exes text more", "See hidden photos", "Change name", "Change avatar"]
    
    init(){
        UserDefaultsManager.shared.saveFirstLaunchDate()
    }
    
    var body: some View {
            ZStack(alignment: .top) {
                Image("paywall_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                HStack{
                    Button(action: { withAnimation(.easeInOut(duration: 0.3)){
                        navigateToChatView = true
                    }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: { }) {
                        Text("Restore")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                    .padding(5)
                    .padding(.horizontal, 10)
                    .background(.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(.top, 40)
                .padding(.horizontal)
                
                VStack(alignment: .center) {
                    
                    Image("brokenHeartYellow")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 120)
                        .scaleEffect(1.5)
                    
                    Text("ExPremium")
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer().frame(height: 7)
                    
                    Text("Unlock everything")
                        .font(.custom("Inter", size: 17))
                        .foregroundStyle(Color(hex: "#FFD9AD"))
                    
                    Spacer().frame(height: 50)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(premiumTexts, id: \.self) { premiumText in
                            HStack(spacing: 15) {
                                Image("checkmarkYellow")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                
                                Text(premiumText)
                                    .font(.custom("Inter", size: 19))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    
                    Spacer().frame(height: 40)
                    
                    SubscriptionButton(
                        title: "Annual",
                        price: "$29/year",
                        selectedOption: selectedOption,
                        option: "Annual",
                        onSelect: {
                            selectedOption = "Annual"
                        })
                    
                    SubscriptionButton(
                        title: "Weekly",
                        price: "$5/week",
                        selectedOption: selectedOption,
                        option: "Weekly",
                        onSelect: {
                            selectedOption = "Weekly"
                        })
                    
                    Spacer().frame(height: 40)
                    
                    Button(action: {}) {
                        Text("Start 3-Day Free Trial")
                            .padding()
                            .font(.system(size: 19))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color(hex: "#FDA802"))
                    .cornerRadius(15)
                    .padding(.horizontal, 7)
                    
                    VStack {
                        Group {
                            Text("By subscribing to Ex, you agree to our")
                                .foregroundColor(Color(hex: "#484848")) +
                            Text(" Privacy Policy ")
                                .foregroundColor(Color(hex: "#8F8F8F")) +
                            Text("and ")
                                .foregroundColor(Color(hex: "#484848")) +
                            Text("Terms of Use")
                                .foregroundColor(Color(hex: "#8F8F8F"))
                        }
                    }
                    .multilineTextAlignment(.center)
                    .frame(width: 250)
                    .font(.custom("Inter", size: 14))
                    .padding(.top,10)
                    
                }
                .padding(.top, 100)
                .navigationBarBackButtonHidden(true)
                
                if navigateToChatView {
                    ChatView(style: ChatStyle(rawValue: userDefaultsManager.savedStyle) ?? .telegram, header: header)
                        .transition(.move(edge: .top))
                        .zIndex(1)
                }
            }
    }
}

