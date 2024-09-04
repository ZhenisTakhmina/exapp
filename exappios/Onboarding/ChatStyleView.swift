//
//  ChatStyleView.swift
//  exappios
//
//  Created by Tami on 26.08.2024.
//

import SwiftUI

struct ChatStyleView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                Image("chatScreen")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(0.9)
                
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#2B2B2B"))
                        .frame(height: 350)
                        .overlay(
                            VStack(alignment: .leading) {
                                ChatOptionStyle(buttonName: "Continue")
                            }
                                .padding(.horizontal)
                        )
                }
            }
        }
    }
}

struct RadioButton: View {
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.white : Color.gray, lineWidth: 2)
                .frame(width: 25, height: 25)
            
            if isSelected {
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
            }
        }
    }
}

#Preview {
    ChatStyleView()
}
