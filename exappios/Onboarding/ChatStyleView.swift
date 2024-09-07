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
            ZStack(alignment: .bottom) {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                Image("chatScreen")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(0.9)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: "#2B2B2B"))
                    .frame(height: 450)
                    .overlay(
                        VStack(alignment: .leading) {
                            ChatOptionStyle(buttonName: "Continue")
                        }
                        .padding(.horizontal)
                    )
            }
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
    }
}

struct RadioButton: View {
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.green : Color.gray, lineWidth: 2)
                .frame(width: 25, height: 25)
            
            if isSelected {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
        }
    }
}

#Preview {
    ChatStyleView()
}
