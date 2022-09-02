//
//  TimersViewModel.swift
//  TimerExtra
//
//  Created by carl on 02/08/2022.
//

import Foundation
import UserNotifications

class TimersViewModel: ObservableObject {
    static let shared = TimersViewModel()
    let notificationManager = NotificationManager()
    
    @Published var timers = [TimerCount]()

    func newTimer(seconds: TimeInterval) {
        let uuid = UUID()
        notificationManager.scheduleNotification(timeInterval: seconds, uuid: uuid)

        let newTimer = TimerCount(id: uuid, start: Date.now, timeInterval: seconds)
        timers.insert(newTimer, at: 0)
    }
    
    func removeTimer(uuidString: String) {
        notificationManager.removeScheduledNotification(identifiers: [uuidString])
        timers = timers.filter { $0.id.uuidString != uuidString }
    }
}
