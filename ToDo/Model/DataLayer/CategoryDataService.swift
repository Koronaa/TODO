//
//  CategoryDataService.swift
//  ToDo
//
//  Created by Sajith Konara on 6/12/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import CoreData

class CategoryDataService{
    
    private var fetchRequest:NSFetchRequest<Category>{
        return NSFetchRequest<Category>(entityName: Category.entityName)
    }
    
    func getAllCategories(for context:NSManagedObjectContext) -> [Category]{
        
        let categoriesFetchRequest = fetchRequest
        do{
            let categories = try context.fetch(categoriesFetchRequest)
            return categories
        }catch{
            print(error.localizedDescription)
            return [Category]()
        }
    }
    
//    g/et
    
}
