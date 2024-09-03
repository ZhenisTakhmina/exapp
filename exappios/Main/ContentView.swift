import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MessagesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: AppSettings.messageSpacing) {
                    ForEach(viewModel.messages) { message in
                        MessageBubbleView(message: message, isLastMessage: message.id == viewModel.messages.last?.id, style: .telegram)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Messages")
            .onAppear {
                self.viewModel.fetchMessages()
            }
        }
    }
}
