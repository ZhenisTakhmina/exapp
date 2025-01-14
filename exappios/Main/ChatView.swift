//
//  ChatView.swift
//  exappios
//
//  Created by Tami on 30.08.2024.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var viewModel = MessagesViewModel()
    
    let style: ChatStyle
    let header: ChatHeader
    
    var currentStatusText: String {
        switch viewModel.currentStatus {
        case .online:
            ExAppStrings.Chat.statusOnline
        case .texting:
            ExAppStrings.Chat.statusTexting
        case .wasRecently:
            ExAppStrings.Chat.statusWasRecently
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                VStack(spacing: 0) {
                    headerView
                    messageListView
                    footerView
                }
            }
            .background(
                Group {
                    if style == .whatsapp {
                        style.colorPalette.backgroundImage?
                            .resizable()
                            .scaledToFill()
                    } else {
                        style.colorPalette.backgroundColor
                    }
                })
            .toolbar(.hidden)
            .navigationBarBackButtonHidden(true)
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
            
            switch style {
            case .telegram:
                VStack(alignment: .center, spacing: 5) {
                    Text(header.title)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    Text(currentStatusText)
                        .font(.system(size: 12))
                        .foregroundStyle( currentStatusText == ExAppStrings.Chat.statusWasRecently ? Color(hex: "#787878") : Color.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 7)
                
                header.avatarImage
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .padding(.trailing)
                    .padding(.bottom, 7)
                
                
            case .whatsapp:
                header.avatarImage
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .padding(.vertical, 10)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text(header.title)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    Text(currentStatusText)
                        .font(.system(size: 12))
                        .foregroundStyle( currentStatusText == ExAppStrings.Chat.statusWasRecently ? Color(hex: "#787878") : Color.blue)
                }
                .padding(.trailing)
                
                Spacer()
                
                Image(systemName: "video")
                    .resizable()
                    .foregroundStyle(Color(hex: "#777777"))
                    .frame(width: 22, height: 18)
                    .padding(.trailing)
                
                Image(systemName: "phone")
                    .resizable()
                    .foregroundStyle(Color(hex: "#777777"))
                    .frame(width: 22, height: 18)
                    .padding(.trailing)
                
                
            case .imessage:
                VStack(alignment: .center, spacing: 5) {
                    header.avatarImage
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.bottom, 7)
                    
                    Text(header.title)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
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
    
    private func initialMessageHeader() -> some View {
        VStack(alignment: .leading) {
            Text("Ex has blocked you")
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundStyle(style.colorPalette.dateInfoTextColor)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(style.colorPalette.dateInfoBoxBg)
                )
        }
        .padding(.top, 15)
        .padding(.bottom, 5)
    }
    
    private var messageListView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                initialMessageHeader()
                MessageListView(viewModel: viewModel, style: style)
                Color.clear.frame(height: 1).id("bottom")
            }
            .defaultScrollAnchor(.bottom)
        }
    }
    
    private var footerView: some View {
        Text(ExAppStrings.Chat.youBlocked)
            .multilineTextAlignment(.center)
            .foregroundColor(Color(hex: "#8D8D93"))
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(style.colorPalette.headerBackground)
    }
}


