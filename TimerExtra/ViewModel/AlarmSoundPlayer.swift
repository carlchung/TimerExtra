//
//  AlarmSoundManager.swift
//  TimerExtra
//
//  Created by carl on 12/08/2022.
//

import Foundation
import AVFoundation

class AlarmSoundPlayer {
    
//    private var workItem = DispatchWorkItem {}
//    private var workItemSystemSound = DispatchWorkItem {}
    
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
        
//        workItemAudioPlayer = DispatchWorkItem {
//            self.soundEffect?.play()
//        }
//        workItemSystemSound = DispatchWorkItem {
//            AudioServicesPlaySystemSound(SystemSoundID(1304))
//        }
//        DispatchQueue.global().async(execute: workItemAudioPlayer)
//        for i in 1 ... 10 {
//            DispatchQueue.global().asyncAfter(deadline: .now() + (Double(i) * 4), execute: workItemAudioPlayer)
//        }
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0, execute: workItemSystemSound)
//        for i in 1 ... 10 {
//            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0 + (Double(i) * 4), execute: workItemSystemSound)
//        }
    }

    func stopSound() {
        audioPlayer?.stop()
//        workItem.cancel()
//        workItem = DispatchWorkItem {}
    }
}
