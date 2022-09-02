//
//  NotificationManager.swift
//  TimerExtra
//
//  Created by carl on 02/08/2022.
//
// alarm sound file from https://mixkit.co/free-sound-effects/

import Foundation
import UserNotifications

struct NotificationManager {
    
    let categoryIdentifier = "timer"
    let stopActionIdentifier = "stop"

    func requestAuthorization() async -> Bool  {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("UNUserNotificationCenter requestAuthorization error")
            return false
        }
    }

    func fetchNotificationSettings() async -> UNNotificationSettings {
        return await UNUserNotificationCenter.current().notificationSettings()
    }

    func scheduleNotification(timeInterval: TimeInterval, uuid: UUID) {
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.body = "\(timeInterval.string(style: .short))"
        
        content.categoryIdentifier = categoryIdentifier
        content.userInfo = ["uuidString": "\(uuid.uuidString)"]
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "digital-alarm.wav"))
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
