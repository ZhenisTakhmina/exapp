//
//  MessagesListView.swift
//  exappios
//
//  Created by Tami on 03.09.2024.
//

import SwiftUI

struct MessageListView: View {
    
    @ObservedObject var viewModel: MessagesViewModel
    let style: ChatStyle
    
    private var groupedMessages: [String: [Message]] {
        Dictionary(grouping: viewModel.messages, by: { formatDate($0.scheduledTime) })
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private var messageListView: some View {
        ScrollView {
            VStack {
                Text("Бывшая заблокировал(а) вас")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(style.colorPalette.dateInfoTextColor)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(style.colorPalette.dateInfoBoxBg)
                    )
                
                LazyVStack(spacing: AppSettings.messageSpacing) {
                    ForEach(groupedMessages.keys.sorted(), id: \.self) { date in
                        Section(header:VStack(alignment: .leading) {
                            Text(date)
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
                            .padding(.bottom, 7)
                        ){
                            ForEach(groupedMessages[date] ?? [], id: \.id) { message in
                                MessageBubbleView(message: message, isLastMessage: message.id == viewModel.messages.last?.id, style: style)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    var body: some View {
        messageListView
    }
}


