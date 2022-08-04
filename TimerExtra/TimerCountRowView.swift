//
//  TimerCountRowView.swift
//  TimerExtra
//
//  Created by carl on 03/08/2022.
//

import SwiftUI

struct TimerCountRowView: View {
    var timerCount: TimerCount
    @State var countDown: TimeInterval

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            Group {
                Text("\(countDown.string(style: .positional))")
                    .font(.title)
                    .onReceive(timer) { _ in
                        if timerCount.countDownInSeconds() > 0 {
                            // add 0.5 for delaying count down (don't count down immediately)
                            self.countDown = timerCount.countDownInSeconds() + 0.5
                        } else {
                            self.countDown = 0
                            self.timer.upstream.connect().cancel()
                        }
                    }
                Spacer()
                Text("\(timerCount.end.timeString())")
            }
            .foregroundColor(.white)
            .padding(.vertical, 10)
        }
        .onAppear {
            countDown = timerCount.timeInterval
        }
    }
}
