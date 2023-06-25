//
//  DateFormatHandler.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 26/06/2023.
//

import Foundation

class DateFormatHandler {
    
    static var defaultHandler = DateFormatHandler()
    
    func displayDateString(fromString dateString: String, toFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateValue = dateFormatter.date(from: dateString)
        guard let dateValue = dateValue else {return dateString}
        
        dateFormatter.dateFormat = format
        let displayDateString = dateFormatter.string(from: dateValue)
        return displayDateString
        
    }
}
