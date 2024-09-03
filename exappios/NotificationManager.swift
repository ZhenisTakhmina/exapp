import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            completion(granted, error)
        }
    }
    
    func checkNotificationSettings(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func scheduleNotification(for message: Message, completion: @escaping (Error?) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "New Message"
        content.body = message.text["ru"] ?? "New message received"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: message.scheduledTime.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: message.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
            completion(error)
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
