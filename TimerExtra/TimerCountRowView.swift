//
//  TimerCountRowView.swift
//  TimerExtra
//
//  Created by carl on 03/08/2022.
//

import AVFoundation
import SwiftUI

struct TimerCountRowView: View {
    var timerCount: TimerCount
    @State var countDown: TimeInterval
    var deleteAction: () -> ()

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @State private var workItemPlay = DispatchWorkItem {}
    @State private var timerSoundOn = false
    @State private var showRemoveButton = false

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
                        if timerCount.countDownInSeconds() > 0 {
                            // add 0.5 for delaying count down (don't count down immediately)
                            self.countDown = timerCount.countDownInSeconds() + 0.5
                        } else {
                            guard timerSoundOn == false else {
                                return
                            }
                            timerSoundOn = true
                            playSound()
                            timer.upstream.connect().cancel()
                            countDown = 0
                        }
                    }

                Spacer()

                if timerSoundOn == false {
                    Text("\(timerCount.end.timeString())")
                } else {
                    Button("Cancel") {
                        stopSound()
                        timerSoundOn = false
                        self.deleteAction()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.accentColor)
                }
            }
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .simultaneousGesture(
                DragGesture()
                    .onEnded { _ in
                        if timerSoundOn == false {
                            withAnimation {
                                showRemoveButton.toggle()
                            }
                        }
                    }
            )

            if showRemoveButton {
                Button {
                    stopSound()
                    self.deleteAction()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .renderingMode(.original)
                        .padding(10)
                }
            }
        }
    }

    func playSound() {
        workItemPlay = DispatchWorkItem {
            AudioServicesPlaySystemSound(SystemSoundID(1328))
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1, execute: workItemPlay)
        for i in 1 ... 10 {
            DispatchQueue.global().asyncAfter(deadline: .now() + (Double(i) * 3.0), execute: workItemPlay)
        }
    }

    func stopSound() {
        workItemPlay.cancel()
        workItemPlay = DispatchWorkItem {}
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
