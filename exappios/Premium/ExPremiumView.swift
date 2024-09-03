//
//  ExPremiumView.swift
//  exappios
//
//  Created by Tami on 27.08.2024.
//

import SwiftUI

struct ExPremiumView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedOption: String = "Weekly"
    
    let premiumTexts = ["Exes text more", "See hidden photos", "Change name", "Change avatar"]
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [.yellow.opacity(0.55), .black]), startPoint: .top, endPoint: .center)
                .edgesIgnoringSafeArea(.all)
            
            HStack{
                Button(action: { presentationMode.wrappedValue.dismiss()}) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: { presentationMode.wrappedValue.dismiss()}) {
                    Text("Restore")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                .padding(5)
                .padding(.horizontal, 10)
                .background(.black.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding(.top, 15)
            .padding(.horizontal)
            
            VStack(alignment: .center) {
                
                Image("brokenHeartYellow")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 120)
                    .scaleEffect(1.5)
                
                Text("ExPremium")
                    .font(.custom("Inter", size: 38).bold())
                    .foregroundStyle(.white)
                
                Spacer().frame(height: 7)
                
                Text("Unlock everything")
                    .font(.custom("Inter", size: 17))
                    .foregroundStyle(Color(hex: "#FFD9AD"))
                
                Spacer().frame(height: 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(premiumTexts, id: \.self) { premiumText in
                        HStack(spacing: 15) {
                            Image("checkmarkYellow")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text(premiumText)
                                .font(.custom("Inter", size: 19))
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                Spacer().frame(height: 40)
                
                Button(action: {
                    selectedOption = "Annual"
                }) {
                    VStack {
                        Text("Save 60%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(6)
                            .background(Color(hex: "#F0A94B"))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .offset(y: -12)
                        
                        HStack {
                            Text("Annual")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("$29 / year")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            selectedOption == "Annual" ? Color(.red).opacity(0.45) : Color.clear
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#F0A94B"), lineWidth: 2)
                        )
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    selectedOption = "Weekly"
                }) {
                    HStack {
                        Text("Weekly")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(selectedOption == "Weekly" ? .white : .gray)
                        
                        Spacer()
                        
                        Text("$5 / week")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(selectedOption == "Weekly" ? .white : .gray)
                    }
                    .padding()
                    .background(
                        selectedOption == "Weekly" ? Color(.red).opacity(0.45) : Color.clear
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "#484848"), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 20)
                
                Button(action: {}) {
                    Text("Start 3-Day Free Trial")
                        .padding()
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                }
                .background(.yellow)
                .cornerRadius(15)
                
                VStack {
                    Group {
                        Text("By subscribing to Ex, you agree to our")
                            .foregroundColor(Color(hex: "#484848")) +
                        Text(" Privacy Policy ")
                            .foregroundColor(Color(hex: "#8F8F8F")) +
                        Text("and ")
                            .foregroundColor(Color(hex: "#484848")) +
                        Text("Terms of Use")
                            .foregroundColor(Color(hex: "#8F8F8F"))
                    }
                }
                .multilineTextAlignment(.center)
                .frame(width: 250)
                .font(.custom("Inter", size: 14))
                .padding(.top, 3)
                
                
            }
            .padding(.top, 40)
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    ExPremiumView()
}
