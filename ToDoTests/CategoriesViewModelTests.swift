//
//  ViewModelTests.swift
//  ToDoTests
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import XCTest
import RxSwift
@testable import ToDo


class CategoriesViewModelTests: XCTestCase {
    
    var sut:CategoriesViewModel!
    let bag = DisposeBag()
    
    override func setUp() {
        sut = CategoriesViewModel()
        createContainer { (container) in
            self.sut.modelLayer.dataLayer = TestDataLayer(container: container)
        }
    }
    
    override  func tearDown() {
        sut = nil
    }
    
    private func addTestCategory(){
        sut.addCategory(for: "Test").asObservable()
            .subscribe(onNext: { (_,_) in
            }).disposed(by: bag)
    }
    
    func testAddCategory(){
        sut.addCategory(for: "Test").asObservable()
            .subscribe(onNext: { (isAdded,error) in
                XCTAssertTrue(isAdded)
                XCTAssertNil(error)
                self.sut.getCategories()
                XCTAssertTrue(self.sut.categories.value.count == 1)
            }).disposed(by: bag)
    }
    
    func testAddDuplicateCategories(){
        addTestCategory()
        sut.getCategories()
        sut.addCategory(for: "Test").asObservable()
            .subscribe(onNext: { (isAdded,error) in
                XCTAssertFalse(isAdded)
                XCTAssertNotNil(error)
            }).disposed(by: bag)
    }
    
    func testDeleteCategory(){
        addTestCategory()
        sut.getCategories()
        sut.selectedCategory = sut.categories.value.first!
        sut.deleteCategory()
        sut.getCategories()
        XCTAssertTrue(self.sut.categories.value.count == 0)
    }
}
