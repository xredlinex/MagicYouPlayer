//
//  PlayListViewController+CollectionView.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

extension PlayListViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
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
}
