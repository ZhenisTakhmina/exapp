//
//  AboutYouView.swift
//  exappios
//
//  Created by Tami on 25.08.2024.
//

import SwiftUI

struct AboutYouView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = UserDefaults.standard.string(forKey: UserDefaultsKeys.name) ?? ""
    @State private var birthday  = UserDefaults.standard.string(forKey: UserDefaultsKeys.birthday) ?? ""
    
    @State private var navigateToAboutExView = false
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    private var isFormValid : Bool {
        !name.isEmpty && !birthday.isEmpty && Int(birthday.prefix(2)) ?? 0 <= 12 && Int(birthday.suffix(2)) ?? 0 <= 31
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#2F0103"), .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 30) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your name")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                    
                    ZStack(alignment: .leading) {
                        if name.isEmpty {
                            Text("Michael")
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.leading, 16)
                        }
                        
                        TextField("", text: $name)
                            .padding()
                            .font(.system(size: 18))
                            .background(Color.clear)
                            .foregroundStyle(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .onChange(of: name) { newValue in
                        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.name)
                    }
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Birthday")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                    
                    
                    ZStack(alignment: .leading) {
                        if birthday.isEmpty {
                            Text("MM/DD")
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.leading, 16)
                        }
                        
                        TextField("", text: $birthday)
                            .padding()
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .keyboardType(.numberPad)
                        
                    }
                    .padding(.horizontal)
                    .onChange(of: birthday) { newValue in
                        birthday = formatToMMDD(newValue)
                        UserDefaults.standard.set(birthday, forKey: UserDefaultsKeys.birthday)
                    }
                    
                }
                
                if showAlert {
                    Text(alertMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red.opacity(0.4))
                        .cornerRadius(10)
                        .animation(.easeInOut, value: showAlert)
                }

                
                Spacer()
                
                Button(action: {
                    if isFormValid {
                        navigateToAboutExView = true
                    } else {
                        showAlert(message: "Please ensure all fields are filled correctly.")
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 19))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color(hex: "#2A6A07") : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                NavigationLink(destination: AboutExView(), isActive: $navigateToAboutExView) {
                    EmptyView()
                }
            }
            .padding(.top, 70)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About You")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss()}) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        withAnimation {
            showAlert = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showAlert = false
            }
        }
    }
    
    private func formatToMMDD(_ input: String) -> String {
        let digitsOnly = input.filter { $0.isNumber }
        
        let formatted = Array(digitsOnly).prefix(4).enumerated().map { index, character in
            if index == 2 {
                return "/" + String(character)
            }
            return String(character)
        }.joined()
        
        return formatted
    }
}

#Preview {
    AboutYouView()
}
