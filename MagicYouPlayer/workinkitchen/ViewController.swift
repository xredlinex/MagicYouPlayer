//
//  ViewController.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit
import AVFoundation
import YoutubeDirectLinkExtractor


class ViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    var channel: [Item]?
    var playlist: [Item]?
    
    var isVideoPlaying = false
    
    let channelOneId = "&id=UCVHOgH4XEyYx-ZEaya1XqCQ"
    let secondChannelId = "&id=UCPu3YP9Qgl46UdFrGvyguNw"
    let thirdChannelId = ""
    let fourthChannelId = ""
    
     let channelPart = "part=contentDetails%2Csnippet%2Cstatistics"
      let playlistPart = "part=snippet%2CcontentDetails&maxResults=10&playlistId="
      let videoPart = "part=contentDetails%2Csnippet%2Cstatistics"
    
     let channelsLink = "channels?"
     let playlistLink = "playlistItems?"
     let videoLink = "videos?"
    
    var getURL: URL?
    
    @IBOutlet weak var timeSlider: UISlider!
       @IBOutlet weak var currentTimeLabel: UILabel!
       @IBOutlet weak var durationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        if let url = getURL {
            player = AVPlayer(url: url)
        }
        


       
       player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
       addTimeObserver()
       playerLayer = AVPlayerLayer(player: player)
       playerLayer.videoGravity = .resize
       
       videoView.layer.addSublayer(playerLayer)
        
        
        
        
        
        let chchch = channelOneId + secondChannelId
        
        getChannals(channalsId: chchch)

        
//        NetworkService.getRequest(endPoint: channelsLink, part: channelPart, type: channelId) { (item) in
//            self.channel = item
//
//            DispatchQueue.main.async {
//                if let cha = self.channel {
//                    for i in cha {
//                        debugPrint(i.snippet?.title)
//                        if let playListId = i.contentDetails?.relatedPlaylists?.uploads {
//                            self.getPlaylist(playlistId: playListId)
//                        }
//
//                    }
//                }
//            }
//        }
        
    }
    

    func playVideo(url: URL) {
        
//        player = AVPlayer(url: url)
//        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
//        addTimeObserver()
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resize
//
//        debugPrint(url)
//        videoView.layer.addSublayer(playerLayer)
        
        
    }
        
        
        
    
    
    
    
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           playerLayer.frame = videoView.bounds
       }
//
     func addTimeObserver() {
           let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
           let mainQueue = DispatchQueue.main
           _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
               guard let currentItem = self?.player.currentItem else {return}
               self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
               self?.timeSlider.minimumValue = 0
               self?.timeSlider.value = Float(currentItem.currentTime().seconds)
               self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
           })
       }
//    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = getTimeString(from: player.currentItem!.duration)
        }
    }
//
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
    
//
    
    
    
    @IBAction func playPressed(_ sender: UIButton) {
        if isVideoPlaying {
            player.pause()
            sender.setTitle("Play", for: .normal)
        }else {
            player.play()
            sender.setTitle("Pause", for: .normal)
        }
        
        isVideoPlaying = !isVideoPlaying
    }
    
    
    
    
    
    func getChannals(channalsId: String) {
        
        
        
        NetworkService.getRequest(endPoint: channelsLink, part: channelPart, type: channalsId) { (item) in
                   self.channel = item
                   
                   DispatchQueue.main.async {
                       if let cha = self.channel {
                           for i in cha {
                               debugPrint(i.snippet?.title)
                               if let playListId = i.contentDetails?.relatedPlaylists?.uploads {
                                   self.getPlaylist(playlistId: playListId)
                               }
                               
                           }
                       }
                   }
               }
        
    }
    
    
    
    func getPlaylist(playlistId: String) {
        
        NetworkService.getRequest(endPoint: playlistLink, part: playlistPart, type: playlistId) { (item) in
            self.playlist = item
            DispatchQueue.main.async {
                if let list = self.playlist {
                    for i in list {
                        debugPrint(i.snippet?.title)
                    }
                }
            }
            
        }
        
        
    }
    
    
    
    func play() {
        
        
        debugPrint("player")
        let videoURL = URL(string: "https://www.youtube.com/watch?v=sUH7mj3FArc")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        
        
    }

}
