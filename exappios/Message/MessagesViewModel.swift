import Foundation
import FirebaseFirestore

class MessagesViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messagesUpdated: Bool = false
    private var db = Firestore.firestore()
    private var scheduler = MessageScheduler()
    @Published var initialMessages: [Message] = []
    private var isDeliveringMessage = false
    private var isInitialMessageDeliveryInProgress = false
    private var timer: Timer?
    private var firstLaunchDate = UserDefaults.standard.object(forKey: "firstLaunchDate")
    private let notification = NotificationManager.shared
    
    
    
    init() {
        if isFirstLaunch() {
            fetchInitialMessages()
        } else {
            fetchMessages(upTo: calculateCurrentSendDay())
        }
    }
    
    private func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "HasLaunchedBefore") {
            return false
        } else {
            defaults.set(true, forKey: "HasLaunchedBefore")
            return true
        }
    }
    
    func calculateCurrentSendDay() -> Int {
        let userDefaults = UserDefaults.standard
        guard let firstLaunchDate = firstLaunchDate as? Date else {
            return 0
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        let startOfFirstLaunchDate = calendar.startOfDay(for: firstLaunchDate)
        let startOfCurrentDate = calendar.startOfDay(for: currentDate)
        
        let daysSinceFirstLaunch = calendar.dateComponents([.day], from: startOfFirstLaunchDate, to: startOfCurrentDate).day ?? 0
        
        return daysSinceFirstLaunch
    }
    
    
    private func fetchInitialMessages() {
        db.collection("messages").whereField("send_day", isEqualTo: 0).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting initial messages: \(error)")
                return
            }
            let initialMessages = self.processFetchedDocuments(querySnapshot)
            self.processInitialMessages(initialMessages)
        }
    }
    
    func startFetchingMessages() {
        fetchMessages(upTo: calculateCurrentSendDay())
        fetchInitialMessages()
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.fetchMessages(upTo: self.calculateCurrentSendDay())
        }
        
    }
    
    func stopFetchingMessages() {
        timer?.invalidate()
    }
    
    deinit {
        notification.cancelAllNotifications()
        stopFetchingMessages()
    }
    
    func fetchMessages(upTo sendDay: Int) {
        
        let sendDayString = String(sendDay)
        
        db.collection("messages").whereField("send_day", isLessThanOrEqualTo: sendDayString).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let querySnapshot = querySnapshot, !querySnapshot.documents.isEmpty else {
                print("No messages found for send day \(sendDay).")
                return
            }
            
            print("Fetched \(querySnapshot.documents.count) messages for send day \(sendDay).")
            
            let fetchedMessages = self.processFetchedDocuments(querySnapshot)
            self.processMessages(fetchedMessages)
        }
    }
    
    private func processFetchedDocuments(_ querySnapshot: QuerySnapshot?) -> [Message] {
        guard let documents = querySnapshot?.documents else {
            print("No documents found")
            return []
        }
        
        let messages: [Message] = documents.compactMap { document -> Message? in
            let data = document.data()
            let id = document.documentID
            
            guard let typeString = data["type"] as? String,
                  let type = MessageType(rawValue: typeString),
                  let premium = data["premium"] as? Bool,
                  let sendDayString = data["send_day"] as? String,
                  let sendDay = Int(sendDayString),
                  let sendTime = data["send_time"] as? String else {
                print("Invalid document structure for document \(id)")
                return nil
            }
            
            var text: [String: String] = [:]
            var contentUrl: String?
            
            switch type {
            case .text:
                guard let textData = data["text"] as? [String: String] else {
                    print("Invalid text data for document \(id)")
                    return nil
                }
                text = textData
            case .image:
                guard let url = data["content_url"] as? String else {
                    print("Invalid content_url for document \(id)")
                    return nil
                }
                contentUrl = url
            }
            
            let scheduledTime: Date
            
            if sendDay == 0 {
                if let firstLaunchDate = firstLaunchDate as? Date {
                    scheduledTime = firstLaunchDate
                } else {
                    print("firstLaunchDate is nil")
                    return nil
                }
                
            } else {
                guard let calculatedTime = calculateScheduledTime(sendDay: sendDay, sendTime: sendTime) else {
                    print("Failed to calculate scheduled time for document \(id)")
                    return nil
                }
                scheduledTime = calculatedTime
            }
            
            let message = Message(id: id,
                                  text: text,
                                  premium: premium,
                                  scheduledTime: scheduledTime,
                                  isDelivered: false,
                                  isInitialMessage: sendDay == 0,
                                  sendDay: sendDay,
                                  type: type,
                                  contentUrl: contentUrl)
            
            print("Successfully processed message: \(message)")
            
            notification.scheduleNotification(for: message){ error in
                if let error = error {
                    print("Failed to schedule notification: \(error)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
            
            return message
        }
        
        let sortedMessages = messages.sorted(by: { $0.scheduledTime < $1.scheduledTime })
        
        return sortedMessages
    }
    
    func calculateScheduledTime(sendDay: Int, sendTime: String) -> Date? {
        let formatter = DateFormatterManager.shared.timeFormatterInstance()
        let formatter1 = DateFormatterManager.shared.fullDateTimeFormatterInstance()
        
        guard let timeDate = formatter.date(from: sendTime) else {
            print("Invalid time format: \(sendTime)")
            return nil
        }
        let now = Date()
        let calendar = Calendar.current
        
        guard let firstLaunchDate = firstLaunchDate as? Date else { return now }
        
        let startOfFirstLaunchDate = calendar.startOfDay(for: firstLaunchDate)
        
        guard let scheduledDate = calendar.date(byAdding: .day, value: sendDay, to: startOfFirstLaunchDate) else {
            return nil
        }
        
        let todayWithTime = calendar.date(bySettingHour: calendar.component(.hour, from: timeDate),
                                          minute: calendar.component(.minute, from: timeDate),
                                          second: 0, of: scheduledDate)
        
        return todayWithTime
    }
    
    
    private func processInitialMessages(_ messages: [Message]) {
        self.initialMessages = messages
        DispatchQueue.main.async {
            self.messages = messages
            self.sendInitialMessagesSequentially()
        }
    }
    
    private func processMessages(_ fetchedMessages: [Message]) {
        self.initialMessages = fetchedMessages.filter { $0.isInitialMessage }
        print("Initial messages: \(self.initialMessages.count)")
        
        let regularMessages = fetchedMessages.filter { !$0.isInitialMessage && shouldIncludeMessage($0) }
        print("Regular messages after filtering: \(regularMessages.count)")
        
        DispatchQueue.main.async {
            self.messages = regularMessages.sorted { $0.scheduledTime < $1.scheduledTime }
            print("Total messages to display: \(self.messages.count)")
            
            self.sendInitialMessagesSequentially()
            self.scheduleRegularMessages(regularMessages)
            
            DispatchQueue.main.async {
                self.messagesUpdated.toggle()
            }
        }
    }
    
    private func shouldIncludeMessage(_ message: Message) -> Bool {
        let currentDate = Date()
        
        if message.scheduledTime > currentDate {
            return false
        }
        
        let calendar = Calendar.current
        if calendar.isDate(message.scheduledTime, inSameDayAs: currentDate) {
            if message.scheduledTime > currentDate {
                return false
            }
        }
        
        return true
    }
    
    
    
    private func sendInitialMessagesSequentially() -> Date? {
        guard let firstLaunchDate = firstLaunchDate as? Date else {
            print("Error: firstLaunchDate is nil")
            return nil
        }
        
        var delay: TimeInterval = 0
        let messageInterval: TimeInterval = 600
        var lastScheduledTime: Date?
        
        for message in initialMessages {
            let scheduledTime = firstLaunchDate.addingTimeInterval(delay)
            lastScheduledTime = scheduledTime
            
            let timeIntervalToSchedule = scheduledTime.timeIntervalSince(Date())
            if timeIntervalToSchedule <= 0 {
                self.deliverMessage(message)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeIntervalToSchedule) {
                    self.deliverMessage(message)
                }
            }
            print("Message \(message.id) will be delivered at \(scheduledTime)")
            
            delay += messageInterval
        }
        
        return lastScheduledTime
    }
    
    
    private func scheduleRegularMessages(_ messages: [Message]) {
        for message in messages {
            scheduler.scheduleMessage(message)
            print("Scheduled message: ID: \(message.id), Text: \(message.text["ru"] ?? "No text"), ScheduledTime: \(message.scheduledTime)")
        }
    }
    
    private func deliverMessage(_ message: Message) {
        var updatedMessage = message
        updatedMessage.isDelivered = true
        
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            messages[index] = updatedMessage
        } else {
            messages.append(updatedMessage)
        }
        
        print("Delivered message: ID: \(message.id), Text: \(message.text["ru"] ?? "No text")")
    }
}
