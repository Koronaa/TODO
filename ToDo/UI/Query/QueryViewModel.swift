//
//  QueryViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class QueryViewModel{
    
    var getTasks:[Task]{
        return Task.getTodos()
    }
    
    var days:[Day] = Day.getDays(for: 10, from: Date())
}
