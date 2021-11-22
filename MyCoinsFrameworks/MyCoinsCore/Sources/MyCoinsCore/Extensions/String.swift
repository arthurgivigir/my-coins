//
//  File.swift
//  
//
//  Created by Arthur Givigir on 12/07/21.
//

import Foundation

public extension String {
    
    func formattedDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        let date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        dateFormatter.locale = Locale(identifier: "pt-BR")
        
        return dateFormatter.string(from: date)
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from: self)
    }
}
