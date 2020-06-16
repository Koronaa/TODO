//
//  HomeViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class HomeViewModel{
    
    let modelLayer = ModelLayer()
    let bag = DisposeBag()
    
    var title:String!
    var featuredItems:[Featured]!
    var categoryInfo:BehaviorRelay<[CategoryInfo]> = BehaviorRelay<[CategoryInfo]>(value: [])
    var todysTaskCount:Int!
    
    
    func getFeaturedItems(){
        Featured.getFeatures().asObservable().subscribe(onNext: { items in
            self.featuredItems = items
        }).disposed(by: bag)
    }
    
    func getcategoryInfo(){
        modelLayer.getCategoryDetails().asObservable().subscribe(onNext: { categoryInformation in
            self.categoryInfo.accept(categoryInformation)
        }).disposed(by: bag)
    }
    
    
    func getTodysTaskCount(){
        modelLayer.getTasksForToday().asObservable().subscribe(onNext: { tasks in
            self.todysTaskCount = tasks.count
        }).disposed(by: bag)
    }
    
    func loadData(){
        if todysTaskCount == 0{
            title = "Hey, You've got no tasks today."
        }else if todysTaskCount == 1{
            title = "Hey, You've got \(todysTaskCount.description) task today."
        }else{
            title = "Hey, You've got \(todysTaskCount.description) tasks today."
        }
    }
}
