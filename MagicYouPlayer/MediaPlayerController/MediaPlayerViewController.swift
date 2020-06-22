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
    @IBOutlet weak var videoDurationTextLabel: UILabel!
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
        
//        if let id = videoId {
//            debugPrint(id)
//            getVideoDirrectUrl(path + id)
//        }
        
        
        if let recieveUrl = url {
          mediaPlayer = AVPlayer(url: recieveUrl)
        }
        
        
        
//        mediaPlayer.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
//              timeObserver()
//              playerLayer = AVPlayerLayer(player: mediaPlayer)
//              playerLayer.videoGravity = .resize
//
//              videoMediaPlayerView.layer.addSublayer(playerLayer)
        
        
        
        
        
        
        playerSetup()
        setupUI()
      
         
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLayoutSubviews() {
        debugPrint("load sub")
        playerLayer.frame = videoMediaPlayerView.bounds
        debugPrint("layout")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        
        if keyPath == "duration", let duration = mediaPlayer.currentItem?.duration.seconds, duration > 0.0 {
            if let currentItem = mediaPlayer.currentItem {
                self.videoDurationTextLabel.text = getTimeString(from: currentItem.duration)
            }
        }
    }
    
    @IBAction func didTapDismissActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func didTapPreviousMediaActionButton(_ sender: Any) {
    }
    
    @IBAction func didTapNextMediaActionButton(_ sender: Any) {
    }
    
    @IBAction func didTapPlayPauseActionButton(_ sender: Any) {
//        playPauseImageView.image = isPlaying ? UIImage(named: "Pause") : UIImage(named: "Play")
//        isPlaying = !isPlaying
        
        if isPlaying {
            mediaPlayer.pause()
//            sender.setTitle("Play", for: .normal)
        }else {
            mediaPlayer.play()
//            sender.setTitle("Pause", for: .normal)
        }
        
        isPlaying = !isPlaying
        
        
        
    }
    
    
    @IBAction func sliderValueChanged(_ sender: Any) {

    }
    
    
    
    
}

extension MediaPlayerViewController {
    
    func setupUI() {
        
        playerCloseImageView.image = UIImage(named: "Close_Open")
        
        playPauseImageView.image = isPlaying ? UIImage(named: "Pause") : UIImage(named: "Play")
        
    }
}

extension MediaPlayerViewController {
    
    func playerSetup() {
        
//        mediaPlayer = AVPlayer(url: url)
        
        
        mediaPlayer.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        timeObserver()
        playerLayer = AVPlayerLayer(player: mediaPlayer)
        playerLayer.frame = videoMediaPlayerView.bounds
        playerLayer.videoGravity = .resize
        videoMediaPlayerView.layer.addSublayer(playerLayer)
       
    }
    
    func timeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
//        _ = mediaPlayer.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
//            guard let currentItem = self?.mediaPlayer.currentItem else {return}
//            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
//            self?.timeSlider.maximumValue = 0
//            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
//            self?.currentTimePositionTextLabel.text = self?.getTimeString(time: currentItem.currentTime())
            
            _ = mediaPlayer.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.mediaPlayer.currentItem else {return}
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimePositionTextLabel.text = self?.getTimeString(from: currentItem.currentTime())
            
            
            
        })
    }
    
    
    func getTimeString(from time: CMTime) -> String {
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
    
    
    
//    func getTimeString(time: CMTime) -> String {
//        let totalSeconds = CMTimeGetSeconds(time)
//        let hours = Int(totalSeconds / 3600)
//        let minutes = Int(totalSeconds / 60) % 60
//        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
//        if hours > 0 {
//            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
//        }else {
//            return String(format: "%02i:%02i", arguments: [minutes,seconds])
//        }
//    }
}



extension MediaPlayerViewController {
    
    func getVideoDirrectUrl(_ videoString: String) {
        
        let extractor = YoutubeDirectLinkExtractor()
        extractor.extractInfo(for: .urlString(videoString), success: { (videoInfo) in
            DispatchQueue.main.async {
                if let videoUrl = videoInfo.highestQualityPlayableLink {
                    if let url = URL(string: videoUrl) {
//                        self.url = url
//                        self.playerSetup(url: url)
                        
                        debugPrint(url)
                    }
                }
            }
        }) { (error) in
            debugPrint(error)
        }
    }
}
