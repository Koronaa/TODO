//
//  AddTaskViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class AddTaskViewModel{
    
    let modelLayer = ModelLayer()
    
    var categories:[Category] {
        return modelLayer.getCategories()
    }
    
    var selectedCategory:Category!
    
    func addTask(taskName:String,isFavourite:Bool,dateTime:Date,cate:String){
        let taskDTO = TaskDTO(name: taskName, isFavourite: isFavourite, dateTime: dateTime)
        modelLayer.addTask(taskDTO: taskDTO,category: selectedCategory)
    }
    
    
    
}
