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
                    
                    
                    
                    Spacer()
                        .frame(height: 25)
                    
                    Text("Turn on notifications")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: "#FFB4B4"))
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Text("If you don't turn on notifications, your ex won't be able to text you")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#FFB4B4").opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    HStack(alignment: .top) {
                        Image("avatar")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Ex")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Those months together were beautiful and unbearable...")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .lineLimit(nil)
                        }
                        
                        Spacer()
                        
                        Text("3 min ago")
                            .font(.footnote)
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal, 10)
                    
                    Toggle("", isOn: $isNotificationEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: Color.green))
                        .labelsHidden()
                        .scaleEffect(1.6)
                        .padding(.init(top: 50, leading: 40, bottom: 40, trailing: 40))
                        .disabled(true)
                        
                    
                    Spacer()
                        .frame(height: 100)
                    
                    Button(action: {
                        if isNotificationEnabled {
                            isActive = true
                        } else {
                            showAlertToOpenSettings()
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isNotificationEnabled ? Color(hex: "#2A6A07") : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: AboutYouView(), isActive: $isActive) {
                        EmptyView()
                    }
                }
                .padding(.top, 100)
            }
            .edgesIgnoringSafeArea(.all)
        }
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
