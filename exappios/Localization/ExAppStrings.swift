//
//  ExAppStrings.swift
//  exappios
//
//  Created by Tami on 30.09.2024.
//

import Foundation

public enum ExAppStrings {
    
    public enum Onboarding {
      public static let turnNotification = ExAppStrings.tr("Localizable", "onboarding.turnNotification")
    public static let subtitleText = ExAppStrings.tr("Localizable", "onboarding.subtitle_text")
    public static let continueButton = ExAppStrings.tr("Localizable", "onboarding.continue")
    public static let aboutYou = ExAppStrings.tr("Localizable", "onboarding.about_you")
    public static let yourName = ExAppStrings.tr("Localizable", "onboarding.your_name")
    public static let birthday = ExAppStrings.tr("Localizable", "onboarding.birthday")
    public static let selectBirthday = ExAppStrings.tr("Localizable", "onboarding.selectBirthday")
    public static let fillCorrectly = ExAppStrings.tr("Localizable", "onboarding.fillCorrectly")
    public static let chooseAvatar = ExAppStrings.tr("Localizable", "onboarding.choose_avatar")
    public static let aboutEx = ExAppStrings.tr("Localizable", "onboarding.aboutEx")
    public static let chatStyle = ExAppStrings.tr("Localizable", "onboarding.chat_style")
    public static let likeTelegram = ExAppStrings.tr("Localizable", "onboarding.likeTelegram")
    public static let likeWhatsapp = ExAppStrings.tr("Localizable", "onboarding.likeWhatsapp")
    public static let likeImessage = ExAppStrings.tr("Localizable", "onboarding.likeImessage")
    public static let openSettings = ExAppStrings.tr("Localizable", "onboarding.openSettings")
    public static let cancel = ExAppStrings.tr("Localizable", "onboarding.cancel")
    public static let alertMessage = ExAppStrings.tr("Localizable", "onboarding.alertMessage")
        
    }
    
    public enum PayWall {
    public static let exPremium = ExAppStrings.tr("Localizable", "paywall.exPremium")
    public static let unlock = ExAppStrings.tr("Localizable", "paywall.unlock")
    public static let exesText = ExAppStrings.tr("Localizable", "paywall.exesText")
    public static let hiddenPhotos = ExAppStrings.tr("Localizable", "paywall.hiddenPhotos")
    public static let changeName = ExAppStrings.tr("Localizable", "paywall.changeName")
    public static let changeAvatar = ExAppStrings.tr("Localizable", "paywall.changeAvatar")
    public static let annual = ExAppStrings.tr("Localizable", "paywall.annual")
    public static let weekly = ExAppStrings.tr("Localizable", "paywall.weekly")
    public static let save60 = ExAppStrings.tr("Localizable", "paywall.save60")
    public static let startFree = ExAppStrings.tr("Localizable", "paywall.startFree")
    public static let restore = ExAppStrings.tr("Localizable", "paywall.restore")
    public static let privacyPolicy1 = ExAppStrings.tr("Localizable", "paywall.privacyPolicy1")
    public static let privacyPolicy2 = ExAppStrings.tr("Localizable", "paywall.privacyPolicy2")
    public static let privacyPolicy3 = ExAppStrings.tr("Localizable", "paywall.privacyPolicy3")
    public static let privacyPolicy4 = ExAppStrings.tr("Localizable", "paywall.privacyPolicy4")
        
    }
    
    public enum Settings {
        public static let exName = ExAppStrings.tr("Localizable", "settings.exName")
        public static let exAvatar = ExAppStrings.tr("Localizable", "settings.exAvatar")
        public static let saveButton = ExAppStrings.tr("Localizable", "settings.saveButton")
        public static let premium = ExAppStrings.tr("Localizable", "settings.premium")
        public static let settings = ExAppStrings.tr("Localizable", "settings.settings")
    }
    
    
    public enum Chat {
      public static let youBlocked = ExAppStrings.tr("Localizable", "chat.youBlocked")
      public static let exBlocked = ExAppStrings.tr("Localizable", "chat.exBlocked")
      public static let statusOnline = ExAppStrings.tr("Localizable", "chat.statusOnline")
      public static let statusTexting = ExAppStrings.tr("Localizable", "chat.statusTexting")
      public static let statusWasRecently = ExAppStrings.tr("Localizable", "chat.statusWasRecently")

    }
}

extension ExAppStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {
    static let bundle = Bundle(for: BundleToken.self)
}
