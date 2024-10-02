import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func scheduleNotification(for message: Message, completion: @escaping (Error?) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = UserDefaultsManager.shared.savedExName
        content.body = message.text["en"] ?? "New message received"
        content.sound = .default
        
        let now = Date()
        
        guard message.scheduledTime > now else {
            print("Scheduled time is in the past, cannot schedule notification.")
            completion(NSError(domain: "NotificationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Scheduled time is in the past"]))
            return
        }
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: message.scheduledTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: message.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
                completion(error)
            } else {
                print("Notification scheduled for \(message.scheduledTime)")
                completion(nil)

            }
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Pending notifications: \(requests)")
        }

    }

    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
