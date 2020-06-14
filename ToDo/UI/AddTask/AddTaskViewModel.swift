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
    
    var selectedDate:Date?
    var selectedCategory:CategoryDTO?
    var categories:[CategoryDTO]?
    var isFavourite:Bool = false
    var isReminder:Bool = false
    
    func addTask(taskName:String,isFavourite:Bool,dateTime:Date){
        let taskDTO = TaskDTO(name: taskName, isFavourite: isFavourite, isReminder: isReminder, dateTime: dateTime)
        modelLayer.addTask(for: taskDTO, categoryDTO: selectedCategory)
    }
    
    func getCategories(){
        self.categories = modelLayer.getCategories()
    }
}
