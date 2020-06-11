//
//  Task.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
struct Task {
    var name:String
    var dateTime:Date
    var category:Category
    var isFavourite:Bool
    
    
    static func getTodos() -> [Task]{
        var tasks:[Task] = []
        tasks.append(Task(name: "Call Sajith", dateTime: Date(), category:Category(name: "TODO"), isFavourite: true))
        tasks.append(Task(name: "Go Shopping", dateTime: Date(), category:Category(name: "TODO"), isFavourite: false))
        tasks.append(Task(name: "Fix Bugs", dateTime: Date(), category:Category(name: "TODO"), isFavourite: false))
        tasks.append(Task(name: "KMN", dateTime: Date(), category:Category(name: "TODO"), isFavourite: false))
        return tasks
    }
    
    static func getGroceries() -> [Task]{
        var tasks:[Task] = []
        tasks.append(Task(name: "Buy Milk", dateTime: Date(), category:Category(name: "Groceries"), isFavourite: true))
        tasks.append(Task(name: "Milo", dateTime: Date(), category:Category(name: "Groceries"), isFavourite: false))
        tasks.append(Task(name: "Vegitables", dateTime: Date(), category:Category(name: "Groceries"), isFavourite: false))
        return tasks
    }
    
    
}
