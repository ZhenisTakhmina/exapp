//
//  SubscriptionButton.swift
//  exappios
//
//  Created by Tami on 07.09.2024.
//

import SwiftUI

import SwiftUI

struct SubscriptionButton: View {
    let title: String
    let price: String
    let selectedOption: String
    let option: String
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: {
            onSelect()
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
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: selectedOption == option ? "#F0A94B" : "#484848"), lineWidth: 2)
                        
                        if selectedOption == option && option == "Annual" {
                            Text("Save 60%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(6)
                                .background(Color(hex: "#F0A94B"))
                                .foregroundColor(.black)
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity,
                                       maxHeight: .infinity,
                                       alignment: .top)
                                .offset(x: 10, y: -10)
                        }
                    }
                )
            }
        }
        .padding(.horizontal)
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
