import Foundation
import FirebaseFirestore

class MessagesViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var errorMessage: String?
    private var allMessages: [Message] = []
    private var db = Firestore.firestore()
    private var scheduler = MessageScheduler()
    @Published var initialMessages: [Message] = []
    private var isDeliveringMessage = false
    private var isInitialMessageDeliveryInProgress = false
    private var firstDayMessages: [FirstDayMessage] = []
    var initialMessagesReceivedDate: Date?
    private var timer: Timer?
    
    private var currentDate: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
   var initialMessagesOffsetDays: Int {
        guard let initialMessagesDate = initialMessagesReceivedDate else {
            return 0
        }
        let days = Calendar.current.dateComponents([.day], from: initialMessagesDate, to: currentDate).day ?? 0
        return max(0, days)
    }
    
    
    init() {
        if isFirstLaunch() {
            fetchInitialMessages()
            saveFirstLaunchDate()
        } else {
            fetchMessages(for: calculateCurrentSendDay())
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
    
    private func saveFirstLaunchDate() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "firstLaunchDate") == nil {
            userDefaults.set(Date(), forKey: "firstLaunchDate")
        }
    }
    
    private func calculateCurrentSendDay() -> Int {
        let userDefaults = UserDefaults.standard
        guard let firstLaunchDate = userDefaults.object(forKey: "firstLaunchDate") as? Date else {
            return 0
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        let daysSinceFirstLaunch = calendar.dateComponents([.day], from: firstLaunchDate, to: currentDate).day ?? 0
        
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
        fetchMessages(for: initialMessagesOffsetDays )
        
        timer = Timer.scheduledTimer(withTimeInterval: 50, repeats: true) { _ in
            self.fetchMessages(for: self.initialMessagesOffsetDays)
        }
    }
    
    func stopFetchingMessages() {
        timer?.invalidate()
    }
    
    deinit {
        stopFetchingMessages()
    }
    
    func fetchMessages(for sendDay: Int) {
        print("Fetching messages for send day: \(sendDay)...")
        
        let sendDayString = String(sendDay) // Convert sendDay to String for Firestore query
        
        db.collection("messages").whereField("send_day", isEqualTo: sendDayString).getDocuments { [weak self] (querySnapshot, error) in
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
            
            if sendDay == 0 {
                self.initialMessagesReceivedDate = Date()
            }
        }
    }
    
    private func processFetchedDocuments(_ querySnapshot: QuerySnapshot?) -> [Message] {
        guard let documents = querySnapshot?.documents else {
            print("No documents found")
            return []
        }
        
        return documents.compactMap { document -> Message? in
            let data = document.data()
            let id = document.documentID
            
            print("Processing document with ID: \(id)")
            print("Document data: \(data)")
            
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
            
            guard let scheduledTime = calculateScheduledTime(sendDay: sendDay, sendTime: sendTime) else {
                print("Failed to calculate scheduled time for document \(id)")
                return nil
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
            return message
        }
    }
    
    private func calculateScheduledTime(sendDay: Int, sendTime: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        
        guard let timeDate = dateFormatter.date(from: sendTime) else {
            print("Invalid time format: \(sendTime)")
            return nil
        }
        
        let now = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        
        let todayWithTime = calendar.date(bySettingHour: calendar.component(.hour, from: timeDate),
                                          minute: calendar.component(.minute, from: timeDate),
                                          second: 0, of: startOfToday)
        
        if sendDay == 0 {
            return todayWithTime
        } else {
            guard let scheduledDate = calendar.date(byAdding: .day, value: sendDay, to: startOfToday) else {
                return nil
            }
            return calendar.date(bySettingHour: calendar.component(.hour, from: timeDate),
                                 minute: calendar.component(.minute, from: timeDate),
                                 second: 0, of: scheduledDate)
        }
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
        
        let regularMessages = fetchedMessages.filter { !$0.isInitialMessage }
        print("Regular messages: \(regularMessages.count)")
        
        DispatchQueue.main.async {
            self.messages = fetchedMessages.sorted { $0.scheduledTime < $1.scheduledTime }
            print("Total messages to display: \(self.messages.count)")
            
            // Send initial messages
            self.sendInitialMessagesSequentially()
            
            // Schedule regular messages
            self.scheduleRegularMessages(regularMessages)
        }
    }
    
    private func sendInitialMessagesSequentially() {
        for message in initialMessages {
            self.deliverMessage(message)
        }
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
