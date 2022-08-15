//
//  NotificationManager.swift
//  TimerExtra
//
//  Created by carl on 02/08/2022.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var settings: UNNotificationSettings?
    
    let categoryIdentifier = "timer"
    let stopActionIdentifier = "stop"

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            self.fetchNotificationSettings()
            completion(granted)
        }
    }

    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }

    func scheduleNotification(timeInterval: TimeInterval, uuid: UUID) {
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.body = "\(timeInterval.string(style: .short))"
        
        content.categoryIdentifier = categoryIdentifier
        content.userInfo = ["uuidString": "\(uuid.uuidString)"]
        if #available(iOS 15.2, *) {
            content.sound = .defaultRingtone
        } else {
            // Fallback on earlier versions
            content.sound = .default
        }
        content.interruptionLevel = .critical

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: trigger)

        // Add Action button to notification
        let actionButton = UNNotificationAction(identifier: stopActionIdentifier, title: "Stop and cancel", options: .foreground)
        let notificationCategory = UNNotificationCategory(identifier: categoryIdentifier, actions: [actionButton], intentIdentifiers: [])
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.setNotificationCategories([notificationCategory])
        notificationCenter.add(request) { error in
            if error != nil {
                // Handle any errors.
                print("notificationCenter add request error \(error.debugDescription)")
            }
        }
    }

    func removeScheduledNotification(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
