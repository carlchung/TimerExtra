//
//  TimerExtraApp.swift
//  TimerExtra
//
//  Created by carl on 01/08/2022.
//

import SwiftUI

@main
struct TimerExtraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                MainView()
                    .background(Color.black)
                    .environment(\.mainWindowSize, proxy.size)
            }
        }
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        configureUserNotifications()
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    private func configureUserNotifications() {
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        if let uuidString = userInfo["uuidString"] as? String {
            print("data uuidString  received: \(uuidString)")
            switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    // the user swiped to unlock
                    print("Default Action Identifier")
                    TimersViewModel.shared.removeTimer(uuidString: uuidString)

                case NotificationManager().stopActionIdentifier:
                    // the user tapped our "Stop and cancel" button
                    print("Stop and cancel timer")
                    TimersViewModel.shared.removeTimer(uuidString: uuidString)

                default:
                    break
            }
        }

        completionHandler()
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
//    {
//        completionHandler([.banner, .sound])
//    }
}
