//
//  ContentModel.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import Foundation

class YoutubeVideo: Codable {
    
    var items: [Item]?
    var pageInfo: PageInfo?
    
    enum CodingKeys: String, CodingKey {
        case items, pageInfo
    }
}

class PageInfo: Codable {
    
    var totalResults: Int?
    var resultsPerPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalResults, resultsPerPage
    }
}

class Item: Codable {
    
    var id: String?
    var snippet: Snippet?
    var contentDetails: ContentDetails?
    var statistics: Statistics?
    
    enum CodingKeys: String, CodingKey {
        case id, snippet, contentDetails, statistics
    }
}

class Snippet: Codable {
    
    var publishedAt: String?
    var channelId: String?
    var title: String?
    var description: String?
    var thumbnails: Thumbnails?
    var channelTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case publishedAt, channelId, title, description, thumbnails, channelTitle
    }
}

class Thumbnails: Codable {
    
    var thumbDefault, medium, high: ThumbImage?
    
    enum CodingKeys: String, CodingKey {
        case thumbDefault = "default"
        case medium, high
    }
}

class ThumbImage: Codable {
    
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}

class ContentDetails: Codable {
    
    var videoId: String?
    var videoPublishedAt: String?
    var relatedPlaylists: RelatedPlaylists?
    
    enum CodingKeys: String, CodingKey {
        case videoId, videoPublishedAt, relatedPlaylists
    }
}

class Statistics: Codable {
    
    var viewCount: String?
    var likeCount: String?
    var subscriberCount: String?
    
    enum CodingKeys: String, CodingKey {
        case viewCount, likeCount, subscriberCount
    }
}
