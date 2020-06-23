//
//  PlayListViewController+Extension.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit
import YoutubeDirectLinkExtractor

extension PlayListViewController {
    
    func getChannels(channelsId: String) {
        
        self.view.makeToastActivity(.center)
        NetworkService.getRequest(endPoint: channelsLink, part: channelPart, type: channelsId) { (items) in
            self.channels = items
            debugPrint(items.count)
            DispatchQueue.main.async {
                for channel in self.channels {
                    if let playlistId = channel.contentDetails?.relatedPlaylists?.uploads {
                        self.getPlaylist(playlistId: playlistId)
                    }
                }
            }
        }
    }
    
    func getPlaylist(playlistId: String) {
        
        NetworkService.getRequest(endPoint: playlistLink, part: playlistPart, type: playlistId) { (items) in
            DispatchQueue.main.async {
                self.getVideoStat(videoIdGroup: items)
            }
        }
    }
    
    func getVideoStat(videoIdGroup: [Item]) {
        
        let idString = videoIdGroup.map { ($0.contentDetails?.videoId ?? "") }.joined(separator: ",")
        NetworkService.getRequest(endPoint: videoLink, part: videoPart, type: idString) { (items) in
            self.channelsPlaylists.append(items)
            self.favoritePlaylist = items
            DispatchQueue.main.async {
                self.channelsCollectionView.reloadData()
                self.playlistCollectionView.reloadData()
                self.favoritePlaylistCollectionview.reloadData()
                self.view.hideToastActivity()
            }
        }
    }
}

extension PlayListViewController {
    
    func setupUI() {
        
        let layout = favoritePlaylistCollectionview.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        let playlistLayout = playlistCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        playlistLayout.minimumLineSpacing = 15
        
        playerOpenCloseImageView.image = UIImage(named: "Close_Open")
        playerOpenCloseImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        let colorOne = UIColor(red: 235/255, green: 89/255, blue: 162/255, alpha: 1).cgColor
        let  colorTwo = UIColor(red: 244/255, green: 94/255, blue: 154/255, alpha: 1).cgColor
        openPlayerView.setupGradient([colorOne, colorTwo])
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

extension PlayListViewController {
    
    func getVideoDirrectUrl(id: String, complition: @escaping (_ url: URL) -> ()) {
        
        let extractor = YoutubeDirectLinkExtractor()
        extractor.extractInfo(for: .id(id), success: { (videoInfo) in
            DispatchQueue.main.async {
                if let videoUrl = videoInfo.highestQualityPlayableLink {
                    if let getUrl = URL(string: videoUrl) {
                        complition(getUrl)
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.view.makeToast("Error Extract Youtube Direct Link", duration: 3.0, position: .top)                
            }
        }
    }
}
