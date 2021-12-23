//
//  File.swift
//  
//
//  Created by Arthur Givigir on 12/07/21.
//

import Foundation

public extension Date {
    func yesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
