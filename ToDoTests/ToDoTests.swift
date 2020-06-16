//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import XCTest
import CoreData
import RxRelay

@testable import ToDo

class ToDoTests: XCTestCase {
    
    func testManagedObjectContext(){
        createContainer { (container) in
            XCTAssertNotNil(container.viewContext)
        }
    }
}

func createContainer(onCompleted:@escaping (_ container:NSPersistentContainer)->Void){
    let container = NSPersistentContainer(name: "ToDo")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in
        if let e = error{
            fatalError(e.localizedDescription)
        }
        onCompleted(container)
    }
}
