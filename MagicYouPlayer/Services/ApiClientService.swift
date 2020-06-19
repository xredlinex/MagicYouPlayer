//
//  ApiClientService.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import Alamofire

class NetworkService {
    
    
    static let link = "https://www.googleapis.com/youtube/v3/"
    static let channelsLink = "channels?"
    static let playlistLink = "playlistItems?"
    static let videoLink = "videos?"
    
     static let apiKey = "&key=AIzaSyAk5mcnqXErmDkUIGiNd6LetKAJLL5a3Cc"

    static let channelOneId = "&id=UCVHOgH4XEyYx-ZEaya1XqCQ"
    static let channelTwoId = ""
    static let channelTreeId = ""
    static let channelFourh = ""
        
    static let videoId = String()
    static let playlistId = String()
    static let channelId = String()
    
    static let channelPart = "part=contentDetails%2Csnippet%2Cstatistics"
    static let playlistPart = "part=snipped%2CcontentDetails"
    static let videoPart = "part=contentDetails%2Csnippet%2Cstatistics"

    
    static func getRequest(endPoint: String, part: String, type: String, complition: @escaping (_ channel: [Item]) -> ()) {
          
          let baseLink = "https://www.googleapis.com/youtube/v3/"
        
        let sborka = baseLink + endPoint + part + type + apiKey
      
          if let url = URL(string: sborka) {
            debugPrint(url)
              AF.request(url, method: .get, encoding: URLEncoding.default).responseData { (response) in
                  if let data = response.data {
                      do {
                          let youtubeChannel = try JSONDecoder().decode(YoutubeVideo.self, from: data)
                          if let channel = youtubeChannel.items {
                              complition(channel)
                          } else {
                              debugPrint("no chanal")
                          }
                      } catch {
                          debugPrint(error)
                      }
                  } else {
                      debugPrint("no data")
                  }
              }
          }
      }
    
    
    
    static func getChannel(complition: @escaping (_ channel: [Item]) -> ()) {
        
        debugPrint("start ll")
    
        if let url = URL(string: link + channelsLink + channelPart + channelOneId + "&key=" + apiKey) {
            debugPrint(url)
            AF.request(url, method: .get, encoding: URLEncoding.default).responseData { (response) in
                debugPrint(response)
                if let data = response.data {
                    debugPrint(data)
                    do {
                        let youtubeChannel = try JSONDecoder().decode(YoutubeVideo.self, from: data)
                        debugPrint(youtubeChannel.items)
                        
                        debugPrint(youtubeChannel.pageInfo)
                        if let channel = youtubeChannel.items {
                            complition(channel)
                        } else {
                            debugPrint("no chanal")
                        }
                    } catch {
                        debugPrint(error)
                    }
                } else {
                    debugPrint("no data")
                }
            }
        }
    }
    
  
    
    
}
