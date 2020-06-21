//
//  PlayListViewController+CollectionView.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

extension PlayListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch (collectionView) {
        case channelsCollectionView:
            return 1
        case playlistCollectionView:
            return channelsPlaylists.count
        case favoritePlaylistCollectionview:
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case channelsCollectionView:
            channelPageControl.numberOfPages = channels.count
            return channels.count
        case playlistCollectionView:
            return channelsPlaylists[section].count
        case favoritePlaylistCollectionview:
            return favoritePlaylist.count
        default:
            return 1
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
        } else if collectionView == playlistCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
            cell.updatePlaylistCell(playlistItems: channelsPlaylists[indexPath.section][indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritePlaylistCollectionViewCell", for: indexPath) as! FavoritePlaylistCollectionViewCell
            cell.updatePlaylistCell(playlistItems: favoritePlaylist[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == playlistCollectionView {
            if let channelTitle = channelsPlaylists[indexPath.section][indexPath.row].snippet?.channelTitle {
                playlistCollectionTextLabel.text = channelTitle
            }
        } else {
            if let channelTitle = favoritePlaylist[indexPath.row].snippet?.channelTitle {
                favoristPlaylistTextLabel.text = channelTitle
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == favoritePlaylistCollectionview {
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.width / 2)
        } else if collectionView == playlistCollectionView {
            return CGSize(width: collectionView.frame.width / 2.3, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
        channelPageControl.currentPage = Int((channelsCollectionView.contentOffset.x / channelsCollectionView.frame.width).rounded(.toNearestOrAwayFromZero)
        )
    }
}
