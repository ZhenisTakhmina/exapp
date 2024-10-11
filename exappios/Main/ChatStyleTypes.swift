//
//  ChatStyleTypes.swift
//  exappios
//
//  Created by Tami on 30.08.2024.
//

import SwiftUI

enum ChatStyle: String {
    
    case imessage = "Like iMessage"
    case telegram = "Like Telegram"
    case whatsapp = "Like WhatsApp"
    
    func localizedTitle() -> String {
           switch self {
           case .imessage:
               return ExAppStrings.Onboarding.likeImessage
           case .telegram:
               return ExAppStrings.Onboarding.likeTelegram
           case .whatsapp:
               return ExAppStrings.Onboarding.likeWhatsapp
           }
       }
    
    var colorPalette: ColorPalette {
        switch self {
        case .imessage:
            return ColorPalette(headerBackground: Color(hex: "#181818"), backgroundColor: .black, backgroundImage: nil, chatBackgroundColor: Color(hex: "#232629"), dateInfoBoxBg: .clear , dateInfoTextColor: .white )
        case .telegram:
            return ColorPalette(headerBackground: Color(hex: "#181818"), backgroundColor: .black, backgroundImage: nil, chatBackgroundColor: Color(hex: "#201E23"), dateInfoBoxBg:  Color(hex: "#1E1E1E"), dateInfoTextColor: .white)
        case .whatsapp:
            return ColorPalette(headerBackground: Color(hex: "#181818"), backgroundColor: .clear, backgroundImage: Image("wa_pattern-1"), chatBackgroundColor: Color(hex: "#232626"), dateInfoBoxBg: Color(hex: "#1E1E1E"), dateInfoTextColor: .white)
        }
    }
    
}

struct ColorPalette {
    let headerBackground: Color
    let backgroundColor: Color
    let backgroundImage: Image?
    let chatBackgroundColor: Color
    let dateInfoBoxBg: Color
    let dateInfoTextColor: Color
}

struct ChatHeader {
    let title: String
    let avatarImage: Image
}
