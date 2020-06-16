//
//  AddTaskViewModelTests.swift
//  ToDoTests
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import XCTest
import RxSwift

@testable import ToDo

class AddTaskViewModelTests: XCTestCase {
    
    var sut:AddTaskViewModel!
    let bag = DisposeBag()
    
    override func setUp() {
        sut = AddTaskViewModel(UIType: .CREATE)
        createContainer { (container) in
            self.sut.modelLayer.dataLayer = TestDataLayer(container: container)
        }
    }
    
    override  func tearDown() {
        sut = nil
    }
    
    private func addCategory(){
        sut.modelLayer.addCategory(name: "Test")
    }
    
    private func addTestTask(){
        sut.getReminders()
        sut.taskTitle = "Test Task"
        sut.isFavourite = true
        sut.isReminder = true
        sut.selectedDate = Date()
        sut.selectedCategory = CategoryDTO(name: "Test", isSelected: true)
        sut.addTask()
    }
    
    private func getTask() -> Task{
        addCategory()
        addTestTask()
        return sut.modelLayer.dataLayer.getFeaturedTaks(for: .Today, isSortingEnabled: false, sortType: .BY_NAME).first!
    }
    
    func testAddTask(){
        sut.getReminders()
        sut.taskTitle = "Test Task"
        sut.isFavourite = true
        sut.isReminder = true
        sut.selectedDate = Date()
        sut.selectedCategory = CategoryDTO(name: "Test", isSelected: true)
        sut.addTask().asObservable().subscribe(onNext: { (isAdded,error) in
            XCTAssertTrue(isAdded)
//            XCTAssertNil(error)
        }).disposed(by: bag)
    }
    
    func testGetTranlatedCategories(){
        addCategory()
        sut.getTranslatedCategories()
        XCTAssertEqual(sut.translatedCategories.value.count, 1)
    }
    
    
    
    func testUpdateTask(){
        addCategory()
        addTestTask()
        sut.taskTitle = "Updated Task"
        sut.isFavourite = true
        sut.isReminder = true
        sut.selectedDate = Date()
        sut.currentTask = getTask()
        sut.selectedCategory = CategoryDTO(name: "Test", isSelected: true)
        sut.updateTask().subscribe(onNext: { (isUpdated,error) in
            XCTAssertTrue(isUpdated)
//            XCTAssertNil(error)
        }).disposed(by: bag)
    }
    
    
    func testDeleteTask(){
        addCategory()
        addTestTask()
        sut.currentTask = getTask()
        sut.deleteTask().subscribe(onNext: { (isDeleted,error) in
            XCTAssertTrue(isDeleted)
            XCTAssertNil(error)
        }).disposed(by: bag)
        
    }
    
    
    
    
}
