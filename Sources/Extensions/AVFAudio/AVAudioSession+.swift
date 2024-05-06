//
//  AVAudioSession+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import AVFAudio
import UIKit

public extension AVAudioSession {
    /// 开启蓝牙耳机支持
    static func pd_setAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .mixWithOthers])
            try session.setActive(true)
        } catch {}
    }
}
