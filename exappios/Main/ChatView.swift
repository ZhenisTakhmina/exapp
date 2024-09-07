//
//  ChatView.swift
//  exappios
//
//  Created by Tami on 30.08.2024.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var viewModel = MessagesViewModel()
    @State private var showExPremiumView = false
    @State private var showOnboardingView = false
    @State private var showChatView = false
    
    let style: ChatStyle
    let header: ChatHeader
    
    var body: some View {
        
        ZStack(alignment: .top){
            style.colorPalette.backgroundColor
                .ignoresSafeArea(.all)
            
            VStack {
                headerView
                messageListView
                footerView
            }
            .onAppear{
                showExPremiumView = true
                checkOnboardingStatus()
            }
            
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showExPremiumView) {
           ExPremiumView()
        }
        
    }
    
    private func checkOnboardingStatus() {
        if !UserDefaults.standard.bool(forKey: "onboardingCompleted") {
            showOnboardingView = true
        } else {
            showChatView = true
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .center) {
            NavigationLink(destination: SettingsView()){
                Image(systemName: "chevron.left")
                    .resizable()
                    .foregroundStyle(.blue)
                    .frame(width: 10, height: 20)
                    .padding()
            }
            .toolbar(.hidden)
            .navigationBarBackButtonHidden(true)
            
            switch style {
            case .telegram:
                VStack(alignment: .center, spacing: 5) {
                    Text(header.title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                    
                    Text(header.subtitle)
                        .font(.custom("Inter", size: 13))
                        .foregroundStyle(Color(hex: "#787878"))
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 7)
                
                header.avatarImage
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.trailing)
                    .padding(.bottom, 7)
                
                
            case .whatsapp:
                header.avatarImage
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.vertical, 10)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text(header.title)
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                    
                    Text(header.subtitle)
                        .font(.custom("Inter", size: 13))
                        .foregroundStyle(Color(hex: "#787878"))
                        .hidden()
                }
                .padding(.trailing)
                .padding(.top)
                
                Spacer()
                
                Image(systemName: "video")
                    .resizable()
                    .frame(width: 25, height: 22)
                    .padding(.trailing)
                
                Image(systemName: "phone")
                    .resizable()
                    .frame(width: 25, height: 22)
                    .padding(.trailing)
                
                
            case .imessage:
                VStack(alignment: .center, spacing: 5) {
                    header.avatarImage
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.bottom, 7)
                    
                    Text(header.title)
                        .font(.custom("Inter", size: 14))
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
                
                Image(systemName: "video")
                    .resizable()
                    .foregroundStyle(.gray)
                    .frame(width: 34, height: 25)
                    .padding(.trailing)
                    .padding(.bottom, 7)
            }
        }
        .frame(maxWidth: .infinity)
        .background(style.colorPalette.headerBackground)
    }
    
    private var messageListView: some View {
        MessageListView(viewModel: viewModel, style: style)
    }
    
    private var footerView: some View {
        Text("Вы заблокированы и не можете оставлять сообщения")
            .multilineTextAlignment(.center)
            .foregroundColor(Color(hex: "#949494"))
            .padding(.top)
            .frame(maxWidth: .infinity)
            .background(.white)
    }
}

#Preview {
    
    ChatView(style: .telegram, header: ChatHeader(title: "Ex", subtitle: "был(а) недавно", avatarImage: Image("avatar") ))
}
