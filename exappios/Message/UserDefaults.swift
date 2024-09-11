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
    static let onboardingCompleted = "onboardingCompleted"
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}

    var savedExName: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.exName) ?? "Ex"
    }

    var savedAvatar: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? "avatar"
    }

    var savedStyle: String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedChatStyle) ?? "Like Telegram"
    }

    var showOnboardingView: Bool {
        !UserDefaults.standard.bool(forKey: UserDefaultsKeys.onboardingCompleted)
    }

    func setOnboardingCompleted(_ completed: Bool) {
        UserDefaults.standard.set(completed, forKey: UserDefaultsKeys.onboardingCompleted)
    }
}
