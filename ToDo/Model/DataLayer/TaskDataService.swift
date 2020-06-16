//
//  TaskDataService.swift
//  ToDo
//
//  Created by Sajith Konara on 6/12/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import CoreData
import RxRelay

class TaskDataService{
    
    private var fetchRequest:NSFetchRequest<Task>{
        return NSFetchRequest<Task>(entityName: Task.entityName)
    }
    
    func getFeaturedTasks(for context:NSManagedObjectContext,for featureType:FeaturedType,isSortingEnabled:Bool,sortType:SortType) -> [Task]{
        
        var calender = Calendar.current
        calender.timeZone = .current
        var dateFrom:Date
        var dateTo:Date
        
        switch featureType {
        case .Today:
            dateFrom = calender.startOfDay(for: Date())
            dateTo = calender.date(byAdding: .day, value: 1, to: dateFrom)!
        case .Tomorrow:
            dateFrom = calender.startOfDay(for: calender.date(byAdding: .day, value: 1, to: Date())!)
            dateTo = calender.date(byAdding: .day, value: 1, to: dateFrom)!
        case .Month:
            dateFrom = calender.startOfDay(for: Date().startOfMonth)
            dateTo = Date().endOfMonth
        case .Week:
            dateFrom = calender.startOfDay(for: Date().startOfWeek!)
            dateTo = Date().endOfWeek!
        case .Favourite:
            return getFavouriteTasks(for: context,isSortingEnabled:isSortingEnabled,sortType:sortType)
        }
        
        let fromPredicate = NSPredicate(format: "dateTime >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "dateTime < %@", dateTo as NSDate)
        let dateCoumpoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        let taskFetchRequest = fetchRequest
        taskFetchRequest.predicate = dateCoumpoundPredicate
        
        if isSortingEnabled{
            switch sortType {
            case .BY_DATE:
                let dateSortDescriptor = NSSortDescriptor(key: #keyPath(Task.dateTime), ascending: true)
                taskFetchRequest.sortDescriptors = [dateSortDescriptor]
            case .BY_NAME:
                let nameSortDescriptor = NSSortDescriptor(key: #keyPath(Task.name), ascending: true)
                taskFetchRequest.sortDescriptors = [nameSortDescriptor]
            }
        }
        
        do{
            let tasks = try context.fetch(taskFetchRequest)
            return tasks
        }catch{
            print(error.localizedDescription)
            return [Task]()
        }
    }
    
    private func getFavouriteTasks(for context:NSManagedObjectContext,isSortingEnabled:Bool,sortType:SortType) -> [Task]{
        let favouritesFetchRequest = fetchRequest
        favouritesFetchRequest.predicate = NSPredicate(format: "isFavourite = %@", NSNumber(value: true))
        
        if isSortingEnabled{
            switch sortType {
            case .BY_DATE:
                let dateSortDescriptor = NSSortDescriptor(key: #keyPath(Task.dateTime), ascending: true)
                favouritesFetchRequest.sortDescriptors = [dateSortDescriptor]
            case .BY_NAME:
                let nameSortDescriptor = NSSortDescriptor(key: #keyPath(Task.name), ascending: true)
                favouritesFetchRequest.sortDescriptors = [nameSortDescriptor]
            }
        }
        
        do{
            let tasks = try context.fetch(favouritesFetchRequest)
            return tasks
        }catch{
            print(error.localizedDescription)
            return [Task]()
        }
    }
    
    func getTasksForDate(date:Date,using context:NSManagedObjectContext,isSortingEnabled:Bool,sortType:SortType) -> [Task]{
        var calender = Calendar.current
        calender.timeZone = .current
        let taskFetchRequest = fetchRequest
        let dateFrom = calender.startOfDay(for: date)
        let dateTo = calender.date(byAdding: .day, value: 1, to: dateFrom)!
        let fromPredicate = NSPredicate(format: "dateTime >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "dateTime < %@", dateTo as NSDate)
        let dateCoumpoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        taskFetchRequest.predicate = dateCoumpoundPredicate
        
        if isSortingEnabled{
            switch sortType {
            case .BY_DATE:
                let dateSortDescriptor = NSSortDescriptor(key: #keyPath(Task.dateTime), ascending: true)
                taskFetchRequest.sortDescriptors = [dateSortDescriptor]
            case .BY_NAME:
                let nameSortDescriptor = NSSortDescriptor(key: #keyPath(Task.name), ascending: true)
                taskFetchRequest.sortDescriptors = [nameSortDescriptor]
            }
        }
        
        do{
            return try context.fetch(taskFetchRequest)
        }catch{
            print(error.localizedDescription)
            return [Task]()
        }
    }
    
    func addTask(taskDTO:TaskDTO,category:Category?,for context:NSManagedObjectContext) -> BehaviorRelay<(Bool,CustomError?)>{
        let newTask = NSEntityDescription.insertNewObject(forEntityName: Task.entityName, into: context) as! Task
        newTask.name = taskDTO.name
        newTask.isFavourite = taskDTO.isFavourite
        newTask.dateTime = taskDTO.dateTime
        newTask.isReminder = taskDTO.isReminder
        newTask.category = category
        do{
            try context.save()
        }catch{
            context.rollback()
            return BehaviorRelay<(Bool,CustomError?)>(value: (false,CustomError(title: nil, message: error.localizedDescription)))
        }
        return BehaviorRelay<(Bool,CustomError?)>(value: (true,nil))
    }
    
    func getTasks(for category:Category?,using context:NSManagedObjectContext,isSortingEnabled:Bool,sortType:SortType)->[Task]{
        let taskFetchRequest = fetchRequest
        
        if isSortingEnabled{
            switch sortType {
            case .BY_DATE:
                let dateSortDescriptor = NSSortDescriptor(key: #keyPath(Task.dateTime), ascending: true)
                taskFetchRequest.sortDescriptors = [dateSortDescriptor]
            case .BY_NAME:
                let nameSortDescriptor = NSSortDescriptor(key: #keyPath(Task.name), ascending: true)
                taskFetchRequest.sortDescriptors = [nameSortDescriptor]
            }
        }
        
        do{
            let tasks = try context.fetch(taskFetchRequest)
            if category != nil{
                let filteredTasks = tasks.filter {$0.category?.name == category?.name}
                return filteredTasks
            }else{
                let filteredTasks = tasks.filter {$0.category == nil}
                return filteredTasks
            }
        }catch{
            print(error.localizedDescription)
            return [Task]()
        }
    }
    
    func getAllTasks(using context:NSManagedObjectContext)->[Task]{
        
        let taskRequest = fetchRequest
        do{
            return try context.fetch(taskRequest)
        }catch{
            print(error.localizedDescription)
            return [Task]()
        }
    }
    
    func deleteTask(task:Task,using context:NSManagedObjectContext) -> BehaviorRelay<(Bool,CustomError?)>{
        let deleteFetchRquest = fetchRequest
        deleteFetchRquest.predicate = NSPredicate(format: "name = %@ AND dateTime = %@", task.name,task.dateTime as CVarArg)
        
        do{
            if let task = try context.fetch(deleteFetchRquest).first{
                context.delete(task)
                try context.save()
            }
        }catch{
            context.rollback()
            return BehaviorRelay<(Bool,CustomError?)>(value: (false,CustomError(title: nil, message: error.localizedDescription)))
        }
        return BehaviorRelay<(Bool,CustomError?)>(value: (true,nil))
    }
    
    func updateTask(task:Task,updatedCategory:Category?,updatedTask:TaskDTO,using context:NSManagedObjectContext) -> BehaviorRelay<(Bool,CustomError?)>{
        let updateFetchRequest = fetchRequest
        updateFetchRequest.predicate = NSPredicate(format: "name = %@ AND dateTime = %@", task.name,task.dateTime as CVarArg)
        
        do{
            if let task = try context.fetch(updateFetchRequest).first{
                task.name = updatedTask.name
                task.isFavourite = updatedTask.isFavourite
                task.dateTime = updatedTask.dateTime
                task.isReminder = updatedTask.isReminder
                task.category = updatedCategory
                try context.save()
            }
        }catch{
            context.rollback()
            return BehaviorRelay<(Bool,CustomError?)>(value: (false,CustomError(title: nil, message: error.localizedDescription)))
        }
        return BehaviorRelay<(Bool,CustomError?)>(value: (true,nil))
    }
    
}
