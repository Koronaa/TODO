//
//  TaskCRUDTests.swift
//  ToDoTests
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import XCTest
import RxSwift
@testable import ToDo

class TaskCRUDTests: XCTestCase {
    
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
    
    private  func addTestCategory(){
        dataLayer.addCategory(name: "Test").asObservable()
            .subscribe(onNext: { (_,_) in
            }).disposed(by: bag)
    }
    
    private func getTestCategory()->ToDo.Category?{
        dataLayer.getCategoryByName(name: "Test")
    }
    
    private func deleteCategory(){
        dataLayer.deleteCategory(category: getTestCategory()!).asObservable()
            .subscribe(onNext: { (_,_) in
            }).disposed(by: bag)
    }
    
    private func addTestTaskWithCategoryForToday(name:String = "Test Task"){
        let task = TaskDTO(name: name, isFavourite: true, isReminder: false, dateTime: Date())
        dataLayer.addTask(for: task, category: getTestCategory()).asObservable()
            .subscribe(onNext: { (_,_) in
            }).disposed(by: bag)
    }
    
    private func addTestTaskWithCategoryForTomorrow(){
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let task = TaskDTO(name: "Get Apple", isFavourite: true, isReminder: false, dateTime: date)
        dataLayer.addTask(for: task, category: getTestCategory()).asObservable()
            .subscribe(onNext: { (_,_) in
            }).disposed(by: bag)
    }
    
    private func getTask()->ToDo.Task?{
        return dataLayer.getTasksForDate(date: Date(), isSortingEnabled: false, sortType: .BY_NAME).first
    }
    
    func testAddTaskWithCategory(){
        dataLayer.addCategory(name: "Test").asObservable()
            .subscribe(onNext: { (isAdded,error) in
                self.dataLayer.addCategory(name: "Test").asObservable()
                    .subscribe(onNext: { (isAdded,error) in
                        let task = TaskDTO(name: "Test Task", isFavourite: true, isReminder: false, dateTime: Date())
                        self.dataLayer.addTask(for: task, category: self.dataLayer.getCategoryByName(name: "Test")).asObservable()
                            .subscribe(onNext: { (isAdded,error) in
                                XCTAssertTrue(isAdded)
                                XCTAssertNil(error)
                            }).disposed(by: self.bag)
                    }).disposed(by: self.bag)
            }).disposed(by: bag)
        
    }
    
    func testAddTaskWithNilCategory(){
        let task = TaskDTO(name: "Test Task", isFavourite: true, isReminder: false, dateTime: Date())
        self.dataLayer.addTask(for: task, category: nil).asObservable()
            .subscribe(onNext: { (isAdded,error) in
                XCTAssertTrue(isAdded)
                XCTAssertNil(error)
            }).disposed(by: self.bag)
    }
    
    func testRetriveTaskWithCategory(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        let tasks:[Task] = self.dataLayer.getTasksForCategory(category: getTestCategory(), isSortingEnabled: false, sortType: .BY_NAME)
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first!.name, "Test Task")
    }
    
    func testRetriveTaskWithCategorySortedByName(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForTomorrow()
        let tasks:[Task] = self.dataLayer.getTasksForCategory(category: getTestCategory(), isSortingEnabled: true, sortType: .BY_NAME)
        XCTAssertEqual(tasks.first!.name, "Get Apple")
    }
    
    func testRetriveTaskWithCategorySortedByDate(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForTomorrow()
        let tasks:[Task] = self.dataLayer.getTasksForCategory(category: getTestCategory(), isSortingEnabled: true, sortType: .BY_DATE)
        XCTAssertEqual(tasks.first!.name, "Test Task")
    }
    
    func testRetriveTaskWithNilCategory(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        deleteCategory()
        let tasks:[Task] = self.dataLayer.getTasksForCategory(category: nil, isSortingEnabled: false, sortType: .BY_NAME)
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first!.name, "Test Task")
    }
    
    func testUpdateTask(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        let oldTask = getTask()
        let taskDTO = TaskDTO(name: "Updated Task", isFavourite: true, isReminder: false, dateTime: Date())
        XCTAssertEqual("Test Task", oldTask!.name)
        dataLayer.updateTask(currentTask: oldTask!, updatedTask: taskDTO, updatedCategory: getTestCategory()!).asObservable()
            .subscribe(onNext: { (isUpdated,error) in
                XCTAssertTrue(isUpdated)
                XCTAssertNil(error)
                XCTAssertNotEqual("Test Task", oldTask!.name)
            }).disposed(by: self.bag)
    }
    
    func testDeleteTask(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        XCTAssertNotNil(getTask())
        dataLayer.deleteTask(task: getTask()!).asObservable()
            .subscribe(onNext: { (isDeleted,error) in
                XCTAssertTrue(isDeleted)
                XCTAssertNil(error)
                XCTAssertNil(self.getTask())
            }).disposed(by: self.bag)
    }
    
    func testFavouritesTasksWithoutSort(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForToday()
        let tasks = dataLayer.getFeaturedTaks(for: .Favourite, isSortingEnabled: false, sortType: .BY_NAME)
        XCTAssertEqual(tasks.count, 2)
    }
    
    func testFavouritesTasksSortByName(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForTomorrow()
        let tasks = dataLayer.getFeaturedTaks(for: .Favourite, isSortingEnabled: true, sortType: .BY_NAME)
        XCTAssertEqual(tasks.first!.name, "Get Apple")
    }
    
    func testFavouritesTasksSortByDate(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForTomorrow()
        let tasks = dataLayer.getFeaturedTaks(for: .Favourite, isSortingEnabled: true, sortType: .BY_DATE)
        XCTAssertEqual(tasks.first!.name, "Test Task")
    }
    
    
    func testTasksForToday(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForToday()
        let tasks = dataLayer.getFeaturedTaks(for: .Today, isSortingEnabled: false, sortType: .BY_NAME)
        XCTAssertEqual(tasks.count, 2)
    }
    
    func testTasksForThisMonthWithoutSort(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForToday()
        let tasks = dataLayer.getFeaturedTaks(for: .Month, isSortingEnabled: false, sortType: .BY_NAME)
        XCTAssertEqual(tasks.count, 2)
    }
    
    func testTasksForThisMonthSortByName(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForTomorrow()
        let tasks = dataLayer.getFeaturedTaks(for: .Month, isSortingEnabled: true, sortType: .BY_NAME)
        XCTAssertEqual(tasks.first!.name, "Get Apple")
    }
    
    func testTasksForThisMonthSortByDate(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForTomorrow()
        let tasks = dataLayer.getFeaturedTaks(for: .Month, isSortingEnabled: true, sortType: .BY_DATE)
        XCTAssertEqual(tasks.first!.name, "Test Task")
    }
    
    
    func testTasksForThisWeek(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForToday()
        let tasks = dataLayer.getFeaturedTaks(for: .Week, isSortingEnabled: false, sortType: .BY_NAME)
        XCTAssertEqual(tasks.count, 2)
    }
    
    
    func testTasksForTomorrow(){
        addTestCategory()
        addTestTaskWithCategoryForTomorrow()
        addTestTaskWithCategoryForTomorrow()
        let tasks = dataLayer.getFeaturedTaks(for: .Tomorrow, isSortingEnabled: false, sortType: .BY_NAME)
        XCTAssertEqual(tasks.count, 2)
    }
    
    func testTasksSortedByName(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForTomorrow()
        
        let tasks = dataLayer.getFeaturedTaks(for: .Favourite, isSortingEnabled: true, sortType: .BY_NAME)
        XCTAssertEqual(tasks.first!.name, "Get Apple")
    }
    
    func testTasksSortedByDate(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForTomorrow()
        
        let tasks = dataLayer.getFeaturedTaks(for: .Favourite, isSortingEnabled: true, sortType: .BY_DATE)
        XCTAssertEqual(tasks.first!.name, "Test Task")
    }
    
    func testsGetTasksForDaySortByName(){
        addTestCategory()
        addTestTaskWithCategoryForToday()
        addTestTaskWithCategoryForToday(name: "Apple")
        
        let tasks = dataLayer.getTasksForDate(date: Date(), isSortingEnabled: true, sortType: .BY_NAME)
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks.first!.name, "Apple")
    }
    
    func testsGetTasksForDaySortByDate(){
        addTestCategory()
        addTestTaskWithCategoryForToday(name: "Apple")
        let date = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
        let task = TaskDTO(name: "Get Apple", isFavourite: true, isReminder: false, dateTime: date)
        dataLayer.addTask(for: task, category: getTestCategory()).asObservable()
            .subscribe(onNext: { (_,_) in
            }).disposed(by: bag)
        
        let tasks = dataLayer.getTasksForDate(date: Date(), isSortingEnabled: true, sortType: .BY_NAME)
        
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks.first!.name, "Apple")
    }
}
