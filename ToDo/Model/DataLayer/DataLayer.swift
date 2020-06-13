//
//  DataLayer.swift
//  ToDo
//
//  Created by Sajith Konara on 6/12/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import CoreData

class DataLayer{
    
    var context:NSManagedObjectContext!
    var taskDataService = TaskDataService()
    var categoryDataService = CategoryDataService()
    
    init() {
        createMainContext { container in
            self.context = container.viewContext
        }
    }
    
    //MARK: Task
    
    func getTasksForToday() -> [Task]{
        return taskDataService.getFeaturedTasks(for: context, for: .Today)
    }
    
    func getTasksForTomorrow() -> [Task]{
        return taskDataService.getFeaturedTasks(for: context, for: .Tomorrow)
    }
    
    func getTasksForThisWeek() -> [Task]{
        return taskDataService.getFeaturedTasks(for: context, for: .Week)
    }
    
    func getTasksForThisMonth() -> [Task]{
        return taskDataService.getFeaturedTasks(for: context, for: .Month)
    }
    
    func getFavourites()->[Task]{
        return taskDataService.getFavouriteTasks(for: context)
    }
    
    func addTask(for taskDTO:TaskDTO,category:Category){
        taskDataService.addTask(taskDTO: taskDTO, category: category, for: context)
    }
    
    //MARK: Category
    
    
    func getAllCategories() -> [Category]{
        return categoryDataService.getAllCategories(for: context)
    }
    
    
    
    
}
