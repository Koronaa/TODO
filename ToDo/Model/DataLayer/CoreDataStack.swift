//
//  CoreDataStack.swift
//  ToDo
//
//  Created by Sajith Konara on 6/12/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDatable {
    var managedObjectContext:NSManagedObjectContext! {get set}
}

func createMainContext(completion: @escaping (NSPersistentContainer) -> Void) {
    
    let container = NSPersistentContainer(name: "ToDo")
    container.loadPersistentStores { persistentStoreDescription, error in
        guard error == nil else {fatalError("Fail to load the store: \(String(describing: error?.localizedDescription))")}
        DispatchQueue.main.async {
            completion(container)
        }
    }
}


