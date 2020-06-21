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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        debugPrint("player open")
    }
    // MARK: - View Life Cycle
     override func awakeFromNib() {
       super.awakeFromNib()

//       modalPresentationCapturesStatusBarAppearance = true //allow this VC to control the status bar appearance
       modalPresentationStyle = .overFullScreen //dont dismiss the presenting view controller when presented
     }
    
    
    @IBAction func didTapDismissActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MediaPlayerViewController {
    
    func setupUI() {
        
        
        playerCloseImageView.image = UIImage(named: "Close_Open")
    }
}
