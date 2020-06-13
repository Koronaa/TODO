//
//  TaskDataService.swift
//  ToDo
//
//  Created by Sajith Konara on 6/12/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import CoreData



class TaskDataService{
    
    private var fetchRequest:NSFetchRequest<Task>{
        return NSFetchRequest<Task>(entityName: Task.entityName)
    }
    
    func getFeaturedTasks(for context:NSManagedObjectContext,for featureType:FeaturedType) -> [Task]{
        
        var calender = Calendar.current
        calender.timeZone = .current
        var dateFrom:Date
        var dateTo:Date
        
        switch featureType {
        case .Today:
            dateFrom = calender.startOfDay(for: Date())
            dateTo = calender.date(byAdding: .day, value: 1, to: dateFrom)!
        case .Tomorrow:
            dateFrom = calender.date(byAdding: .day, value: 1, to: Date())!
            dateTo = calender.date(byAdding: .day, value: 1, to: dateFrom)!
        case .Month:
            dateFrom = Date().startOfMonth
            dateTo = Date().endOfMonth
        case .Week:
            dateFrom = Date().startOfWeek!
            dateTo = Date().endOfWeek!
        case .Favourite:
            return getFavouriteTasks(for: context)
        }
        
        let fromPredicate = NSPredicate(format: "dateTime >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "dateTime < %@", dateTo as! NSDate)
        let dateCoumpoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        let taskFetchRequest = fetchRequest
        taskFetchRequest.predicate = dateCoumpoundPredicate
        
        do{
            let tasks = try context.fetch(taskFetchRequest)
            return tasks
        }catch{
            print(error.localizedDescription)
            return [Task]()
        }
    }
    
    private func getFavouriteTasks(for context:NSManagedObjectContext) -> [Task]{
        let favouritesFetchRequest = fetchRequest
        favouritesFetchRequest.predicate = NSPredicate(format: "isFavourite = %@", NSNumber(value: true))
        do{
            let tasks = try context.fetch(favouritesFetchRequest)
            return tasks
        }catch{
            print(error.localizedDescription)
            return [Task]()
        }
    }
    
    func addTask(taskDTO:TaskDTO,category:Category?,for context:NSManagedObjectContext){
        let newTask = NSEntityDescription.insertNewObject(forEntityName: Task.entityName, into: context) as! Task
        newTask.name = taskDTO.name
        newTask.isFavourite = taskDTO.isFavourite
        newTask.dateTime = taskDTO.dateTime
        newTask.category = category
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
            context.rollback()
        }
    }
    
    func getTasks(for category:Category,using context:NSManagedObjectContext)->[Task]{
        let taskFetchRequest = fetchRequest
        fetchRequest.predicate = NSPredicate(format: "category.name = %@", category.name)
        do{
            let tasks = try context.fetch(taskFetchRequest)
            return tasks
        }catch{
            print(error.localizedDescription)
            return [Task]()
        }
    }
}
