//
//  ChatStyleManager.swift
//  exappios
//
//  Created by Tami on 12.09.2024.
//

import SwiftUI

class ChatStyleManager: ObservableObject {
    @Published var selectedStyle: ChatStyle? {
        didSet {
            UserDefaults.standard.set(selectedStyle?.rawValue, forKey: "selectedChatStyle")
        }
    }
    
    init() {
        if let savedStyle = UserDefaults.standard.string(forKey: "selectedChatStyle") {
            self.selectedStyle = ChatStyle(rawValue: savedStyle)
        }
    }
}
