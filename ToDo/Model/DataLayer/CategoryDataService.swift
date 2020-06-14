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
    
    func addCategory(name:String,for context:NSManagedObjectContext){
        let newCategory = NSEntityDescription.insertNewObject(forEntityName: Category.entityName, into: context) as! Category
        newCategory.name = name
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
            context.rollback()
        }
    }
    
    func getCategory(for name:String,context:NSManagedObjectContext) -> Category?{
        let categoryFetchRequest = fetchRequest
        categoryFetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do{
            let category = try context.fetch(categoryFetchRequest).first
            return category
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteCategory(for category:Category,context:NSManagedObjectContext){
        let deleteRequest = fetchRequest
        deleteRequest.predicate = NSPredicate(format: "name = %@", category.name)
        do{
            if let retrievedCategory = try context.fetch(deleteRequest).first{
                context.delete(retrievedCategory)
                try context.save()
            }
        }catch{
            print(error.localizedDescription)
            context.rollback()
        }
        
    }
}
