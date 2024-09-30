import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct exappiosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            @AppStorage("onboarding") var onboarding = true
            let userDefaultsManager = UserDefaultsManager.shared

            OnboardingView()
//            if onboarding {
//                OnboardingView()
//            } else {
//                NavigationStack {
//                    ChatView(style: ChatStyle(rawValue: userDefaultsManager.savedStyle) ?? .telegram, header: ChatHeader(title: userDefaultsManager.savedExName , subtitle: "был(а) недавно", avatarImage: Image(userDefaultsManager.savedAvatar) ))
//                }
//            }
            
        }
    }
}
