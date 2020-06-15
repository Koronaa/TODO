//
//  QueryViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum SortType{
    case BY_NAME
    case BY_DATE
}

class QueryViewModel{
    
    let modelLayer = ModelLayer()
    let bag = DisposeBag()
    
    var title:String = "Tasks"
    var navigationTitle = "Tasks"
    var dateTitle:String?
    
    var tasks:BehaviorRelay<[Task]> = BehaviorRelay<[Task]>(value: [])
    var days:BehaviorRelay<[Day]> = BehaviorRelay<[Day]>(value: [])
    
    
    func getTaks(for categoryName:String?,isSortingEnabled:Bool = false,sortType:SortType = .BY_NAME){
        if let name = categoryName{
            if let category = modelLayer.dataLayer.getCategoryByName(name: name){
                navigationTitle = "Tasks"
                dateTitle = ""
                title = "\(name)"
                modelLayer.getTasksForCategory(category: category,isSortingEnabled:isSortingEnabled,sortType:sortType).asObservable()
                    .subscribe(onNext: { tasks in
                        self.tasks.accept(tasks)
                    }).disposed(by: bag)
            }
        }else{
            navigationTitle = "Tasks"
            dateTitle = ""
            title = "Uncategorized"
            modelLayer.getTasksForCategory(category: nil,isSortingEnabled:isSortingEnabled,sortType:sortType).asObservable()
                .subscribe(onNext: { tasks in
                    self.tasks.accept(tasks)
                }).disposed(by: bag)
        }
    }
    
    func getFeaturedTasks(for type:FeaturedType,isSortingEnabled:Bool = false,sortType:SortType = .BY_NAME){
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
        
        modelLayer.getFeaturedTaks(for: type,isSortingEnabled:isSortingEnabled,sortType:sortType).asObservable()
            .subscribe(onNext: { tasks in
                self.tasks.accept(tasks)
            }).disposed(by: bag)
    }
    
    func getTasksForSpecificDate(dateString:String,isSortingEnabled:Bool = false,sortType:SortType = .BY_NAME){
        let date = getSelectedDate(from: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        navigationTitle = "Tasks"
        dateTitle = "\(dateFormatter.string(from: date))"
        modelLayer.getTasksForDate(date: date,isSortingEnabled:isSortingEnabled,sortType:sortType).asObservable()
            .subscribe(onNext: { tasks in
                self.tasks.accept(tasks)
            }).disposed(by: bag)
        
    }
    
    func getCalenderDays(noOFDays:Int,startDate:Date){
        modelLayer.getCalenderDays(noOFDays: noOFDays, startDate: startDate).asObservable()
            .subscribe(onNext: { days in
                self.days.accept(days)
            }).disposed(by: bag)
        
    }
    
    func selectSpecificDate(date:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString:String = dateFormatter.string(from: date)
        
        for day in self.days.value{
            if day.dateString == dateString{
                day.isSelected = true
            }else{
                day.isSelected = false
            }
        }
    }
    
    private func getSelectedDate(from dateString:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: dateString)!
    }
}
