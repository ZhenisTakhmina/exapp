import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        //NotificationManager.shared.requestAuthorization()
        return true
    }
}

@main
struct exappiosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            var savedExName: String {
                UserDefaults.standard.string(forKey: UserDefaultsKeys.exName) ?? "Ex"
            }
            
            var savedAvatar: String {
                UserDefaults.standard.string(forKey: UserDefaultsKeys.avatar) ?? "avatar"
            }
            
            let showOnboardingView: Bool = UserDefaults.standard.bool(forKey: "onboardingCompleted")
    
            if !showOnboardingView {
                OnboardingView()
            } else {
                NavigationStack {
                    ChatView(style: .telegram, header: ChatHeader(title: savedExName , subtitle: "был(а) недавно", avatarImage: Image(savedAvatar) ))
                }
            }
                
        }
    }
}
