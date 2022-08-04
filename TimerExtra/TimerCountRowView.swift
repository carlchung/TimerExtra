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

    @State var showRemoveButton = false

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

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
                            self.countDown = 0
                            self.timer.upstream.connect().cancel()
                        }
                    }
                Spacer()
                Text("\(timerCount.end.timeString())")
            }
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .simultaneousGesture(
                DragGesture()
                    .onEnded { _ in
                        withAnimation {
                            showRemoveButton.toggle()
                        }
                    }
            )

            if showRemoveButton {
                Button(action: self.deleteAction,
                       label: {
                           Image(systemName: "xmark.circle.fill")
                               .renderingMode(.original)
                               .padding(10)
                       })
            }
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
