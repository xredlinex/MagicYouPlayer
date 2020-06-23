//
//  AlertErrors.swift
//  MagicYouPlayer
//
//  Created by alexey sorochan on 24.06.2020.
//  Copyright © 2020 alexey sorochan. All rights reserved.
//

import Foundation

class AlertErrors {
    
    enum ErrorText {
        
        case badLink
        case responseError
        case badData
        case cantFindObject
    }
    
    func errorKey(_ error: ErrorText) -> String {
        
        switch error {
        case .badLink:
            return "Bad Request, No Link"
        case .responseError:
            return "Response Error"
        case .badData:
            return "Can't Find Data"
        case .cantFindObject:
            return "Can't Find Data Object"
        }
    }
}
