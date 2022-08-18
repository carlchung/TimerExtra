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
    var deleteAction: () -> ()

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let alarmSoundPlayer: AlarmSoundPlayer = AlarmSoundPlayer()
    @State private var timerSoundOn = false

    var body: some View {
        HStack {
            HStack {
                ZStack {
                    ProgressArc(progress: 1.0, strokColor: .gray)
                        .opacity(0.6)
                    ProgressArc(progress: timerCount.countDownInSeconds() / timerCount.timeInterval, strokColor: .orange)
                }
                .padding(.trailing, 10)

                Text("\(countDown.string(style: .positional))")
                    .font(.title)
                    .onReceive(timer) { _ in
                        print("countDown \(timerCount.countDownInSeconds())")
                        if timerCount.countDownInSeconds() > 0 {
                            // add 0.5 for delaying count down (don't count down immediately)
                            self.countDown = timerCount.countDownInSeconds() + 0.5
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
            .padding(.vertical, 10)
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

struct ProgressArc: View {
    var progress: CGFloat = 0.0
    var strokColor = Color.orange
    var body: some View {
        Circle()
            .trim(from: 0.0, to: progress)
            .rotation(.degrees(-90))
            .stroke(strokColor, style: StrokeStyle(lineWidth: 3, lineCap: .butt))
            .frame(width: 20, height: 20)
    }
}
