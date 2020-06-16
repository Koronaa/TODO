//
//  ModelLayer.swift
//  ToDo
//
//  Created by Sajith Konara on 6/13/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import RxRelay

class ModelLayer{
    
    let dataLayer = DataLayer()
    let tranlationLater = TranslationLayer()
    let taskReminderManager = TaskReminderManager()
    
    
    func getTasksForToday() -> BehaviorRelay<[Task]>{
        return BehaviorRelay<[Task]>(value:dataLayer.getFeaturedTaks(for: .Today,isSortingEnabled:false,sortType:.BY_NAME))
    }
    
    func getCategories() -> BehaviorRelay<[Category]>{
        return BehaviorRelay<[Category]>(value: dataLayer.getAllCategories())
    }
    
    func getTranslatedCategories() -> BehaviorRelay<[CategoryDTO]>{
        return BehaviorRelay<[CategoryDTO]>(value: tranlationLater.convetToCategoryDTO(categories: dataLayer.getAllCategories()))
    }
    
    func getCategoryDetails() -> BehaviorRelay<[CategoryInfo]>{
        return BehaviorRelay<[CategoryInfo]>(value: dataLayer.getCategoryInfo())
    }
    
    func addTask(for taskDTO:TaskDTO,categoryDTO:CategoryDTO?) -> BehaviorRelay<(Bool,CustomError?)>{
        let category = dataLayer.getCategoryByName(name: categoryDTO?.name)
        return dataLayer.addTask(for: taskDTO, category: category)
    }
    
    func deleteCategory(category:Category) -> BehaviorRelay<(Bool,CustomError?)>{
        return dataLayer.deleteCategory(category: category)
    }
    
    func addCategory(name:String) -> BehaviorRelay<(Bool,CustomError?)>{
        return dataLayer.addCategory(name: name)
    }
    
    func getTasksForCategory(category:Category?,isSortingEnabled:Bool,sortType:SortType) -> BehaviorRelay<[Task]>{
        return BehaviorRelay<[Task]>(value: dataLayer.getTasksForCategory(category: category, isSortingEnabled: isSortingEnabled, sortType: sortType))
    }
    
    func getFeaturedTaks(for type:FeaturedType,isSortingEnabled:Bool,sortType:SortType) -> BehaviorRelay<[Task]>{
        return BehaviorRelay<[Task]>(value:dataLayer.getFeaturedTaks(for: type, isSortingEnabled: isSortingEnabled, sortType: sortType))
    }
    
    func getTasksForDate(date:Date,isSortingEnabled:Bool,sortType:SortType) -> BehaviorRelay<[Task]>{
        return BehaviorRelay<[Task]>(value: dataLayer.getTasksForDate(date: date, isSortingEnabled: isSortingEnabled, sortType: sortType))
    }
    
    func getCalenderDays(noOFDays:Int,startDate:Date) -> BehaviorRelay<[Day]>{
        return BehaviorRelay<[Day]>(value: Day.getDays(for: noOFDays, from: startDate))
    }
}
