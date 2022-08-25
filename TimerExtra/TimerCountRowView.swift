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
    var canMaximise: Bool
    var deleteAction: () -> ()

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let alarmSoundPlayer = AlarmSoundPlayer()
    @State private var timerSoundOn = false
    @State private var maxSize = false

    private var circleSize: CGFloat {
        (mainWindowSize.height - 350) / 2.0
    }

    private var paddingRectWidth: CGFloat {
        return (mainWindowSize.width - 60 - circleSize) / 2.0
    }

    var body: some View {
        ZStack {
            HStack {
                if maxSize {
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: paddingRectWidth)
                }

                ZStack {
                    ProgressArc(maxSize: $maxSize, progress: 1.0, strokColor: .gray, circleSize: circleSize)
                        .opacity(0.6)
                    ProgressArc(maxSize: $maxSize, progress: timerCount.countDownInSeconds() / timerCount.timeInterval, strokColor: .orange, circleSize: circleSize)
                }
                .onTapGesture {
                    if canMaximise {
                        withAnimation {
                            maxSize.toggle()
                        }
                    }
                }

                Spacer()
            }

            HStack {
                VStack(spacing: 5) {
                    Spacer()
                    Text("\(countDown.string(style: .positional))")
                        .font(.title)
                        .onReceive(timer) { _ in
                            self.updateCountdown()
                        }
                    
                    if maxSize {
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
                    Spacer()
                }
                .frame(height: maxSize ? circleSize : 35)

                if maxSize == false {
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
            }
            .padding(.leading, maxSize ? 0 : 50)
            .onTapGesture {
                if canMaximise {
                    withAnimation {
                        maxSize.toggle()
                    }
                }
            }
        }
        .foregroundColor(.white)
        .padding(5)
        .onAppear {
            maxSize = canMaximise
        }
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
    @Binding var maxSize: Bool
    var progress: CGFloat = 0.0
    var strokColor = Color.accentColor
    var circleSize: CGFloat

    var body: some View {
        GeometryReader { _ in
            Circle()
                .trim(from: 0.0, to: progress)
                .rotation(.degrees(-90))
                .stroke(strokColor, style: StrokeStyle(lineWidth: maxSize ? 6 : 3, lineCap: .butt))
                .frame(width: maxSize ? circleSize : 35, height: maxSize ? circleSize : 35)
        }
    }
}
