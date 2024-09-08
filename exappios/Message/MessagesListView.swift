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
        
    private var initialMessages: [Message] {
        viewModel.messages.filter { message in
            guard let sendDay = message.sendDay else {
                print("Message \(message.id) is filtered out due to missing sendDay.")
                return false
            }
            return sendDay == 0
        }
    }
    
    private var filteredMessages: [Message] {
        let now = Date()
        
        return viewModel.messages.filter { message in
            guard let sendDay = message.sendDay, sendDay >= 0 else {
                print("Message \(message.id) is filtered out due to missing")
                return false
            }
            
            let daysSinceInitial = viewModel.initialMessagesOffsetDays
            
            return sendDay <= daysSinceInitial && message.scheduledTime <= now
        }
    }

    
    private var groupedMessages: [String: [Message]] {
        Dictionary(grouping: filteredMessages, by: { formatDate($0.scheduledTime) })
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private func messageBubbles(for messages: [Message], isInitial: Bool) -> some View {
        LazyVStack(spacing: AppSettings.messageSpacing) {
            ForEach(messages, id: \.id) { message in
                MessageBubbleView(
                    message: message,
                    isLastMessage: message.id == messages.last?.id,
                    style: style
                )
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal)
    }
    
    private func groupedMessagesView() -> some View {
        LazyVStack(spacing: AppSettings.messageSpacing) {
            ForEach(groupedMessages.keys.sorted(), id: \.self) { date in
                Section(header: sectionHeader(date: date)) {
                    messageBubbles(for: groupedMessages[date] ?? [], isInitial: false)
                }
            }
        }
    }
    
    private func sectionHeader(date: String) -> some View {
        VStack(alignment: .leading) {
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
    }
    
    private var messageListView: some View {
        ScrollView {
            VStack {
//                if !initialMessages.isEmpty {
//                    messageBubbles(for: initialMessages, isInitial: true)
//                }
                groupedMessagesView()
            }
        }
    }
    
    var body: some View {
        messageListView
            .onAppear {
                viewModel.startFetchingMessages()
            }
            .onDisappear(
                perform: viewModel.stopFetchingMessages
            )
    }
}
