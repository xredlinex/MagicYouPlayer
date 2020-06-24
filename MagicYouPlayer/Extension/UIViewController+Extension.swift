//
//  UIViewController+Extension.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 23.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func presentAlertController(title: String, message: String, viewController: UIViewController) {
        
        viewController.view.hideToastActivity()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
