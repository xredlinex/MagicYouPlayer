//
//  PlayListViewController+Extension.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit


extension PlayListViewController {
    
    func getChannels(channelsId: String) {
        
        NetworkService.getRequest(endPoint: channelsLink, part: channelPart, type: channelsId) { (items) in
            self.channels = items
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
            
            
//            self.favoritePlaylist = items
//            self.getVideoStat(videoIdGroup: items)
            DispatchQueue.main.async {
               self.getVideoStat(videoIdGroup: items)
//                self.favoritePlaylistCollectionview.reloadData()
            }
        }
    }
    
    func getVideoStat(videoIdGroup: [Item]) {
     
        
        let idString = videoIdGroup.map { ($0.contentDetails?.videoId ?? "") }.joined(separator: ",")
        
        debugPrint("->>>>>>>>>")
        debugPrint(idString)
        debugPrint("<<<<<<<<<<<")
        
        NetworkService.getRequest(endPoint: videoLink, part: videoPart, type: idString) { (items) in
            self.channelsPlaylists.append(items)
            self.favoritePlaylist = items
            
            DispatchQueue.main.async {
                self.channelsCollectionView.reloadData()
                               self.playlistCollectionView.reloadData()
                self.favoritePlaylistCollectionview.reloadData()
                debugPrint("reload collection view data")
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
        
    }
}
