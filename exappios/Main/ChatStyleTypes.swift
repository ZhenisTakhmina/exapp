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
    
    var colorPalette: ColorPalette {
        switch self {
        case .imessage:
            return ColorPalette(headerBackground: Color(hex: "#F5F4F4"), backgroundColor: .white, chatBackgroundColor: Color(hex: "#E9E9EB"), dateInfoBoxBg: .clear , dateInfoTextColor: Color(hex: "#989898"))
        case .telegram:
            return ColorPalette(headerBackground: .white, backgroundColor: Color(hex: "#9EC481"), chatBackgroundColor: .white, dateInfoBoxBg: .black.opacity(0.27), dateInfoTextColor: .white)
        case .whatsapp:
            return ColorPalette(headerBackground: .white, backgroundColor: Color(hex: "CFFFBE"), chatBackgroundColor: .white, dateInfoBoxBg: .white.opacity(0.87), dateInfoTextColor: .black)
        }
    }
    
}

struct ColorPalette {
    let headerBackground: Color
    let backgroundColor: Color
    let chatBackgroundColor: Color
    let dateInfoBoxBg: Color
    let dateInfoTextColor: Color
}

struct ChatHeader {
    let title: String
    let subtitle: String
    let avatarImage: Image
}
