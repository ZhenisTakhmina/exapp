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
    
    init() {
        fetchMessages()
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
    
    private func fetchFirstDayMessages() {
        db.collection("firstDayMessages").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting first day messages: \(error)")
                return
            }
            self.firstDayMessages = querySnapshot?.documents.compactMap { FirstDayMessage(id: $0.documentID, data: $0.data()) } ?? []
            self.scheduleFirstDayMessages()
        }
    }
    
    private func scheduleFirstDayMessages() {
            let now = Date()
            let calendar = Calendar.current
            
            for message in firstDayMessages {
                // Получаем компоненты времени из message.sendTime
                let messageTimeComponents = calendar.dateComponents([.hour, .minute], from: message.sendTime)
                
                // Создаем новую дату, комбинируя текущую дату с временем сообщения
                guard let scheduledTime = calendar.date(bySettingHour: messageTimeComponents.hour ?? 0,
                                                        minute: messageTimeComponents.minute ?? 0,
                                                        second: 0,
                                                        of: now) else {
                    continue
                }
                
                // Сравниваем с текущим временем
                if scheduledTime > now {
                    let newMessage = Message(id: message.id,
                                             text: message.text,
                                             premium: false,
                                             scheduledTime: scheduledTime,
                                             isDelivered: false,
                                             isInitialMessage: false,
                                             sendDay: 0,
                                             type: message.type)
                    scheduler.scheduleMessage(newMessage)
                }
            }
        }
    
    private func processInitialMessages(_ messages: [Message]) {
        self.initialMessages = messages
        DispatchQueue.main.async {
            self.messages = messages
            self.sendInitialMessagesSequentially()
        }
    }
    
    private func saveFirstLaunchDate() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "firstLaunchDate") == nil {
            userDefaults.set(Date(), forKey: "firstLaunchDate")
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewMessage), name: .newMessageReceived, object: nil)
    }
    
    @objc private func handleNewMessage(_ notification: Notification) {
        if let message = notification.object as? Message {
            print("Received new message notification at \(Date())")
            DispatchQueue.main.async {
                self.deliverMessage(message)
            }
        }
    }
    
    func fetchMessages() {
        print("Fetching messages...")
        db.collection("messages").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
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
        
        guard let timeDate = dateFormatter.date(from: sendTime) else {
            print("Invalid time format: \(sendTime)")
            return nil
        }
        
        let now = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        
        if sendDay == 0 {
            return calendar.date(byAdding: .second, value: Int(timeDate.timeIntervalSince1970), to: startOfToday)
        } else {
            guard let scheduledDate = calendar.date(byAdding: .day, value: sendDay, to: startOfToday) else {
                return nil
            }
            return calendar.date(bySettingHour: calendar.component(.hour, from: timeDate),
                                 minute: calendar.component(.minute, from: timeDate),
                                 second: 0, of: scheduledDate)
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
            
            // Отправляем начальные сообщения
            self.sendInitialMessagesSequentially()
            
            // Планируем регулярные сообщения
            self.scheduleRegularMessages(regularMessages)
        }
    }
    
    private func sendInitialMessagesSequentially() {
        for message in initialMessages {
            self.deliverMessage(message)
        }
    }

    private func sendNextInitialMessage() {
        guard !initialMessages.isEmpty else {
            isInitialMessageDeliveryInProgress = false
            print("Finished sending initial messages.")
            return
        }
        
        let message = initialMessages.removeFirst()
        let delay = calculateDelay(for: message.text["ru"] ?? "")
        
        print("Sending initial message:")
        print("  ID: \(message.id)")
        print("  Text: \(message.text["ru"] ?? "No text")")
        print("  Delay: \(delay) seconds")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.deliverMessage(message)
            self?.sendNextInitialMessage()
        }
    }

    private func calculateDelay(for text: String) -> TimeInterval {
        let symbolCount = text.count
        let typeSpeed: Double = 40.0  // символов в минуту
        return (Double(symbolCount) / 5.0) * (60.0 / typeSpeed)  // Преобразуем минуты в секунды
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
    
    private func scheduleRegularMessages(_ messages: [Message]) {
        for message in messages {
            scheduler.scheduleMessage(message)
            print("Scheduled message: ID: \(message.id), Text: \(message.text["ru"] ?? "No text"), ScheduledTime: \(message.scheduledTime)")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
