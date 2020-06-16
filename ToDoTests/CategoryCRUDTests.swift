//
//  ToDoCRUDTests.swift
//  ToDoTests
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import XCTest
import CoreData
import RxRelay
import RxSwift
@testable import ToDo

class CategoryCRUDTests: XCTestCase {
    
    var dataLayer:TestDataLayer!
    let bag = DisposeBag()

    override func setUp() {
        createContainer { (container) in
            self.dataLayer = TestDataLayer(container: container)
        }
        
    }

    override func tearDown() {
        dataLayer = nil
    }
    
    func testAddCategories(){
        dataLayer.addCategory(name: "Test").asObservable()
            .subscribe(onNext: { (isAdded,error) in
                XCTAssertTrue(isAdded)
                XCTAssertNil(error)
            }).disposed(by: bag)
    }
    
    func testGetCategories(){
        dataLayer.addCategory(name: "Test").asObservable()
        .subscribe(onNext: { (isAdded,_) in
            let categories:[ToDo.Category] = self.dataLayer.getAllCategories()
            XCTAssertNotNil(categories.first)
            XCTAssertEqual(categories.first?.name, "Test")
        }).disposed(by: bag)
    }
    
    func testDeleteCategory(){
        dataLayer.addCategory(name: "Test").asObservable()
        .subscribe(onNext: { (isAdded,error) in
            self.testDeleteCategory(for: self.dataLayer.getAllCategories().first!)
        }).disposed(by: bag)
    }
    
    private func testDeleteCategory(for category:ToDo.Category){
        dataLayer.deleteCategory(category: category).asObservable()
            .subscribe(onNext: { (isDeleted,error) in
                 XCTAssertTrue(isDeleted)
                 XCTAssertNil(error)
                let categories:[ToDo.Category] = self.dataLayer.getAllCategories()
                XCTAssertNil(categories.first)
                XCTAssertEqual(categories.count, 0)
            }).disposed(by: bag)
    }
    
    func testCategoryByName(){
        dataLayer.addCategory(name: "Test").asObservable()
        .subscribe(onNext: { (isAdded,error) in
            XCTAssertNotNil(self.dataLayer.getCategoryByName(name: "Test"))
        }).disposed(by: bag)
    }
    
    func testCategoryByNilName(){
        XCTAssertNil(dataLayer.getCategoryByName(name: nil))
    }
    
    
    func testGetCategoryInfo(){
        dataLayer.addCategory(name: "Test").asObservable()
            .subscribe(onNext: { (isAdded,error) in
                let categoryInfo:[CategoryInfo] = self.dataLayer.getCategoryInfo()
                XCTAssertEqual(categoryInfo.count, 1)
                XCTAssertEqual(categoryInfo.first!.name, "Test")
                XCTAssertEqual(categoryInfo.first!.taskCount, 0)
            }).disposed(by: bag)
        }
}
