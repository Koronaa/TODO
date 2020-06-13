//
//  Category.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import CoreData


enum CategoryType:String{
    case Uncategorized = "Uncategorized"
}

class Category:NSManagedObject,Entitiable{
    
    @NSManaged var name:String
    @NSManaged var isSelected:Bool
    @NSManaged var tasks:NSSet?
    
    static var entityName: String {return "Category" }
    
    
    static func getCatrgories()->[Category]{
        return [Category]()
    }
}

