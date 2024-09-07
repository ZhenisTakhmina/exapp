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
    
    
    private var currentDate: Date {
            Calendar.current.startOfDay(for: Date())
        }
        
        private var initialMessagesDate: Date? {
            viewModel.initialMessagesReceivedDate
        }
        
        private var initialMessagesOffsetDays: Int {
            guard let initialMessagesDate = initialMessagesDate else {
                return 0
            }
            let days = Calendar.current.dateComponents([.day], from: initialMessagesDate, to: currentDate).day ?? 0
            return max(0, days)
        }
        
        private var filteredMessages: [Message] {
            let showFromDay = 1 // день, с которого сообщения начинают отображаться
            
            print("Initial Messages Offset Days: \(initialMessagesOffsetDays)")
            
            return viewModel.messages.filter { message in
                guard let sendDay = message.sendDay, sendDay > 0 else {
                    print("Message \(message.id) is filtered out due to sendDay: \(message.sendDay ?? -1)")
                    return false
                }
                
                let daysSinceInitial = initialMessagesOffsetDays + sendDay
                
                print("Message \(message.id) - sendDay: \(sendDay), daysSinceInitial: \(daysSinceInitial)")
                
                return daysSinceInitial >= showFromDay
            }
        }


    private var groupedMessages: [String: [Message]] {
        let filteredMessages = filteredMessages
        print("filteredMessages: \(filteredMessages)")
        return Dictionary(grouping: filteredMessages, by: { formatDate($0.scheduledTime) })
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
                if !viewModel.initialMessages.isEmpty {
                    messageBubbles(for: viewModel.initialMessages, isInitial: true)
                }
                groupedMessagesView()
            }
        }
    }
    
    var body: some View {
        messageListView
            .onAppear {
                viewModel.fetchMessages()
            }
    }
}
