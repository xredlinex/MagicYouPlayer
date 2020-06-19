//
//  ViewController.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 19.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var channel: [Item]?
    var playlist: [Item]?
    
    
    let channelOneId = "&id=UCVHOgH4XEyYx-ZEaya1XqCQ"
    let secondChannelId = "&id=UCPu3YP9Qgl46UdFrGvyguNw"
    let thirdChannelId = ""
    let fourthChannelId = ""
    
     let channelPart = "part=contentDetails%2Csnippet%2Cstatistics"
      let playlistPart = "part=snippet%2CcontentDetails&maxResults=10&playlistId="
      let videoPart = "part=contentDetails%2Csnippet%2Cstatistics"
    
     let channelsLink = "channels?"
     let playlistLink = "playlistItems?"
     let videoLink = "videos?"

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let chchch = channelOneId + secondChannelId
        
        getChannals(channalsId: chchch)
        
//        NetworkService.getRequest(endPoint: channelsLink, part: channelPart, type: channelId) { (item) in
//            self.channel = item
//
//            DispatchQueue.main.async {
//                if let cha = self.channel {
//                    for i in cha {
//                        debugPrint(i.snippet?.title)
//                        if let playListId = i.contentDetails?.relatedPlaylists?.uploads {
//                            self.getPlaylist(playlistId: playListId)
//                        }
//
//                    }
//                }
//            }
//        }
        
    }
    
    func getChannals(channalsId: String) {
        
        
        
        NetworkService.getRequest(endPoint: channelsLink, part: channelPart, type: channalsId) { (item) in
                   self.channel = item
                   
                   DispatchQueue.main.async {
                       if let cha = self.channel {
                           for i in cha {
                               debugPrint(i.snippet?.title)
                               if let playListId = i.contentDetails?.relatedPlaylists?.uploads {
                                   self.getPlaylist(playlistId: playListId)
                               }
                               
                           }
                       }
                   }
               }
        
    }
    
    
    
    func getPlaylist(playlistId: String) {
        
        NetworkService.getRequest(endPoint: playlistLink, part: playlistPart, type: playlistId) { (item) in
            self.playlist = item
            DispatchQueue.main.async {
                if let list = self.playlist {
                    for i in list {
                        debugPrint(i.snippet?.title)
                    }
                }
            }
            
        }
        
        
    }

}
