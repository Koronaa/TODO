//
//  QueryViewModelTests.swift
//  ToDoTests
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import XCTest
@testable import ToDo

class QueryViewModelTests: XCTestCase {
    
    var sut:QueryViewModel!
    
    override func setUp() {
        sut = QueryViewModel()
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
    
    private func addTask(for name:String){
        sut.modelLayer.addTask(for: TaskDTO(name: name, isFavourite: true, isReminder: true, dateTime: Date()), categoryDTO: CategoryDTO(name: "Test", isSelected: true))
    }
    
    private func addTaskForTomorrow(for name:String){
        sut.modelLayer.addTask(for: TaskDTO(name: name, isFavourite: true, isReminder: true, dateTime: Calendar.current.date(byAdding: .day, value: 1, to: Date())!), categoryDTO: CategoryDTO(name: "Test", isSelected: true))
    }
    
    
    
    func testGetTaskWithoutSort(){
        addCategory()
        addTask(for: "Test Task")
        sut.getTaks(for: "Test")
        XCTAssertTrue(sut.tasks.value.count == 1)
    }
    
    func testGetTasksWithNilCategory(){
        sut.getTaks(for: nil, isSortingEnabled: true, sortType: .BY_NAME)
        XCTAssertTrue(sut.tasks.value.count == 0)
    }
    
    func testGetFeatredTasksToday(){
        addCategory()
        addTask(for: "Test Task")
        sut.getFeaturedTasks(for: .Today)
        XCTAssertTrue(sut.tasks.value.count == 1)
        XCTAssertEqual(sut.tasks.value.first!.name, "Test Task")
    }
    
    func testGetFeatredTasksByMonth(){
        addCategory()
        addTask(for: "Test Task")
        sut.getFeaturedTasks(for: .Month)
        XCTAssertTrue(sut.tasks.value.count == 1)
        XCTAssertEqual(sut.tasks.value.first!.name, "Test Task")
    }
    
    func testGetFeatredTasksByWeek(){
        addCategory()
        addTask(for: "Test Task")
        sut.getFeaturedTasks(for: .Week)
        XCTAssertTrue(sut.tasks.value.count == 1)
        XCTAssertEqual(sut.tasks.value.first!.name, "Test Task")
    }
    
    func testGetFeatredTasksByFeavourite(){
        addCategory()
        addTask(for: "Test Task")
        sut.getFeaturedTasks(for: .Favourite)
        XCTAssertTrue(sut.tasks.value.count == 1)
        XCTAssertEqual(sut.tasks.value.first!.name, "Test Task")
    }
    
    func testGetFeatredTasksForTomorrow(){
        addCategory()
        addTaskForTomorrow(for: "Hello")
        sut.getFeaturedTasks(for: .Tomorrow)
        XCTAssertTrue(sut.tasks.value.count == 1)
        XCTAssertEqual(sut.tasks.value.first!.name, "Hello")
    }
    
    func testGetTasksForSpecificDate(){
        addCategory()
        addTask(for: "Test Task")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        sut.getTasksForSpecificDate(dateString: dateFormatter.string(from: Date()))
        XCTAssertTrue(sut.tasks.value.count == 1)
        XCTAssertEqual(sut.tasks.value.first!.name, "Test Task")
    }
    
    
    
}
