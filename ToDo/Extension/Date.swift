//
//  Date.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

extension Date{
    
    var month:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var weakNumber:String{
        let calender = Calendar.current
        return calender.component(.weekOfYear, from: self).description
    }
    
    var today:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
    
    var tomorrow:String{
        let calender = Calendar.current
        let tomorrow = calender.date(byAdding: .day, value: 1, to: self)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: tomorrow)
    }
    
    
    
}
