//
//  MessagesListView.swift
//  exappios
//
//  Created by Tami on 03.09.2024.
//

import SwiftUI

struct MessageListView: View {
    @ObservedObject var viewModel: MessagesViewModel
    @ObservedObject var scheduler: MessageScheduler
    let style: ChatStyle
    let formatter = DateFormatterManager.shared.dayFormatterInstance()
    
    private var groupedMessages: [Date: [Message]] {
        let calendar = Calendar.current
        return Dictionary(grouping: viewModel.messages, by: { message in
            calendar.startOfDay(for: message.scheduledTime)
        })
    }
    
    private var sortedGroupedMessages: [(key: Date, value: [Message])] {
        groupedMessages.sorted { $0.key < $1.key }
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
            Text(formatter.string(from: date))
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
            groupedMessagesView()
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
