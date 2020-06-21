//
//  FavoritePlaylistCollectionViewCell.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 21.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

class FavoritePlaylistCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var favoritePreviewImageView: UIImageView!
    @IBOutlet weak var favoriteTitileTextLabel: UILabel!
    @IBOutlet weak var favoriteViewCountTextLabel: UILabel!
    @IBOutlet weak var previewVideoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension FavoritePlaylistCollectionViewCell {
    
    func updatePlaylistCell(playlistItems: Item) {
        
        if let urlLink = playlistItems.snippet?.thumbnails?.high?.url {
            if let url = URL(string: urlLink) {
                favoritePreviewImageView.kf.setImage(with: url)
            }
        }
        
        favoriteTitileTextLabel.text = playlistItems.snippet?.title ?? "--"
        favoriteViewCountTextLabel.text = "\(playlistItems.statistics?.viewCount ?? "--") просмотров"
        
        previewVideoView.clipsToBounds = true
        previewVideoView.layer.cornerRadius = 12
    }
}
