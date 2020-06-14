//
//  CategoriesViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class CategoriesViewModel{
    
    
    let modelLayer = ModelLayer()
    
    var categories:[Category]  {
        modelLayer.dataLayer.getAllCategories()
    }
    
    func addCategory(for name:String){
        modelLayer.dataLayer.addCategory(name: name)
    }
    
}
