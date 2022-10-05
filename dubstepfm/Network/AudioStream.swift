//
//  AudioStream.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 10/3/22.
//

import AVFoundation
import MediaPlayer
import AVKit

class AudioStream: NSObject, ObservableObject {
    
    @Published private(set) var isPlaying = false
    @Published private(set) var title = "Dubstep.FM Live"
    
    weak var myDelegate: AVPlayerItemMetadataOutputPushDelegate?
    
    private var audioPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    func playSound(sound: String) {
        if let url = URL(string: sound) {
            
            self.playerItem = AVPlayerItem(url: url)
            self.audioPlayer = AVPlayer(playerItem: self.playerItem)
            self.audioPlayer?.allowsExternalPlayback = true
            
            let metaOutput = AVPlayerItemMetadataOutput(identifiers: [AVMetadataIdentifier.commonIdentifierTitle.rawValue])
            metaOutput.setDelegate(self, queue: DispatchQueue.main)
            self.playerItem?.add(metaOutput)
            
        }
        backgroundMode()
    }
    
    func play() {
        isPlaying = true
        audioPlayer?.play()
        
//        setupNowPlaying()
//        setupRemoteTransportControls()
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
    
}

extension AudioStream: AVPlayerItemMetadataOutputPushDelegate {
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        let group = groups.first
        print("AAAAAAAAA   \(group)")
        let item = group?.items.first
        print("BBBBBBBBB   \(item)")
                // simplest demo, in common case iterate all groups and all items in group
        // to find what you need if you requested many metadata
        if let group = groups.first,let item = group.items.first {
            self.title = item.stringValue ?? "Unknown"
        }
    }
    
}
