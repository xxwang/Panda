
import AVFoundation
import AVKit
import UIKit

public class AudioUtils {
    public static let shared = AudioUtils()
    private init() {}
}

public extension AudioUtils {

    @discardableResult
    func playAudio(with audioName: String?, loops: Int = 0) -> AVAudioPlayer? {
        guard let audioURL = Bundle.main.url(forResource: audioName, withExtension: nil) else {
            return nil
        }
        return playAudio(with: audioURL, loops: loops)
    }

    @discardableResult
    func playAudio(with audioUrl: URL?, loops: Int = 0) -> AVAudioPlayer? {
        guard let audioUrl else { return nil }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
            try session.setCategory(.playback)

            let player = try AVAudioPlayer(contentsOf: audioUrl)
            player.prepareToPlay()
            player.numberOfLoops = loops
            player.play()

            return player
        } catch {
            Logger.debug(error.localizedDescription)
            return nil
        }
    }
}

public extension AudioUtils {

    func playSound(with soundName: String?,
                   isShake: Bool = false,
                   completion: (() -> Void)? = nil)
    {
        guard let soundName else { return }
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil) else { return }
        playSound(with: soundURL, isShake: isShake, completion: completion)
    }

    func playSound(with soundUrl: URL?,
                   isShake: Bool = false,
                   completion: (() -> Void)? = nil)
    {
        guard let soundUrl else { return }
        let soundCFURL = soundUrl as CFURL
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundCFURL, &soundID)
        playSound(with: soundID, isShake: isShake, completion: completion)
    }

    func playSound(with soundID: SystemSoundID,
                   isShake: Bool = false,
                   completion: (() -> Void)? = nil)
    {
        if isShake {
            AudioServicesPlayAlertSoundWithCompletion(soundID) {
                AudioServicesDisposeSystemSoundID(soundID)
                completion?()
            }
        } else {
            AudioServicesPlaySystemSoundWithCompletion(soundID) {
                completion?()
            }
        }
    }
}

public extension AudioUtils {
    enum ShakeLevel {
        case standard
        case normal
        case middle
        case three
        case always

        var soundID: SystemSoundID {
            switch self {
            case .standard:
                return kSystemSoundID_Vibrate
            case .normal:
                return SystemSoundID(1519)
            case .middle:
                return SystemSoundID(1520)
            case .three:
                return SystemSoundID(1521)
            case .always:
                return kSystemSoundID_Vibrate
            }
        }
    }

    func shake(_ level: ShakeLevel, completion: (() -> Void)? = nil) {
        if level == .always {
            AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, nil, nil, { _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }, nil)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        } else {
            AudioServicesPlaySystemSoundWithCompletion(level.soundID) {
                completion?()
            }
        }
    }

    func stopShake() {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
    }
}
