//
//  PlayListViewController.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit
//import UPCarouselFlowLayout

class PlayListViewController: UIViewController {
    
    @IBOutlet weak var channelsCollectionView: UICollectionView!
    @IBOutlet weak var playlistCollectionView: UICollectionView!
    @IBOutlet weak var favoritePlaylistCollectionview: UICollectionView!
    @IBOutlet weak var playlistCollectionTextLabel: UILabel!
    @IBOutlet weak var favoristPlaylistTextLabel: UILabel!
    @IBOutlet weak var channelPageControl: UIPageControl!
    @IBOutlet weak var playerOpenCloseImageView: UIImageView!
    //    let flowLayout = ZoomAndSnapFlowLayout()
    var channels: [Item] = []
    var channelsPlaylists: [[Item]] = []
    var favoritePlaylist: [Item] = []
    
    let channelOneId = "&id=UCVHOgH4XEyYx-ZEaya1XqCQ"
    let secondChannelId = "&id=UCPu3YP9Qgl46UdFrGvyguNw"
    let thirdChannelId = "&id=UCxbViCBWaW2RLZLGcOdsxAw"
    let fourthChannelId = "&id=UCzWdpFOflXTOk5Gsi2aJ67g"
    let channelPart = "part=contentDetails%2Csnippet%2Cstatistics"
    let playlistPart = "part=snippet%2CcontentDetails&maxResults=10&playlistId="
    let videoPart = "part=contentDetails%2Csnippet%2Cstatistics&id="
    let channelsLink = "channels?"
    let playlistLink = "playlistItems?"
    let videoLink = "videos?"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getChannels(channelsId: channelOneId + secondChannelId + thirdChannelId + fourthChannelId)
        channelsCollectionView.register(UINib(nibName: "ChannelsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChannelsCollectionViewCell")
        playlistCollectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        favoritePlaylistCollectionview.register((UINib(nibName: "FavoritePlaylistCollectionViewCell", bundle: nil)), forCellWithReuseIdentifier: "FavoritePlaylistCollectionViewCell")
        
        setupUI()
        //        channelsCollectionView.collectionViewLayout = flowLayout
        channelCollectionTimer()
    }
    
    @IBAction func didTapPlayerActionButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MediaPlayerViewController") as! MediaPlayerViewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .coverVertical
        self.present(viewController, animated: true, completion: nil)
    }
}

