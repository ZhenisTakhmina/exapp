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
    private var timer: Timer?
    
    
    init() {
        if isFirstLaunch() {
            fetchInitialMessages()
            saveFirstLaunchDate()
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
    
    private func saveFirstLaunchDate() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "firstLaunchDate") == nil {
            userDefaults.set(Date(), forKey: "firstLaunchDate")
        }
    }
    
    func calculateCurrentSendDay() -> Int {
        let userDefaults = UserDefaults.standard
        guard let firstLaunchDate = userDefaults.object(forKey: "firstLaunchDate") as? Date else {
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
        
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            self.fetchMessages(upTo: self.calculateCurrentSendDay())
        }
    }
    
    func stopFetchingMessages() {
        timer?.invalidate()
    }
    
    deinit {
        stopFetchingMessages()
    }
    
    func fetchMessages(upTo sendDay: Int) {
        print("Fetching messages for send day: \(sendDay)...")
        
        let sendDayString = String(sendDay)
        
        print("Message sendDay: \(sendDay), daysSinceInitial: \(calculateCurrentSendDay())")
        
        
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
            
            guard let scheduledTime = calculateScheduledTime(sendDay: sendDay - 1, sendTime: sendTime) else {
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
    
    func calculateScheduledTime(sendDay: Int, sendTime: String) -> Date? {
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
        
        guard let scheduledDate = calendar.date(byAdding: .day, value: sendDay - 1, to: startOfToday) else {
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
        // Filter initial messages
        self.initialMessages = fetchedMessages.filter { $0.isInitialMessage }
        print("Initial messages: \(self.initialMessages.count)")
        
        // Filter regular messages where the date has arrived and the time has passed
        let regularMessages = fetchedMessages.filter { !$0.isInitialMessage && shouldIncludeMessage($0) }
        print("Regular messages after filtering: \(regularMessages.count)")
        
        DispatchQueue.main.async {
            // Sort messages by scheduled time for display
            self.messages = regularMessages.sorted { $0.scheduledTime < $1.scheduledTime }
            print("Total messages to display: \(self.messages.count)")
            
            // Send initial messages
            self.sendInitialMessagesSequentially()
            
            // Schedule filtered regular messages
            self.scheduleRegularMessages(regularMessages)
        }
    }
    
    private func shouldIncludeMessage(_ message: Message) -> Bool {
        let currentDate = Date()
        
        // Check if the message date has arrived
        if message.scheduledTime > currentDate {
            return false
        }
        
        // If the message is scheduled for today, ensure the current time has passed the scheduled time
        let calendar = Calendar.current
        if calendar.isDate(message.scheduledTime, inSameDayAs: currentDate) {
            if message.scheduledTime > currentDate {
                return false
            }
        }
        
        return true
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
