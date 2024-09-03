import Foundation

struct FirstDayMessage: Identifiable {
    let id: String
    let sendTime: Date
    let text: [String: String]
    let type: MessageType
    
    init?(id: String, data: [String: Any]) {
        self.id = id
        
        guard let sendTimeString = data["send_time"] as? String,
              let text = data["text"] as? [String: String],
              let typeString = data["type"] as? String,
              let type = MessageType(rawValue: typeString) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let sendTime = dateFormatter.date(from: sendTimeString) else {
            return nil
        }
        
        self.sendTime = sendTime
        self.text = text
        self.type = type
    }
}
