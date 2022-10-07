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
    
    private var timeObserverToken: Any?
    
    func playSound(sound: String) {
        
        if let url = URL(string: sound) {
            self.playerItem = AVPlayerItem(url: url)
            self.audioPlayer = AVPlayer(playerItem: self.playerItem)
            let duration = playerItem?.asset.duration ?? CMTime(seconds: 1, preferredTimescale: 1)
            viewDuration = duration.seconds
            currentTime = playerItem?.currentTime().seconds ?? 0.0
            if CMTimeGetSeconds(duration).isNaN || CMTimeGetSeconds(duration).isInfinite {
                viewDuration = 0.0
            }
            endTime = convertSecondsToTime(second: Int(viewDuration))
        }
        
        backgroundMode()
        setupRemoteTransportControls()
        
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
        addPeriodicTimeObserver()
    }
    
    func pause() {
        isPlaying = false
        audioPlayer?.pause()
        removePeriodicTimeObserver()
    }
    
    func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = audioPlayer?.addPeriodicTimeObserver(forInterval: time, queue: .main) {
            [weak self] time in
            self!.currentTime = time.seconds//playerItem?.currentTime().seconds ?? 0.0
            if self!.currentTime > self!.viewDuration - 0.5 && !self!.isLive {
                self!.pause()
                self!.currentTime = 0.0
                self!.playerSeek(time: 0.0)
            }
            self!.time = self!.convertSecondsToTime(second: Int(self!.currentTime))
            self!.setupNowPlaying()
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            audioPlayer?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
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
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay, .allowBluetoothA2DP, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func convertSecondsToTime(second: Int) -> String {
        let seconds = second % 60
        let minutes = (second / 60) % 60
        let hours = (second / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.audioPlayer!.rate == 0.0 {
                self.audioPlayer!.play()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.audioPlayer!.rate == 1.0 {
                self.audioPlayer!.pause()
                return .success
            }
            return .commandFailed
        }
        
        if isLive {
            commandCenter.changePlaybackPositionCommand.addTarget { event in
                if let event = event as? MPChangePlaybackPositionCommandEvent {
                    self.audioPlayer?.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
                        guard let self = self else {return}
                        if success {
                            self.audioPlayer?.rate = 1.0
                        }
                    })
                    return .success
                }
                return .commandFailed
            }
            
            commandCenter.skipForwardCommand.preferredIntervals = [15]
            commandCenter.skipForwardCommand.addTarget { event in
                if !self.isLive {
                    self.playerSeek(time: self.currentTime + 15)
                    return .success
                }
                return .commandFailed
            }
            
            commandCenter.skipBackwardCommand.preferredIntervals = [15]
            commandCenter.skipBackwardCommand.addTarget { event in
                if !self.isLive {
                    self.playerSeek(time: self.currentTime - 15)
                    return .success
                }
                return .commandFailed
            }
        }
        
    }
    
    private func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = subTitle
        
        if let image = UIImage(named: "dsfm_cover") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
            MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer?.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = playerItem?.currentTime().seconds
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
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
