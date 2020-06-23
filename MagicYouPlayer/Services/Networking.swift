//
//  Networking.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 20.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//
import UIKit
import Alamofire
import Toast_Swift

class NetworkService {
    
    static let apiKey = "&key=AIzaSyATl3fxffUVL8CX4Cw4o7gHTT0HQqF-Cww"
    
    
    static func getRequest(endPoint: String, part: String, type: String, viewController: UIViewController, complition: @escaping (_ object: [Item]) -> ()) {
        
        viewController.view.makeToastActivity(.center)
        let baseApiLink = "https://www.googleapis.com/youtube/v3/"
        let url = baseApiLink + endPoint + part + type + apiKey
        if let urlCorrect = URL(string: url) {
            AF.request(urlCorrect, method: .get, encoding: URLEncoding.default).responseData { (response) in
                if let data = response.data {
                    do {
                        let youtubeObjects = try JSONDecoder().decode(YoutubeVideo.self, from: data)
                        if let items = youtubeObjects.items {
                            complition(items)
                            
                        } else {
            
            
                            UIAlertController.presentAlertController(title: "Network Error", message: "Network Error, Reload APp", viewController: viewController)
                                                    
}
                    } catch {
                        debugPrint(error)
            
                      UIAlertController.presentAlertController(title: "Network Error", message: "Network Error, Reload APp", viewController: viewController)

                    }
                } else {
            
                    UIAlertController.presentAlertController(title: "Network Error", message: "Network Error, Reload APp", viewController: viewController)
            
            

                }
            }
        } else {
            
            
            UIAlertController.presentAlertController(title: "Network Error", message: "Network Error, Reload APp", viewController: viewController)
            

        }
    }
}



//extension UIViewController {
//
//    static func showAlertError() {
//        let alertController = UIAlertController(title: "Error", message: "Some Error", preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in }
//        alertController.addAction(alertAction)
//        present(alertController, animated: true, completion: nil)
//    }
//}
extension UIAlertController {
/// display alert with custom number of buttons
    static func presentAlert(_ title: String?, message: String?, alertButtonTitles: [String], alertButtonStyles: [UIAlertAction.Style], vc: UIViewController, completion: @escaping (Int)->Void) -> Void
{
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertController.Style.alert)

    for title in alertButtonTitles {
        let actionObj = UIAlertAction(title: title,
                                      style: alertButtonStyles[alertButtonTitles.index(of: title)!], handler: { action in
                                        completion(alertButtonTitles.index(of: action.title!)!)
        })
        alert.addAction(actionObj)
    }
    vc.present(alert, animated: true, completion: nil)
}
}




