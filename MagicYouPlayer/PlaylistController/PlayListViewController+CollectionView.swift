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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        playVideo(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == favoritePlaylistCollectionview {
            return CGSize(width: collectionView.frame.width / 3 - 5, height: collectionView.frame.height)
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

extension PlayListViewController {
    
    func playVideo(collectionView: UICollectionView, indexPath: IndexPath) {
        
        switch collectionView {
        case playlistCollectionView:
            if let videoId = channelsPlaylists[indexPath.section][indexPath.row].id {
                getVideoDirrectUrl(id: videoId) { (url) in
                    DispatchQueue.main.async {
                        self.presenModalController(url: url, playlist: self.channelsPlaylists[indexPath.section], position: indexPath.row, id: videoId)
                    }
                }
            } else {
                self.view.makeToast(alertError.errorKey(.videoId), duration: 3.0, position: .bottom)
            }
        case favoritePlaylistCollectionview:
            if let videoId = favoritePlaylist[indexPath.row].id {
                getVideoDirrectUrl(id: videoId) { (url) in
                    DispatchQueue.main.async {
                        self.presenModalController(url: url, playlist: self.favoritePlaylist, position: indexPath.row, id: videoId)
                    }
                }
            } else {
                self.view.makeToast(alertError.errorKey(.videoId), duration: 3.0, position: .bottom)
            }
        case channelsCollectionView:
            for items in channelsPlaylists {
                if let video = items.first(where: { $0.snippet?.channelId == channels[indexPath.row].id}) {
                    if let videoId = video.id {
                        getVideoDirrectUrl(id: videoId) { (url) in
                            DispatchQueue.main.async {
                                self.presenModalController(url: url, playlist: items, position: 0, id: videoId)
                            }
                        }
                    }
                } else {
                    self.view.makeToast(alertError.errorKey(.videoId), duration: 3.0, position: .bottom)
                }
            }
        default:
            return
        }
    }
}

extension PlayListViewController {
    
    func presenModalController(url: URL, playlist: [Item], position: Int, id: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MediaPlayerViewController") as! MediaPlayerViewController
        viewController.url = url
        viewController.playlist = playlist
        viewController.currentPositionInPlaylist = position
        viewController.videoId = id
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .coverVertical
        self.present(viewController, animated: true, completion: nil)
    }
}


