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
    
    
    private func formatDateToTimeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    private var filteredMessages: [Message] {
        let now = Date()
        
        return viewModel.messages.filter { message in
            guard let sendDay = message.sendDay, sendDay >= 0 else {
                return false
            }
            let sendTimeString = formatDateToTimeString(message.scheduledTime)
            
            guard let scheduledTime = viewModel.calculateScheduledTime(sendDay: sendDay, sendTime: sendTimeString) else {
                return false
            }
            return scheduledTime <= now
        }
    }
    
    private var groupedMessages: [Date: [Message]] {
        let calendar = Calendar.current
        return Dictionary(grouping: filteredMessages, by: { message in
            calendar.startOfDay(for: message.scheduledTime)
        })
    }
    
    private var sortedGroupedMessages: [(key: Date, value: [Message])] {
        groupedMessages.sorted { $0.key < $1.key }
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
            ForEach(sortedGroupedMessages, id: \.key) { (date, messages) in
                let messagesForDate = groupedMessages[date] ?? []
                let hasInitialMessages = messagesForDate.contains { $0.isInitialMessage }
                
                if !hasInitialMessages {
                    Section(header: sectionHeader(date: date)) {
                        messageBubbles(for: messagesForDate, isInitial: false)
                    }
                } else {
                    messageBubbles(for: messagesForDate, isInitial: true)
                }
            }
        }
    }
    
    private func sectionHeader(date: Date) -> some View {
        VStack(alignment: .leading) {
            Text(formatDate(date))
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
