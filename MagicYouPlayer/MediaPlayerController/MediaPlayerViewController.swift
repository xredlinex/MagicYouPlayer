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
    
    @IBOutlet weak var videoMediaPlayerView: UIView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimePositionTextLabel: UILabel!
    @IBOutlet weak var videoDurationTextLabel: UILabel!
    @IBOutlet weak var playerCloseImageView: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    
    var mediaPlayer = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    var videoId: String?
    var playlist: [Item] = []
    var currentPositionInPlaylist: Int?
    var url: URL?
    var isVideoPlay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let id = videoId {
            getVideoDirrectUrl(id)
        }
        
        setupUI()
        playerSetup()
        timeObserver()
    }
    
     override func awakeFromNib() {
       super.awakeFromNib()

       modalPresentationStyle = .overFullScreen
     }
    
    override func viewDidLayoutSubviews() {
        playerLayer.frame = videoMediaPlayerView.bounds
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = mediaPlayer.currentItem?.duration.seconds, duration > 0.0 {
            if let currentItem = mediaPlayer.currentItem {
                self.videoDurationTextLabel.text = getTimeString(time: currentItem.duration)
            }
        }
    }
    
    @IBAction func didTapDismissActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MediaPlayerViewController {
    
    func setupUI() {
        
        playerCloseImageView.image = UIImage(named: "Close_Open")
    }
}

extension MediaPlayerViewController {
    
    func playerSetup() {
        
        mediaPlayer.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        playerLayer = AVPlayerLayer(player: mediaPlayer)
        playerLayer.videoGravity = .resize
        videoMediaPlayerView.layer.addSublayer(playerLayer)
    }
    
    func timeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        _ = mediaPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
            guard let currentItem = self?.mediaPlayer.currentItem else {return}
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.maximumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimePositionTextLabel.text = self?.getTimeString(time: currentItem.currentTime())
        })
    }
    
    
    func getTimeString(time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}



extension MediaPlayerViewController {

    func getVideoDirrectUrl(_ videoId: String) {
        
        let extractor = YoutubeDirectLinkExtractor()
        extractor.extractInfo(for: .id(videoId), success: { (videoInfo) in
            DispatchQueue.main.async {
                if let videoUrl = videoInfo.highestQualityPlayableLink {
                    if let url = URL(string: videoUrl) {
                        self.url = url
//                        put player link here
                    }
                }
            }
        }) { (error) in
            debugPrint(error)
        }
    }
}
