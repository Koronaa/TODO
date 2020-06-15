//
//  CategoriesTableViewViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/15/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class CategoriesTableViewViewModel{
    
    var category:Category
    
    init(category:Category) {
        self.category = category
    }
    
    var name:String{
        return category.name
    }
}
