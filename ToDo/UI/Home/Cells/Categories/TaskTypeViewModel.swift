//
//  TaskTypeViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/13/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class TaskTypeViewModel{
    
    var categoryInfo:CategoryInfo
    
    init(categoryInfo:CategoryInfo) {
        self.categoryInfo = categoryInfo
    }
    
    var name:String {
        categoryInfo.name ?? "Uncategorized"
    }
    
    var count:Int{
        categoryInfo.taskCount
    }
    
}

