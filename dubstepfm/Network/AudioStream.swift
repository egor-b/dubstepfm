//
//  AudioStream.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 10/3/22.
//

import AVFoundation
import MediaPlayer
import AVKit

class AudioStream: ObservableObject {
    
    @Published private(set) var isPlaying = false
    @Published private(set) var title = "Dubstep.FM"
    @Published private(set) var subTitle = "Live"
    @Published private(set) var time = "00:00:00"
    @Published private(set) var endTime = "00:00:00"
    @Published var currentTime = 0.0
    @Published private(set) var viewDuration = 0.0
    @Published private(set) var isLive = true
    
    private var audioPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    private var isTimerRunning = false
    private var timer = Timer()
    
    func playSound(sound: String) {
        if let url = URL(string: sound) {
            self.playerItem = AVPlayerItem(url: url)
            self.audioPlayer = AVPlayer(playerItem: self.playerItem)
            self.audioPlayer?.allowsExternalPlayback = true
            let duration = playerItem?.asset.duration ?? CMTime(seconds: 1, preferredTimescale: 1)
            viewDuration = duration.seconds
            currentTime = playerItem?.currentTime().seconds ?? 0.0
            if CMTimeGetSeconds(duration).isNaN || CMTimeGetSeconds(duration).isInfinite {
                viewDuration = 0.0
            }
            endTime = convertSecondsToTime(second: Int(viewDuration))
        }
        backgroundMode()
        
        if sound.contains(".mp3") {
            extractMetadata()
            isLive = false
        } else {
            title = "Dubstep.FM"
            subTitle = "Live"
            isLive = true
        }
    }
    
    func changeQuality(sound: String) {
        pause()
        endTime = "00:00:00"
        playSound(sound: sound)
        play()
    }
    
    func play() {
        isPlaying = true
        audioPlayer?.play()
        runTimer()
//        setupNowPlaying()
//        setupRemoteTransportControls()
    }
    
    func pause() {
        isPlaying = false
        audioPlayer?.pause()
        timer.invalidate()
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        currentTime = playerItem?.currentTime().seconds ?? 0.0
        if currentTime > viewDuration - 0.5 && !isLive {
            pause()
            currentTime = 0.0
            playerSeek(time: 0.0)
        }
        time = convertSecondsToTime(second: Int(currentTime))
        
    }
    
    private func convertSecondsToTime(second: Int) -> String {
        let seconds = second % 60
        let minutes = (second / 60) % 60
        let hours = (second / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func playerSeek (time: Double) {
        var time = time
        if time < 1 && !isLive {
            time = 0.0
        }
        let to = CMTimeMake(value: Int64(time), timescale: 1)
        audioPlayer?.seek(to: to)
    }
    private func backgroundMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
//    func setupRemoteTransportControls() {
//        // Get the shared MPRemoteCommandCenter
//        let commandCenter = MPRemoteCommandCenter.shared()
//
//        // Add handler for Play Command
//        commandCenter.playCommand.addTarget { [unowned self] event in
//            if self.audioPlayer?.rate == 0.0 {
//                self.audioPlayer?.play()
//                return .success
//            }
//            return .commandFailed
//        }
//
//        // Add handler for Pause Command
//        commandCenter.pauseCommand.addTarget { [unowned self] event in
//            if self.audioPlayer?.rate == 1.0 {
//                self.audioPlayer?.pause()
//                return .success
//            }
//            return .commandFailed
//        }
//    }
//
//    func setupNowPlaying() {
//        // Define Now Playing Info
//        var nowPlayingInfo = [String : Any]()
//        nowPlayingInfo[MPMediaItemPropertyTitle] = "My Movie"
//
//        if let image = UIImage(named: "lockscreen") {
//            nowPlayingInfo[MPMediaItemPropertyArtwork] =
//            MPMediaItemArtwork(boundsSize: image.size) { size in
//                return image
//            }
//        }
//        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem?.currentTime().seconds
//        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem?.asset.duration.seconds
//        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer?.rate
//
//        // Set the metadata
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
//    }
    
    private func extractMetadata() {
        let metadataList = playerItem?.asset.metadata
        for item in metadataList! {
            if let stringValue = item.value {
                if item.commonKey == .commonKeyTitle {
                    if let podcastTitle = stringValue as? String {
                        self.title = podcastTitle
                    } else {
                        self.title = "Dubstep.FM"
                    }
                }
                if item.commonKey == .commonKeyAlbumName {
                    if let podcastAlbum = stringValue as? String {
                        self.subTitle += " - "
                        self.subTitle += podcastAlbum
                    }
                }

                if item.commonKey  == .commonKeyArtist {
                    if let podcastArtist = stringValue as? String {
                        self.subTitle = podcastArtist
                    }
                }
            }
        }
    }
    
}
