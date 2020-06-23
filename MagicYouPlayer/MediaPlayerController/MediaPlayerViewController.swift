//
//  MediaPlayerViewController.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 20.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit
import AVFoundation

class MediaPlayerViewController: UIViewController {
    
    @IBOutlet weak var backgroundPlayerView: UIView!
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
    var isPlaying = true
    var path = "https://www.youtube.com/watch?v="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recieveUrl = url, let id = videoId {
            mediaPlayer = AVPlayer(url: recieveUrl)
            updatingItemsInfo(id: id)
        }
        
        playerSetup()
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLayoutSubviews() {
        
        playerLayer.frame = videoMediaPlayerView.bounds
        backgroundPlayerView.cornerRadiusView(corners: [.topLeft, .topRight], radius: 20)
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
