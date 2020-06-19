//
//  ChannelModel.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

class YouTubeChannel: Codable {
    
    var items: [Item]?
    var kind: String?
    var etag: String?
    
    enum CodingKeys: String, CodingKey {
        case items, kind, etag
    }
}

class YoutubePlayList: Codable {
    
    var items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

class RelatedPlaylists: Codable {
    
    var uploads: String?
    
    enum CodingKeys: String, CodingKey {
        case uploads
    }
}
