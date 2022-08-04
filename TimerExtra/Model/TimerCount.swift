//
//  TimerCount.swift
//  TimerExtra
//
//  Created by carl on 03/08/2022.
//

import Foundation

struct TimerCount: Identifiable {
    let id: UUID
    let start: Date
    let timeInterval: TimeInterval
    var end: Date {
        self.start.addingTimeInterval(self.timeInterval)
    }
    
    func countDownInSeconds() -> TimeInterval {
        let countUp = Date.now.timeIntervalSince(start)
        return timeInterval - countUp
    }
}
