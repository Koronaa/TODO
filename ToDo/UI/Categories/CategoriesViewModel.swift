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
    
    var selectedCategory:Category!
    
    var categories:[Category]  {
        modelLayer.dataLayer.getAllCategories()
    }
    
    func addCategory(for name:String){
        let filetredCategory = categories.filter{ $0.name == name.trim}
        if filetredCategory.count > 0{
            print("This Category Already Exisit")
        }else{
            modelLayer.dataLayer.addCategory(name: name.trim)
        }
    }
    
    func deleteCategory(){
        modelLayer.dataLayer.deleteCategory(category: selectedCategory)
    }
    
}
