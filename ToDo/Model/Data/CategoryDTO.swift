//
//  CategoryDTO.swift
//  ToDo
//
//  Created by Sajith Konara on 6/13/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

class CategoryDTO:Equatable{
    
    var name:String
    var isSelected:Bool
    
    init(name:String,isSelected:Bool) {
        self.name = name
        self.isSelected = isSelected
    }
    
    static func == (lhs: CategoryDTO, rhs: CategoryDTO) -> Bool {
        return lhs.name == rhs.name
    }
}
