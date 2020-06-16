//
//  CalenderCollectionViewViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class CalenderCollectionViewViewModel{
    
    var day:Day
    
    init(day:Day) {
        self.day = day
    }
    
    var name:String{
        return day.name
    }
    
    var dateString:String{
        return day.date
    }
    
    var isSelected:Bool{
        return day.isSelected
    }
    
    
}
