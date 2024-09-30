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
    @State var selectedDate: Date = Date()
    @FocusState private var isKeyboardFocused: Bool
    @State private var showDatePicker = false
    @State private var navigateToAboutExView = false
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    let formatter = DateFormatterManager.shared.datePickerFormatter()
    
    private var isFormValid : Bool {
        !name.isEmpty && !birthday.isEmpty
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#2F0103"), .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 30) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(ExAppStrings.Onboarding.yourName)
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
                            .focused($isKeyboardFocused)
                            .onChange(of: name) { newValue in
                                UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.name)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                    isKeyboardFocused = true
                                }
                            }
                    }
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(ExAppStrings.Onboarding.birthday)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                    
                    ZStack(alignment: .leading) {
                        if birthday.isEmpty {
                            Text(ExAppStrings.Onboarding.selectBirthday)
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.leading, 16)
                        }
                        
                        TextField("", text: $birthday)
                            .onTapGesture {
                                showDatePicker.toggle()
                            }
                            .padding()
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        
                    }
                    .padding(.horizontal)
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
                        showAlert(message: ExAppStrings.Onboarding.fillCorrectly)
                    }
                }) {
                    Text(ExAppStrings.Onboarding.continueButton)
                        .font(.system(size: 19))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color(hex: "#2A6A07") : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: AboutExView(), isActive: $navigateToAboutExView) {
                    EmptyView()
                }
                
                if showDatePicker {
                    VStack{
                        HStack {
                            Button("Cancel") {
                                showDatePicker = false
                            }
                            
                            Spacer()
                            
                            Button("Done") {
                                birthday = formatter.string(from: selectedDate)
                                UserDefaults.standard.set(birthday, forKey: UserDefaultsKeys.birthday)
                                showDatePicker = false
                            }
                            .fontWeight(.semibold)
                        }
                        .font(.system(size: 21))
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color(hex: "#101414"))
                        
                        DatePicker(selection: $selectedDate,
                                   in: ...Date(),
                                   displayedComponents: .date){
                            
                        }
                        .datePickerStyle(.wheel)
                        .preferredColorScheme(.dark)
                        .onAppear{
                            UIApplication.shared.endEditing()
                        }
                        .onChange(of: selectedDate) { newDate in
                            birthday = formatter.string(from: newDate)
                            UserDefaults.standard.set(birthday, forKey: UserDefaultsKeys.birthday)
                                   }
                        .fixedSize()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#101414"))
                    
                }
            }
            .padding(.top, 70)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(ExAppStrings.Onboarding.aboutYou)
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
    
}

#Preview {
    AboutYouView()
}
