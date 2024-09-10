//
//  PrimaryButton.swift
//  exappios
//
//  Created by Tami on 07.09.2024.
//

import SwiftUI

struct PrimaryButton: View {
    
    let title: String
    let onSelect: () -> Void
    
    var body: some View {
        
        Button(action: onSelect){
            Text(title)
                .font(.system(size: 19))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#2A6A07"))
                .foregroundColor(.white)
                .cornerRadius(15)
        }
    }
}

#Preview {
    PrimaryButton(title: "hello", onSelect: {})
}
