//
//  AlarmSoundManager.swift
//  TimerExtra
//
//  Created by carl on 12/08/2022.
//

import AVFoundation
import Foundation

class AlarmSoundPlayer {
    private var audioPlayer: AVAudioPlayer?

    func playSound() {
        AudioServicesPlaySystemSound(SystemSoundID(1011))

        let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/alarm.caf")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
            print("AVAudioPlayer error \(error.localizedDescription)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
    }
}
