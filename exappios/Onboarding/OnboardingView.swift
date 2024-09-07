//
//  OnboardingView.swift
//  exappios
//
//  Created by Tami on 25.08.2024.
//
import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @State private var scale: CGFloat = 1.0
    @State private var isNotificationEnabled = false
    @State private var isActive = false
    @State private var timer: Timer?

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("screenBG")
                    .resizable()
                    .scaledToFill()
                
                VStack(alignment: .center) {
                    Image("brokenHeart")
                        .resizable()
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.red)
                        .scaleEffect(scale)
                        .onAppear {
                            scale = 1.2
                            requestNotificationPermission()
                            startPermissionCheck()
                            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                                checkForPermission()
                            }
                        }
                        .onDisappear {
                            stopPermissionCheck()
                            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
                        }
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: scale)
                        .padding(.bottom, 25)
        
                    
                    Text("Turn on notifications")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: "#FFB4B4"))
                        .padding(.bottom, 10)
                    
                    Text("If you don't turn on notifications,\n your ex won't be able to text you")
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "#FFB4B4").opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                    
                    
                    Image("pushs")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                    
                    Toggle("", isOn: $isNotificationEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: Color.green))
                        .labelsHidden()
                        .scaleEffect(2.2)
                        .padding(.top, 60)
                        .disabled(true)
                        
                    Spacer()
                    
                    Button(action: {
                        if isNotificationEnabled {
                            isActive = true
                        } else {
                            showAlertToOpenSettings()
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 19))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isNotificationEnabled ? Color(hex: "#2A6A07") : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 45)
                    
                    NavigationLink(destination: AboutYouView(), isActive: $isActive) {
                        EmptyView()
                    }
                }
                .padding(.top, 100)
            }
            .ignoresSafeArea()        }
    }
    
    private func startPermissionCheck() {
        checkForPermission()
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            checkForPermission()
        }
    }
    
    private func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                isNotificationEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    isNotificationEnabled = true
                    print("Notification permissions granted")
                } else {
                    isNotificationEnabled = false
                    print("Notification permissions denied")
                }
            }
        }
    }

    
    private func stopPermissionCheck() {
        timer?.invalidate()
        timer = nil
    }
    
    private func showAlertToOpenSettings() {
        let openAction = UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: "Turn on notifications", message: "To receive notifications, please enable them in your settings", preferredStyle: .alert)
        alert.addAction(openAction)
        alert.addAction(cancelAction)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
}

    
    #Preview {
        OnboardingView()
    }
