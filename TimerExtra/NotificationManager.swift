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

    //  func removeScheduledNotification(task: Task) {
//    UNUserNotificationCenter.current()
//      .removePendingNotificationRequests(withIdentifiers: [task.id])
    //  }
}
