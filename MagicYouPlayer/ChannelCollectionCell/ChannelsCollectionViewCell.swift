//
//  ChannelsCollectionViewCell.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 20.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit
import Kingfisher

class ChannelsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var channalVideoThumbnailImageView: UIImageView!
    @IBOutlet weak var channelTitleTextLabel: UILabel!
    @IBOutlet weak var channelSubscribersCountTextLabel: UILabel!
    @IBOutlet weak var playButtonView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        channalVideoThumbnailImageView.image = nil
        
    }
    
    func updateChanneCell(channel: Item, channelVideo: Item) {
        
        channelTitleTextLabel.text = channel.snippet?.title
        channelSubscribersCountTextLabel.text = "\(channel.statistics?.subscriberCount ?? "--") просмотрa"
        
        if let urlString = channelVideo.snippet?.thumbnails?.high?.url {
            let url = URL(string: urlString)
            channalVideoThumbnailImageView.kf.setImage(with: url)
        }
    }
}

extension ChannelsCollectionViewCell {
    
    func setupUI() {
        
        playButtonView.clipsToBounds = true
        playButtonView.layer.cornerRadius = playButtonView.frame.width / 2
        channelSubscribersCountTextLabel.textColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        
        let colorOne = UIColor(red: 244/255, green: 94/255, blue: 154/255, alpha: 1).cgColor
//        let colorOne = UIColor(red: 241/255, green: 93/255, blue: 11575/255, alpha: 1).cgColor
               let colorTwo = UIColor(red: 122/255, green: 54/255, blue: 246/255, alpha: 1).cgColor
               playButtonView.setupGradient([colorTwo, colorOne])
        
        
    }
}
