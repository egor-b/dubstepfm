//
//  AudioStream.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 10/3/22.
//

import AVFoundation
import MediaPlayer
import AVKit

class AudioStream: NSObject, ObservableObject, AVPlayerItemMetadataOutputPushDelegate {
    
    @Published private(set) var isPlaying = false
    @Published private(set) var title = "Dubstep.FM Live"
    
    private var audioPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    func playSound(sound: String) {
        if let url = URL(string: sound) {
            self.playerItem = AVPlayerItem(url: url)
            self.audioPlayer = AVPlayer(playerItem: self.playerItem)
        }
        backgroundMode()
    }
    
    func play() {
        isPlaying = true
        audioPlayer?.play()
    }
    
    func pause() {
        isPlaying = false
        audioPlayer?.pause()
    }
    
    func backgroundMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    //    func playSong(url: String) -> Void {
    //        let streamURL: URL = URL(string: url)!
    //        DispatchQueue.global().async(qos: .userInteractive) {
    //            do {
    //                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    //                try AVAudioSession.sharedInstance().setActive(true)
    //                self.playerItem = AVPlayerItem(url: streamURL)
    //                self.audioPlayer = AVPlayer(playerItem: self.playerItem)
    //                self.audioPlayer.play()
    //                DispatchQueue.main.async {
    //                    self.setUpdater()
    //                }
    //                self.comandCenter()
    //            } catch {
    //
    //            }
    //            self.playerItem.addObserver(self as! NSObject, forKeyPath: "timedMetadata", options: .new, context: nil)
    //        }
    //    }
    //
    ////    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    ////        if keyPath != "timedMetadata" { return }
    ////        let data: AVPlayerItem = object as! AVPlayerItem
    ////        mixName.text = (data.timedMetadata!.first!.value as? String ?? "DUBSTEP FM")
    ////        if data.timedMetadata?.first?.value == nil {
    ////            mixName = "DUBSTEP.FM RADIO STATION"
    ////        } else {
    ////            mixName = (data.timedMetadata!.first!.value! as! String)
    ////        }
    ////        setupNowPlaying(playerItem: data)
    ////    }
    //
    //    func comandCenter() {
    //        let commandCenter = MPRemoteCommandCenter.shared()
    //        commandCenter.playCommand.isEnabled = true
    //        commandCenter.playCommand.addTarget { event in
    //            self.audioPlayer.play()
    //            return .success
    //        }
    //        commandCenter.pauseCommand.isEnabled = true
    //        commandCenter.pauseCommand.addTarget { event in
    //            self.audioPlayer.pause()
    //            return .success
    //        }
    //
    //    }
    //
    //    func setupNowPlaying(playerItem: AVPlayerItem) {
    //        var nowPlayingInfo = [String : Any]()
    //        nowPlayingInfo[MPMediaItemPropertyTitle] = playerItem.timedMetadata!.first!.value! as? String ?? "DUBSTEP FM"
    //        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    //        MPNowPlayingInfoCenter.default().playbackState = .playing
    //    }
    //
    //    func setUpdater() {
    //        updater = CADisplayLink(target: self, selector: #selector(updatingProgressItems))
    //        updater.preferredFramesPerSecond = 2
    //        updater.add(to: .current, forMode: .default)
    //    }
    //
    //    @objc func updatingProgressItems() {
    //        let curTime = Float(CMTimeGetSeconds(audioPlayer.currentTime()))
    //        var currentTimeDuration = 0
    ////        if CMTimeGetSeconds(playerItem.asset.duration).isNaN {
    ////            self.progress.isEnabled = false
    ////            self.progress.maximumValue = Float(curTime*2)
    ////        } else {
    ////            self.progress.isEnabled = true
    ////            song = Song(withAVPlayerItem: playerItem)
    ////            self.artwork.image = song.artwork
    ////            currentTimeDuration = Int(song.duration) - Int(curTime)
    ////            self.progress.maximumValue = Float(song.duration)
    ////        }
    ////        self.progress.setValue(curTime, animated: true)
    //        // making normal time format of song
    //        let currentTimePlaying = Int(curTime)
    //        let minutesPlaying = currentTimePlaying / 60
    //        let secondsPlaying = currentTimePlaying - minutesPlaying * 60
    ////        startTime.text = NSString(format: "%02d:%02d", minutesPlaying, secondsPlaying) as String
    //
    //        let minutesDuration = currentTimeDuration / 60
    //        let secondsDuration = currentTimeDuration - minutesDuration * 60
    ////        endTime.text = NSString(format: "%02d:%02d", minutesDuration, secondsDuration) as String
    //    }
    //
}
