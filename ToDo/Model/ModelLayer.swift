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
    let tranlationLater = TranslationLayer()
    
    func getTasksForToday() -> [Task]{
        return dataLayer.getFeaturedTaks(for: .Today)
    }
    
    func getCategories() -> [CategoryDTO]{
        return tranlationLater.convetToCategoryDTO(categories: dataLayer.getAllCategories())
    }
    
    func getCategoryDetails() -> [CategoryInfo]{
        dataLayer.getCategoryInfo() 
    }
    
    func addTask(for taskDTO:TaskDTO,categoryDTO:CategoryDTO?){
        let category = dataLayer.getCategoryByName(name: categoryDTO!.name)
        dataLayer.addTask(for: taskDTO, category: category)
    }
    
}
