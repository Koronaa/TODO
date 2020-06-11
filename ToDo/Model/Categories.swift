//
//  Categories.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
struct Categories {
    var categoryName:String
    var count:Int
    
    static func getCategories() -> [Categories]{
        var categories:[Categories] = []
        categories.append(Categories(categoryName: (Task.getGroceries().first?.category.name)!, count: Task.getGroceries().count))
        categories.append(Categories(categoryName: (Task.getTodos().first?.category.name)!, count: Task.getTodos().count))
        return categories
    }
}
