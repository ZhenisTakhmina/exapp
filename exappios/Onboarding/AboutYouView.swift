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
    
    private var isFormValid : Bool {
        !name.isEmpty && !birthday.isEmpty
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "501203"), .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Your name")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                    
                    ZStack(alignment: .leading) {
                        if name.isEmpty {
                            Text("Michael")
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.leading, 8)
                        }
                        
                        TextField("", text: $name)
                            .padding()
                            .background(Color.clear)
                            .foregroundStyle(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .onChange(of: name) { newValue in
                        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.name)
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Birthday")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                    
                    
                    ZStack(alignment: .leading) {
                        if birthday.isEmpty {
                            Text("MM/DD")
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.leading, 8)
                        }
                        
                        TextField("", text: $birthday)
                            .padding()
                            .foregroundStyle(.white)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .onChange(of: birthday) { newValue in
                        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.birthday)
                    }
                }
                
                Spacer()
                
                
                NavigationLink(destination: AboutExView()) {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color(hex: "#2A6A07") : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 70)
                .disabled(!isFormValid)
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
}

#Preview {
    AboutYouView()
}
