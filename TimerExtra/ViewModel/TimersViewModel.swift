//
//  TimersViewModel.swift
//  TimerExtra
//
//  Created by carl on 02/08/2022.
//

import Foundation
import UserNotifications

class TimersViewModel: ObservableObject {
    @Published var timers = [TimerCount]()
    
    func newTimer(seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.body = "\(seconds.string(style: .short))"
        content.sound = .defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        let uuid = UUID()
        let request = UNNotificationRequest(identifier: uuid.uuidString, content: content, trigger: trigger)

//        print("newTimer seconds \(seconds)")
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
               print("notificationCenter add request error \(error.debugDescription)")
           }
        }
        let newTimer = TimerCount(id: uuid, start: Date.now, timeInterval: seconds)
        timers.insert(newTimer, at: 0)
    }
}
