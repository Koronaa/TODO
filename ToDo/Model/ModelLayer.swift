//
//  ModelLayer.swift
//  ToDo
//
//  Created by Sajith Konara on 6/13/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class ModelLayer{
    
    let dataLayer = DataLayer()
    
    func getTasksForToday() -> [Task]{
        return dataLayer.getFeaturedTaks(for: .Today)
    }
    
    func getCategories() -> [Category]{
        dataLayer.getAllCategories()
    }
    
    func getCategoryDetails() -> [CategoryInfo]{
        dataLayer.getCategoryInfo() 
    }
    
}
