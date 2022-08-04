//
//  TimeInterval+String.swift
//  TimerExtra
//
//  Created by carl on 02/08/2022.
//

import Foundation

extension TimeInterval {
    func string(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        if self >= 3600 {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }
        formatter.unitsStyle = style
        if style == .positional {
            formatter.zeroFormattingBehavior = .pad
        }
        return formatter.string(from: self) ?? ""
    }
}
