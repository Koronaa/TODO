//
//  QueryViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class QueryViewModel{
    
    let modelLayer = ModelLayer()
    
    var tasks:[Task]?
    
    var days:[Day] = Day.getDays(for: 10, from: Date())
    
    
    func getTaks(for categoryName:String) -> [Task]{
        if let category = modelLayer.dataLayer.getCategoryByName(name: categoryName){
            return modelLayer.dataLayer.getTaskForCategory(category: category)
        }else{
            //ERROR: No category
        }
        return [Task]()
    }
    
    func getFeaturedTasks(for type:FeaturedType){
        tasks =  modelLayer.dataLayer.getFeaturedTaks(for: type)
    }
    
   
    
}
