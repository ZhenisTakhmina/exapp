import Foundation

enum MessageType: String, Codable {
    case text
    case image
}

struct Message: Identifiable, Equatable {
    let id: String
    let text: [String: String]
    let premium: Bool
    let scheduledTime: Date
    var isDelivered: Bool
    let isInitialMessage: Bool
    let sendDay: Int?
    let type: MessageType
    let contentUrl: String?
    
    init(id: String, text: [String: String], premium: Bool, scheduledTime: Date, isDelivered: Bool, isInitialMessage: Bool, sendDay: Int, type: MessageType, contentUrl: String? = nil) {
        self.id = id
        self.text = text
        self.premium = premium
        self.scheduledTime = scheduledTime
        self.isDelivered = isDelivered
        self.isInitialMessage = isInitialMessage
        self.sendDay = sendDay
        self.type = type
        self.contentUrl = contentUrl
    }
    
    var content: String {
        switch type {
        case .text:
            return text["ru"] ?? "No text"
        case .image:
            return contentUrl ?? "No image URL"
        }
    }
}
