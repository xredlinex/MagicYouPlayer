//
//  MediaPlayerViewController.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 20.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

class MediaPlayerViewController: UIViewController {
    
    
    @IBOutlet weak var playerCloseImageView: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    
    var videoId: String?
    var playlist: [Item] = []
    var currentPositionInPlaylist: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        debugPrint(videoId)
        debugPrint(currentPositionInPlaylist)
    }
    
     override func awakeFromNib() {
       super.awakeFromNib()

       modalPresentationStyle = .overFullScreen
     }
    
    
    @IBAction func didTapDismissActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}

extension MediaPlayerViewController {
    
    func setupUI() {
        
        playerCloseImageView.image = UIImage(named: "Close_Open")
    }
}
