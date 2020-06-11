//
//  UIConstant.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class UIConstant{
    
    enum StoryBoardID:String{
        
        case HomeVC = "homeVC"
        case AddTaskVC = "addTaskVC"
        case QueryVC = "queryVC"
        case CategoriesVC = "categoriesVC"
        
    }
    
    enum StoryBoard:String{
        case Main = "Main"
    }
    
    enum Cell:String{
        case FeaturedCollectionViewCell = "featuredCVCell"
        case TaskTypeTableViewCell = "taskTypeTVCell"
        case TaskTableViewCell = "taskTVCell"
        case CalenderCollectionViewCell = "calenderCVCell"
        case CategoriesCollectionViewCell = "categoriesCVCell"
        case CategoriesTableViewCell = "categoriesTVCell"
        
    }
    
}
