//
//  TestDataLayer.swift
//  ToDoTests
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import CoreData
import RxRelay

@testable import ToDo

class TestDataLayer:DataLayer{
    
    var container:NSPersistentContainer
    
    
    init(container:NSPersistentContainer) {
        self.container = container
    }
    
    override var context: NSManagedObjectContext{
        return container.viewContext
    }
}

