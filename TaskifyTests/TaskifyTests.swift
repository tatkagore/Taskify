//
//  TaskifyTests.swift
//  TaskifyTests
//
//  Created by Tatiana Simmer on 13/02/2024.
//

import XCTest
@testable import Taskify

class MockTasksListDisplayer: TasksListDisplayer {
    var showErrorCalled = false
    var showTasksCalled = false
    var receivedError: Error?
    var receivedTasks: [Record]?

    func showTasks( _ tasks: [Record]) {
        showTasksCalled = true
        receivedTasks = tasks
    }

    func showError( _ error: Error) {
        showErrorCalled = true
        receivedError = error
    }
}

class TasksListsPresenterImplTests: XCTestCase {
    
    var presenter: TasksListsPresenterImpl!
    var mockDisplayer: MockTasksListDisplayer!
    
    override func setUpWithError() throws {
        super.setUp()
        mockDisplayer = MockTasksListDisplayer()
        presenter = TasksListsPresenterImpl()
        presenter.bind(displayer: mockDisplayer)
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        mockDisplayer = nil
        super.tearDown()
    }
    
    // this test passes when you turn off connection :)
    func testFetchTasksError() {
        let expectation = XCTestExpectation(description: "Expect showError to be called on network error")

        presenter.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if self.mockDisplayer.showErrorCalled {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(mockDisplayer.showErrorCalled, "showError should be called on network error")
    }
    
    func testFetchTasksSuccess() {
        let expectation = XCTestExpectation(description: "Expect showTasks to be called on successful fetch")

        presenter.fetchTasks()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {  // Adjust delay as necessary
            if self.mockDisplayer.showTasksCalled && self.mockDisplayer.receivedTasks != nil {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)  // Adjust timeout as necessary
        XCTAssertTrue(mockDisplayer.showTasksCalled, "showTasks should be called on successful fetch")
        XCTAssertNotNil(mockDisplayer.receivedTasks, "Received tasks should not be nil")
      
    }
}
