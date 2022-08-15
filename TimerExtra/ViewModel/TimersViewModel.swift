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
    
    @Published var timers = [TimerCount]()

    func newTimer(seconds: TimeInterval) {
        let uuid = UUID()
        NotificationManager.shared.scheduleNotification(timeInterval: seconds, uuid: uuid)

        let newTimer = TimerCount(id: uuid, start: Date.now, timeInterval: seconds)
        timers.insert(newTimer, at: 0)
    }

    func removeTimer(_ timer: TimerCount) {
        let identifiers: [String] = [timer.id.uuidString]
        NotificationManager.shared.removeScheduledNotification(identifiers: identifiers)
        timers = timers.filter { $0.start != timer.start }
    }
    
    func removeTimer(uuidString: String) {
        NotificationManager.shared.removeScheduledNotification(identifiers: [uuidString])
        timers = timers.filter { $0.id.uuidString != uuidString }
    }
}
