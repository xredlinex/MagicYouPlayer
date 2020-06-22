//
//  MediaPlayerViewController.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 20.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit
import YoutubeDirectLinkExtractor
import AVFoundation

class MediaPlayerViewController: UIViewController {
    
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var playerCloseImageView: UIImageView!
    @IBOutlet weak var videoMediaPlayerView: UIView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimePositionTextLabel: UILabel!
    @IBOutlet weak var videoDurationLeftTextLabel: UILabel!
    @IBOutlet weak var videoTitileTextLabel: UILabel!
    @IBOutlet weak var videoViewsCountTextLabel: UILabel!
    @IBOutlet weak var soundVolumeSlider: UISlider!
    @IBOutlet weak var playPauseImageView: UIImageView!
    
    var mediaPlayer = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    var videoId: String?
    var playlist: [Item] = []
    var currentPositionInPlaylist: Int?
    var url: URL?
    var isPlaying = false
    var path = "https://www.youtube.com/watch?v="

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recieveUrl = url {
            mediaPlayer = AVPlayer(url: recieveUrl)
        }
        
        playerSetup()
        setupUI()
        
        debugPrint(videoId)
        debugPrint(url)
        debugPrint(currentPositionInPlaylist)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLayoutSubviews() {
        playerLayer.frame = videoMediaPlayerView.bounds
    }
    
    @IBAction func didTapDismissActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapPreviousMediaActionButton(_ sender: Any) {
        previousVideo()
    }
    
    @IBAction func didTapNextMediaActionButton(_ sender: Any) {
        nextVideo()
    }
    
    @IBAction func didTapPlayPauseActionButton(_ sender: Any) {
        playVideo()
    }
    
    
    @IBAction func sliderDurationValueDidChanged(_ sender: Any) {
        mediaPlayer.seek(to: CMTimeMake(value: Int64(timeSlider.value * 1000), timescale: 1000))
    }
    
    @IBAction func sliderSoundVolumeDidChanged(_ sender: Any) {
        mediaPlayer.volume = Float(soundVolumeSlider.value)
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
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}


extension MediaPlayerViewController {
    
    func getVideoDirrectUrl(_ videoString: String) {
        
        let extractor = YoutubeDirectLinkExtractor()
        extractor.extractInfo(for: .urlString(videoString), success: { (videoInfo) in
            DispatchQueue.main.async {
                if let videoUrl = videoInfo.highestQualityPlayableLink {
                    if let url = URL(string: videoUrl) {
                        debugPrint(url)
                        //                        sent ur to video or blayer
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
        }else {
            mediaPlayer.play()
        }
        playPauseImageView.image = !isPlaying ? UIImage(named: "Pause") : UIImage(named: "Play")
        isPlaying = !isPlaying
    }
    
    func previousVideo() {
        
    }
    
    func nextVideo() {
        
        
        
        
        
        
    }
}
