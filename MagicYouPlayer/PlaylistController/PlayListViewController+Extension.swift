//
//  PlayListViewController+Extension.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit
import YoutubeDirectLinkExtractor

//  MARK: - channels info continuous async requset -

extension PlayListViewController {
    
    func getChannels(channelsId: String) {
        
        NetworkService.getRequest(endPoint: channelsLink, part: channelPart, type: channelsId, viewController: self) { (items) in
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
        
        NetworkService.getRequest(endPoint: playlistLink, part: playlistPart, type: playlistId, viewController: self) { (items) in
            DispatchQueue.main.async {
                self.getVideoStat(videoIdGroup: items)
                self.view.hideToastActivity()
            }
        }
    }
    
    func getVideoStat(videoIdGroup: [Item]) {
        
        let idString = videoIdGroup.map { ($0.contentDetails?.videoId ?? "") }.joined(separator: ",")
        NetworkService.getRequest(endPoint: videoLink, part: videoPart, type: idString, viewController: self) { (items) in
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

//  MARK: - get direct video url link extractor -

extension PlayListViewController {
    
    func getVideoDirrectUrl(id: String, complition: @escaping (_ url: URL) -> ()) {

        let extractor = YoutubeDirectLinkExtractor()
        extractor.extractInfo(for: .id(id), success: { (videoInfo) in
            DispatchQueue.main.async {
                if let videoUrl = videoInfo.highestQualityPlayableLink {
                    if let getUrl = URL(string: videoUrl) {
                        complition(getUrl)
                    }
                } else if let videoUrl = videoInfo.lowestQualityPlayableLink {
                    if let getUrl = URL(string: videoUrl) {
                        complition(getUrl)
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.view.makeToast(self.alertError.errorKey(.extractorError), duration: 2.0, position: .bottom)
            }
        }
    }
}

// MARK: - did tap collection view cell video

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

// MAKR: - user interface elements

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

// MARK: - channels collection view timer slider - 

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
