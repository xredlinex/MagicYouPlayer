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
    
    let flowLayout = ZoomAndSnapFlowLayout()
    var channels: [Item] = []
    var channelsPlaylists: [[Item]] = []
    var favoritePlaylist: [Item] = []
    
    let channelOneId = "&id=UCVHOgH4XEyYx-ZEaya1XqCQ"
    let secondChannelId = "&id=UCPu3YP9Qgl46UdFrGvyguNw"
    let thirdChannelId = "&id=UCxbViCBWaW2RLZLGcOdsxAw"
    let fourthChannelId = "&id=UCzWdpFOflXTOk5Gsi2aJ67g"
    let channelPart = "part=contentDetails%2Csnippet%2Cstatistics"
    let playlistPart = "part=snippet%2CcontentDetails&maxResults=10&playlistId="
    let videoPart = "part=contentDetails%2Csnippet%2Cstatistics"
    let channelsLink = "channels?"
    let playlistLink = "playlistItems?"
    let videoLink = "videos?"
    
    let collectionViewHeaderFooterReuseIdentifier = "MyHeaderFooterClass"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getChannels(channelsId: channelOneId + secondChannelId + thirdChannelId + fourthChannelId)
        channelsCollectionView.register(UINib(nibName: "ChannelsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChannelsCollectionViewCell")
        playlistCollectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        favoritePlaylistCollectionview.register((UINib(nibName: "FavoritePlaylistCollectionViewCell", bundle: nil)), forCellWithReuseIdentifier: "FavoritePlaylistCollectionViewCell")
        

        let layout = favoritePlaylistCollectionview.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        let playlistLayout = playlistCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        playlistLayout.minimumLineSpacing = 15
        

        channelsCollectionView.collectionViewLayout = flowLayout
        
        
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

extension PlayListViewController {
    
    func channelCollectionTimer() {
           
           _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollingChannelCollection(timer:)), userInfo: nil, repeats: true)
       }
       
       @objc func scrollingChannelCollection(timer: Timer) {
           if let collectionView = channelsCollectionView {
               for cell in collectionView.visibleCells {
                   if let indexPath = collectionView.indexPath(for: cell) {
                       if indexPath.row < channels.count - 1 {
                           let nextIndexPath = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                           collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                       } else {
                           let nextIndexPath = IndexPath(row: 0, section: indexPath.section)
                        collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
                       }
                   }
               }
           }
       }
    
}
