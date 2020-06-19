//
//  PlaylistModel.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import Foundation


class YoutubeVideo {
    
    var items: [Item]?
    var pageInfo: PageInfo?
}

class PageInfo {
    
    var totalResults: Int?
    var resultsPerPage: Int?
}

class Item {
    
    var id: String?
    var snippet: Snippet?
    var contentDetails: ContentDetails?
    var statistics: Statistics?
}

class Snippet {
    
    var publishedAt: String?
    var channelId: String?
    var title: String?
    var description: String?
    var thumbnails: Thumbnails?
    var channelTitle: String?
}

class Thumbnails {
    
    var thumbDefault, medium, high: ThumbImage?
}

class ThumbImage {
    
    var url: String?
}

class ContentDetails {
    
    var videoId: String?
    var videoPublishedAt: String?
    var relatedPlaylists: RelatedPlaylists?
    
}

class Statistics {
    
    var viewCount: String?
    var likeCount: String?
}


