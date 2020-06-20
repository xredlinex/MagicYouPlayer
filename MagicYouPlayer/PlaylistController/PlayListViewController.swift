//
//  PlayListViewController.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

class PlayListViewController: UIViewController {
    
    @IBOutlet weak var channelsCollectionView: UICollectionView!
    
    let flowLayout = ZoomAndSnapFlowLayout()
    var channels: [Item] = []
    var channelsPlaylists: [[Item]] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getChannels(channelsId: channelOneId + secondChannelId + thirdChannelId + fourthChannelId)
        channelsCollectionView.register(UINib(nibName: "ChannelsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChannelsCollectionViewCell")
        
        channelsCollectionView.collectionViewLayout = flowLayout
        channelsCollectionView.contentInsetAdjustmentBehavior = .always
//        channelCollectionTimer()
    }
    
    @IBAction func didTapPlayerActionButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MediaPlayerViewController") as! MediaPlayerViewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .coverVertical
        self.present(viewController, animated: true, completion: nil)
    }
}

extension PlayListViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == channelsCollectionView {
            return channels.count
        } else {
//            add logic for playlist collection view
            return channels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == channelsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelsCollectionViewCell", for: indexPath) as! ChannelsCollectionViewCell
            for items in channelsPlaylists {
                if let random = items.first(where: { $0.snippet?.channelId == channels[indexPath.row].id}) {
                    cell.updateChanneCell(channel: channels[indexPath.row], channelVideo: random)
                }
            }
            return cell
        } else {
//            add logic for playlist collection view
        }
        return UICollectionViewCell()
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
                           collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                       }
                   }
               }
           }
       }
    
}
