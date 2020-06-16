//
//  HomeViewModelTests.swift
//  ToDoTests
//
//  Created by Sajith Konara on 6/16/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import XCTest
@testable import ToDo

class HomeViewModelTests: XCTestCase {
    
    var sut:HomeViewModel!
    
    override func setUp() {
        sut = HomeViewModel()
        createContainer { (container) in
            self.sut.modelLayer.dataLayer = TestDataLayer(container: container)
        }
    }
    
    override  func tearDown() {
        sut = nil
    }
    
    private func addCategory(){
        sut.modelLayer.dataLayer.addCategory(name: "Test")
    }
    
    func testFeaturedItems(){
        sut.getFeaturedItems()
        XCTAssertTrue(sut.featuredItems.count > 0)
    }
    
    func testCategoryInfo(){
        addCategory()
        sut.getcategoryInfo()
        XCTAssertTrue(sut.categoryInfo.value.count == 1)
    }
}
