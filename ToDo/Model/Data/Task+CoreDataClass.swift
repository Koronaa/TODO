//
//  Task.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import CoreData

protocol Entitiable {
    static var entityName:String {get}
}

class Task:NSManagedObject,Entitiable{
    
    @NSManaged var name:String
    @NSManaged var isFavourite:Bool
    @NSManaged var dateTime:Date
    @NSManaged var category:Category?
    
    static var entityName: String {return "Task"}
}

