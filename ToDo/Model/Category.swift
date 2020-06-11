//
//  Category.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class Category:Equatable {
    
    var name:String
    var isSelected:Bool
    
    init(name:String,isSeleted:Bool = false) {
        self.name = name
        self.isSelected = isSeleted
    }
    
    static func getCatrgories()->[Category]{
        var categories = [Category]()
        categories.append(Category(name: "Groceries"))
        categories.append(Category(name: "To do"))
        categories.append(Category(name: "Errands"))
        categories.append(Category(name: "Meetings"))
        categories.append(Category(name: "Reminders"))
        return categories
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name
    }
    
    
}
