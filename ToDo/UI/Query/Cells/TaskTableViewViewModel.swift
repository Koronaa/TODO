//
//  TaskTableViewViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class TaskTableViewViewModel{
    
    var task:Task
    
    init(task:Task) {
        self.task = task
    }
    
    var taskName:String{
        return task.name
    }
    
    var dateString:String{
        return task.dateTime.formatted
    }
}
