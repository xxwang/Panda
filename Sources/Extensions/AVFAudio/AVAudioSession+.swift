import AVFAudio
import UIKit

public extension AVAudioSession {
    static func pd_setAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .mixWithOthers])
            try session.setActive(true)
        } catch {}
    }
}
