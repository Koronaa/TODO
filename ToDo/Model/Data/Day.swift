//
//  Day.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class Day:Equatable {
    
    var year:String
    var name:String
    var date:String
    var dateString:String
    var isSelected:Bool
    
    init(name: String, date: String,year:String,dateString:String, isSelected: Bool) {
        self.name = name
        self.date = date
        self.year = year
        self.dateString = dateString
        self.isSelected = isSelected
    }
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.dateString == rhs.dateString
    }
    
    
    static func getDays(for noOfDays:Int,from date:Date)->[Day]{
        var days:[Day] = []
        var name:String = ""
        var dayString:String = ""
        var year:String = ""
        var dateString:String = ""
        let dateFormatter = DateFormatter()
        let calender = Calendar.current
        var startingDate = calender.startOfDay(for: date)
        
        for _ in 1...noOfDays{
            dateFormatter.dateFormat = "yyyy"
            year = dateFormatter.string(from: startingDate)
            dateFormatter.dateFormat = "E"
            name = dateFormatter.string(from: startingDate)
            dateFormatter.dateFormat = "d"
            dayString = dateFormatter.string(from: startingDate)
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateString = dateFormatter.string(from: startingDate)
            days.append(Day(name: name, date: dayString, year: year,dateString: dateString, isSelected: false))
            startingDate = calender.date(byAdding: .day, value: 1, to: startingDate)!
        }
        return days
    }
}

