//
//  SubscriptionButton.swift
//  exappios
//
//  Created by Tami on 07.09.2024.
//

import SwiftUI

struct SubscriptionButton: View {
    let title: String
    let price: String
    let selectedOption: String
    let option: String
    let onSelect: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.none) {
                onSelect()
            }
        }) {
            VStack {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(selectedOption == option ? .white : .gray)

                    Spacer()

                    Text(price)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(selectedOption == option ? Color(hex: "#F0A94B") : .gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: selectedOption == option ? "#F0A94B" : "#484848"), lineWidth: 2)

                        if option == "Annual" {
                            Text("Save 60%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(Color(hex: "#F0A94B"))
                                .foregroundColor(.black)
                                .cornerRadius(6)
                                .frame(maxWidth: .infinity,
                                       maxHeight: .infinity,
                                       alignment: .center)
                                .offset(x: 10)
                        }
                    }
                )
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .buttonStyle(NoOpacityButtonStyle())
    }
}




struct NoOpacityButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 1.0 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) 
    }
}



#Preview {
    SubscriptionButton(
        title: "Annual",
        price: "$29/year",
        selectedOption: "Annual",
        option: "Annual",
        onSelect: {
            
        })
}
