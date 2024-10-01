//
//  UserDefaults.swift
//  exappios
//
//  Created by Tami on 29.08.2024.
//

import Foundation

struct UserDefaultsKeys {
    static let name = "name"
    static let birthday = "birthday"
    static let avatar = "avatar"
    static let exName = "exname"
    static let selectedChatStyle = "selectedChatStyle"
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
   func saveFirstLaunchDate() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "firstLaunchDate") == nil {
            userDefaults.set(Date(), forKey: "firstLaunchDate")
        }
    }
    
    var savedName: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.name) ?? ""
    }

    var savedExName: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.exName) ?? "Ex"
    }

    var savedAvatar: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? "avatar"
    }

    var savedStyle: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedChatStyle) ?? "Like Telegram"
    }
}
