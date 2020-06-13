//
//  DataLayer.swift
//  ToDo
//
//  Created by Sajith Konara on 6/12/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//


import UIKit
import CoreData

class DataLayer{
    
    let taskDataService = TaskDataService()
    let categoryDataService = CategoryDataService()
    
    var context:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //MARK: Task
    
    func getFeaturedTaks(for type:FeaturedType) -> [Task]{
        return taskDataService.getFeaturedTasks(for: context, for: type)
    }
    
    func addTask(for taskDTO:TaskDTO,category:Category?){
         taskDataService.addTask(taskDTO: taskDTO, category: category, for: context)
    }
    
    func getTaskForCategory(category:Category) -> [Task]{
        return taskDataService.getTasks(for: category, using: context)
    }
    
    //MARK: Category
    
    func getAllCategories() -> [Category]{
        return categoryDataService.getAllCategories(for: context)
    }
    
    func getCategoryInfo() -> [CategoryInfo] {
        var categoryInfo = [CategoryInfo]()
        for category in getAllCategories(){
            let taskCount = getTaskForCategory(category: category).count
            categoryInfo.append(CategoryInfo(name: category.name, taskCount: taskCount))
        }
        return categoryInfo
    }
    
    func addCategory(name:String){
        categoryDataService.addCategory(name: name, for: context)
    }
    
    func getCategoryByName(name:String) -> Category?{
        return categoryDataService.getCategory(for: name, context: context)
    }
    
    
    
    
}
