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
    
    
    var title:String = "Tasks"
    var navigationTitle = "Tasks"
    var dateTitle:String?
    
    var tasks:[Task]?
    var days:[Day]?
    
    
    func getTaks(for categoryName:String) -> [Task]{
        if let category = modelLayer.dataLayer.getCategoryByName(name: categoryName){
            navigationTitle = "Tasks"
            dateTitle = ""
            title = "\(categoryName)"
            return modelLayer.dataLayer.getTaskForCategory(category: category)
        }else{
            //ERROR: No category
        }
        return [Task]()
    }
    
    func getFeaturedTasks(for type:FeaturedType){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        switch type {
        case .Today:
            navigationTitle = "Today's Tasks"
            dateTitle = "Today, \(dateFormatter.string(from: Date()))"
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            getCalenderDays(noOFDays: 14, startDate: startDate!)
            selectSpecificDate(date: Date())
        case .Tomorrow:
            navigationTitle = "Tomorrow's Tasks"
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            dateTitle = "Tomorrow, \(dateFormatter.string(from: tomorrow!))"
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: tomorrow!)
            getCalenderDays(noOFDays: 14, startDate: startDate!)
            selectSpecificDate(date: tomorrow!)
        case .Month:
            navigationTitle = "This Month's Tasks"
            dateTitle = "\(dateFormatter.string(from: Date().startOfMonth)) - \(dateFormatter.string(from: Date().endOfMonth))"
        case .Week:
            navigationTitle = "This Week's Tasks"
            dateTitle = "\(dateFormatter.string(from: Date().startOfWeek!)) - \(dateFormatter.string(from: Date().endOfWeek!))"
        case .Favourite:
            navigationTitle = "Favourite Tasks"
        }
        tasks =  modelLayer.dataLayer.getFeaturedTaks(for: type)
    }
    
    func getCalenderDays(noOFDays:Int,startDate:Date){
        self.days = Day.getDays(for: noOFDays, from: startDate)
    }
    
    func selectSpecificDate(date:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString:String = dateFormatter.string(from: date)
        
        for day in self.days!{
            if day.dateString == dateString{
                day.isSelected = true
            }else{
                day.isSelected = false
            }
        }
    }
    
    
    
}
