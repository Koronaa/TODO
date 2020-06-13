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
        return dataLayer.getTasksForToday()
    }
    
    func addTask(taskDTO:TaskDTO,category:Category){
        dataLayer.addTask(for: taskDTO, category: category)
    }
    
    func getCategories() -> [Category]{
        dataLayer.getAllCategories()
    }
    
    
    
}
