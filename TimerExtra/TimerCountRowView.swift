//
//  TimerCountRowView.swift
//  TimerExtra
//
//  Created by carl on 03/08/2022.
//

import SwiftUI

struct TimerCountRowView: View {
    @Environment(\.mainWindowSize) var mainWindowSize

    var timerCount: TimerCount
    @State var countDown: TimeInterval
    var deleteAction: () -> ()

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let alarmSoundPlayer = AlarmSoundPlayer()
    @State private var timerSoundOn = false

    var body: some View {
        HStack {
            ZStack {
                ProgressArc(progress: 1.0, strokColor: .gray)
                    .opacity(0.6)
                ProgressArc(progress: timerCount.countDownInSeconds() / timerCount.timeInterval, strokColor: .orange)
            }
            .frame(width: 35, height: 35)

            Text("\(countDown.string(style: .positional))")
                .font(.title)
                .frame(height: 35)
                .padding(.leading, 10)
                .onReceive(timer) { _ in
                    self.updateCountdown()
                }

            Spacer()

            if timerSoundOn == false {
                Text("\(timerCount.end.timeString())")
            } else {
                Button("Cancel") {
                    alarmSoundPlayer.stopSound()
                    self.deleteAction()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.accentColor)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .onDisappear {
            timer.upstream.connect().cancel()
            alarmSoundPlayer.stopSound()
        }
    }

    func updateCountdown() {
        print("countDown \(timerCount.countDownInSeconds())")
        if timerCount.countDownInSeconds() > 0 {
            // add 0.5 for delaying count down (don't count down immediately)
            countDown = timerCount.countDownInSeconds() + 0.5
        } else if timerCount.countDownInSeconds() > -1 {
            guard timerSoundOn == false else {
                return
            }
            timerSoundOn = true
            alarmSoundPlayer.playSound()
            timer.upstream.connect().cancel()
            countDown = 0
        }
    }
}

struct ProgressArc: View {
    var progress: CGFloat = 0.0
    var strokColor = Color.accentColor

    var body: some View {
        GeometryReader { _ in
            Circle()
                .trim(from: 0.0, to: progress)
                .rotation(.degrees(-90))
                .stroke(strokColor, style: StrokeStyle(lineWidth: 3, lineCap: .butt))
                .frame(width: 35, height: 35)
        }
    }
}
