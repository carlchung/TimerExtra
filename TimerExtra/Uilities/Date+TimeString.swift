//
//  Date+TimeString.swift
//  TimerExtra
//
//  Created by carl on 03/08/2022.
//

import Foundation

extension Date {
    func timeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: self)
    }
}
