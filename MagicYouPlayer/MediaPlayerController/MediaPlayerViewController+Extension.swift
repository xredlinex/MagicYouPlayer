//
//  MediaPlayerViewController+Extension.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 22.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit
import AVFoundation
import YoutubeDirectLinkExtractor

extension MediaPlayerViewController {
    
    func updatingItemsInfo(id: String) {
        
        if let currentItem = playlist.first(where: { $0.id == id}) {
            videoTitileTextLabel.text = currentItem.snippet?.title ?? "----"
            if let views = currentItem.statistics?.viewCount {
                videoViewsCountTextLabel.text = "\(views) просмотра"
            }
        }
    }
}

extension MediaPlayerViewController {
    
    func setupUI() {
        timeSlider.value = 0
        playerCloseImageView.image = UIImage(named: "Close_Open")
        playPauseImageView.image = isPlaying ? UIImage(named: "Pause") : UIImage(named: "Play")
    }
}

extension MediaPlayerViewController {
    
    func playerSetup() {
        
        mediaPlayer.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        timeObserver()
        playerLayer = AVPlayerLayer(player: mediaPlayer)
        playerLayer.frame = videoMediaPlayerView.bounds
        playerLayer.videoGravity = .resize
        videoMediaPlayerView.layer.addSublayer(playerLayer)
        mediaPlayer.play()
    }
}

extension MediaPlayerViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "duration", let duration = mediaPlayer.currentItem?.duration.seconds, duration > 0.0 {
            if let currentItem = mediaPlayer.currentItem {
                self.videoDurationLeftTextLabel.text = stringTime(from: currentItem.duration)
            }
        }
    }
    
    func timeObserver() {
        let timeInterval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        _ = mediaPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { [weak self] time in
            guard let currentItem = self?.mediaPlayer.currentItem else {return}
            guard currentItem.status.rawValue == AVPlayer.Status.readyToPlay.rawValue else {return}
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            if let timeLeft = self?.stringTime(from: currentItem.duration - currentItem.currentTime()) {
                self?.videoDurationLeftTextLabel.text = "- \(timeLeft)"
            }
            self?.currentTimePositionTextLabel.text = self?.stringTime(from: currentItem.currentTime())
        })
    }
}

extension MediaPlayerViewController {
    
    func stringTime(from time: CMTime) -> String {
        
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}


extension MediaPlayerViewController {
    
    func getVideoDirrectUrl(_ id: String) {
        
        let extractor = YoutubeDirectLinkExtractor()
        extractor.extractInfo(for: .id(id), success: { (videoInfo) in
            DispatchQueue.main.async {
                if let videoUrl = videoInfo.highestQualityPlayableLink {
                    if let url = URL(string: videoUrl) {
                        DispatchQueue.main.async {
                            self.mediaPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
                        }
                    }
                }
            }
        }) { (error) in
            debugPrint(error)
        }
    }
}

extension MediaPlayerViewController {
    
    func playVideo() {
        if isPlaying {
            mediaPlayer.pause()
        } else {
            mediaPlayer.play()
        }
        playPauseImageView.image = !isPlaying ? UIImage(named: "Pause") : UIImage(named: "Play")
        isPlaying = !isPlaying
    }
    
    func previousVideo() {
        
        if let position = currentPositionInPlaylist {
            if position != playlist.startIndex {
                if let id = playlist[position - 1].id {
                    currentPositionInPlaylist = position - 1
                    getVideoDirrectUrl(id)
                    updatingItemsInfo(id: id)
                }
            } else {
                if let id = playlist[playlist.endIndex - 1].id {
                    currentPositionInPlaylist = playlist.endIndex - 1
                    getVideoDirrectUrl(id)
                    updatingItemsInfo(id: id)
                }
            }
        }
    }
    
    func nextVideo() {
        
        if let position = currentPositionInPlaylist {
            if position != playlist.endIndex - 1 {
                if let id = playlist[position + 1].id {
                    currentPositionInPlaylist = position + 1
                    getVideoDirrectUrl(id)
                    updatingItemsInfo(id: id)
                }
            } else {
                if let id = playlist[playlist.startIndex].id {
                    currentPositionInPlaylist = playlist.startIndex
                    getVideoDirrectUrl(id)
                    updatingItemsInfo(id: id)
                }
            }
        }
    }
}
