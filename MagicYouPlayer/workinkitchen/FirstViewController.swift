////
////  FirstViewController.swift
////  MagicYouPlayer
////
////  Created by alexey sorochan on 20.06.2020.
////  Copyright © 2020 alexey sorochan. All rights reserved.
////
//
//import UIKit
//import YoutubeDirectLinkExtractor
//
//class FirstViewController: UIViewController {
//
//    var link: URL?
//    var path = "https://www.youtube.com/watch?v="
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        getulrLink(string: path + "A9VAS4tPtFU")
//
//
//        // Do any additional setup after loading the view.
//    }
//
//
//
//    @IBAction func button(_ sender: Any) {
//
//        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        if let url = link {
//            viewController.getURL = url
//                   navigationController?.pushViewController(viewController, animated: true)
//        }
//
//
//        
//
//
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//
//
//    func getulrLink(string: String) {
//
//        let y = YoutubeDirectLinkExtractor()
//                y.extractInfo(for: .urlString(string), success: { info in
//                    DispatchQueue.main.async {
//
//                        if let videoLink = info.highestQualityPlayableLink {
//                            if let url = URL(string: videoLink) {
//
//                                self.link = url
//
//        //                        self.playVideo(url: url)
//
//                            }
//                        }
//                    }
//
//
//        //            print(info.highestQualityPlayableLink)
//                }) { error in
//                    print(error)
//                }
//
//
//
//    }
//}
