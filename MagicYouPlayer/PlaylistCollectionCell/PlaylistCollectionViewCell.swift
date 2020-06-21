//
//  PlaylistCollectionViewCell.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 20.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var previewVideoView: UIView!
    @IBOutlet weak var playlistPreviewImageView: UIImageView!
    @IBOutlet weak var videoTitleTextLabel: UILabel!
    @IBOutlet weak var previewCountTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension PlaylistCollectionViewCell {
    
    func updatePlaylistCell(playlistItems: Item) {
        
        if let urlLink = playlistItems.snippet?.thumbnails?.high?.url {
            if let url = URL(string: urlLink) {
                playlistPreviewImageView.kf.setImage(with: url)
            }
        }
        videoTitleTextLabel.text = playlistItems.snippet?.title ?? "--"
        previewCountTextLabel.text = "\(playlistItems.statistics?.viewCount ?? "--") просмотров"
        
        previewVideoView.clipsToBounds = true
        previewVideoView.layer.cornerRadius = 12
    }
}
