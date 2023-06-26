//
//  CustomError.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import Foundation


enum CustomError: Error {
    case generalError
    case imageDownloadError
    case moreInfoDownloadError
}

extension CustomError {
    func message() -> String{
        switch self {
        case .generalError:
            return "A general error occured while performing the request"
        case .imageDownloadError:
            return "An error occured while downloading image"
        case .moreInfoDownloadError:
            return "An error occured while downloading info"
        }
    }
}
