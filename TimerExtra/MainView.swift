//
//  MainView.swift
//  TimerExtra
//
//  Created by carl on 02/08/2022.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = TimersViewModel.shared
    @State var startSeconds: Double = 0
    @State var showMaxTimerAlert = false
    
    var body: some View {
        VStack {
            if viewModel.timers.count == 0 {
                Spacer()
                    
                HStack {
                    Spacer()
                    Text("Tap buttons below to add time, then tap Start")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(40)
                    Spacer()
                }
                .frame(height: 260)
                    
                Spacer()
            }
            List {
                ForEach(viewModel.timers, id: \.id) { timerCount in
                    TimerCountRowView(timerCount: timerCount,
                                      countDown: timerCount.timeInterval,
                                      deleteAction: {
                                          viewModel.removeTimer(uuidString: timerCount.id.uuidString)
                                      })
                        .padding(.horizontal, 20)
                        .listRowBackground(Color.black)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.removeTimer(uuidString: timerCount.id.uuidString)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.top, 10)
            .listStyle(.plain)
            
            Spacer()
            
            if showMaxTimerAlert {
                Text("Maximum 3 timers at a time")
                    .foregroundColor(.red)
            }
            
            Group {
                HStack {
                    AddStartTimeButton(label: "Reset") {
                        startSeconds = 0
                    }
                    .opacity(startSeconds > 0 ? 1 : 0.3)
                    
                    AddStartTimeButton(label: "+ 1 sec") {
                        startSeconds += 1
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

                Button {
                    guard startSeconds > 0 else {
                        return
                    }
                    if viewModel.timers.count == 3 {
                        showMaxTimerAlert = true
                        return
                    }
                    if startSeconds > 24 * 60 * 60 {
                        startSeconds = 24 * 60 * 60
                    }
                    showMaxTimerAlert = false
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
                .opacity(startSeconds > 0 && viewModel.timers.count < 3 ? 1.0 : 0.3)
                .padding(.vertical, 15)
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
