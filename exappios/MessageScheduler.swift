import Foundation

class MessageScheduler: ObservableObject {
    @Published var scheduledMessages: [Message] = []
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    func scheduleMessage(_ message: Message) {
        scheduledMessages.append(message)
        scheduledMessages.sort { $0.scheduledTime < $1.scheduledTime }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkScheduledMessages()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkScheduledMessages() {
        let now = Date()
        let messagesToDeliver = scheduledMessages.filter { $0.scheduledTime <= now && !$0.isDelivered }
        
        for var message in messagesToDeliver {
            message.isDelivered = true
            NotificationCenter.default.post(name: .newMessageReceived, object: message)
        }
        
        scheduledMessages = scheduledMessages.filter { $0.scheduledTime > now || $0.isDelivered }
    }
}

extension Notification.Name {
    static let newMessageReceived = Notification.Name("newMessageReceived")
}
