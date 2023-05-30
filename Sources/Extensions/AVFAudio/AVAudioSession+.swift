//
//  AVAudioSession+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import AVFAudio
import UIKit

public extension AVAudioSession {
    /// 支持蓝牙耳机
    static func setAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .mixWithOthers])
            try session.setActive(true)
        } catch {}
    }
}
