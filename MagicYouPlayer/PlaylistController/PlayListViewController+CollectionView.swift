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
        if collectionView == playlistCollectionView {
            return channelsPlaylists.count
        } else if collectionView == channelsCollectionView {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == channelsCollectionView {
            return channels.count
        } else if collectionView == playlistCollectionView {
            return channelsPlaylists[section].count
        } else {
//            debugPrint(channelsPlaylists[section].count)
            
            return favoritePlaylist.count
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
        } else if collectionView == favoritePlaylistCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritePlaylistCollectionViewCell", for: indexPath) as! FavoritePlaylistCollectionViewCell
//            cell.updatePlaylistCell(playlistItems: channelsPlaylists[sec][indexPath.row])
            cell.updatePlaylistCell(playlistItems: favoritePlaylist[indexPath.row])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
            cell.updatePlaylistCell(playlistItems: channelsPlaylists[indexPath.section][indexPath.row])
            return cell
        }
    }
}
