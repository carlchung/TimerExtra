//
//  MainView.swift
//  TimerExtra
//
//  Created by carl on 02/08/2022.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = TimersViewModel()
    @State var startSeconds: Double = 0
    
    var body: some View {
        VStack {
            ScrollView {
                if viewModel.timers.count == 0 {
                    HStack {
                        Spacer()
                        Text("Tap buttons below to add time, then tap Start")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(40)
                        Spacer()
                    }
                    .frame(height: 200)
                    
                    Spacer()
                }
                ForEach(viewModel.timers, id: \.id) { timerCount in
                    TimerCountRowView(timerCount: timerCount,
                                      countDown: timerCount.timeInterval,
                                      deleteAction: {
                                          viewModel.removeTimer(timerCount)
                                      })
                        .padding(.horizontal, 20)
                }
                
                if viewModel.timers.count >= 3 {
                    Button {
                        viewModel.timers = viewModel.timers.filter { $0.countDownInSeconds() + 0.5 > 0 }
                    } label: {
                        Spacer()
                        Text("Remove finished timer")
                            .foregroundColor(.red)
                            .padding(2)
                        Spacer()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.secondary)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                }
            }
            .padding(.top, 10)
            
            Spacer()
            
            Group {
                HStack {
                    if startSeconds < 10 {
                        AddStartTimeButton(label: "+ 1 second") {
                            startSeconds += 1
                        }
                    } else {
                        AddStartTimeButton(label: "Reset") {
                            startSeconds = 0
                        }
                    }
                
                    AddStartTimeButton(label: "+ 5s") {
                        startSeconds += 5
                    }
                }
                .padding(.top, 10)
            
                HStack {
                    AddStartTimeButton(label: "+ 10s") {
                        startSeconds += 10
                    }
                
                    AddStartTimeButton(label: "+ 30s") {
                        startSeconds += 30
                    }
                }
                HStack {
                    AddStartTimeButton(label: "+ 1 minute", doubleHeight: true) {
                        startSeconds += 60
                    }
            
                    AddStartTimeButton(label: "+ 5 mins", doubleHeight: true) {
                        startSeconds += 5 * 60
                    }
                }
            
                HStack {
                    AddStartTimeButton(label: "+ 10 mins", doubleHeight: true) {
                        startSeconds += 10 * 60
                    }
            
                    AddStartTimeButton(label: "+ 30 mins", doubleHeight: true) {
                        startSeconds += 30 * 60
                    }
                }
                .padding(.bottom, 15)

                Button {
                    guard startSeconds > 0 else {
                        return
                    }
                    if startSeconds > 24 * 60 * 60 {
                        startSeconds = 24 * 60 * 60
                    }
                    NotificationManager.shared.fetchNotificationSettings()
                    let notifSettings = NotificationManager.shared.settings
                    if notifSettings?.authorizationStatus == .authorized {
                        startNewTimer()
                    } else {
                        NotificationManager.shared.requestAuthorization { granted in
                            print("requestAuthorization granted \(granted)")
                            DispatchQueue.main.async {
                                startNewTimer()
                            }
                        }
                    }
                
                } label: {
                    Spacer()
                    Text(startSeconds > 0 ? "\(TimeInterval(startSeconds).string(style: .positional))    Start" : "Start")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding(8)
                    Spacer()
                }
                .buttonStyle(.borderedProminent)
                .tint(.secondary)
                .opacity(startSeconds > 0 ? 1.0 : 0.3)
            }
            .padding(.horizontal, 20)
        }
    }
    
    func startNewTimer() {
        viewModel.newTimer(seconds: TimeInterval(startSeconds))
        startSeconds = 0
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .background(Color.black)
    }
}
