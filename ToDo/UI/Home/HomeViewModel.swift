//
//  HomeViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class HomeViewModel{
    
    let modelLayer = ModelLayer()
    
    var featuredItems:[Featured] {
        return Featured.getFeatures()
    }
    
    var categoryInfo:[CategoryInfo] {
        return modelLayer.getCategoryDetails()
    }
    
    var todysTaskCount:Int{
        return modelLayer.getTasksForToday().count
    }
    
    
}
