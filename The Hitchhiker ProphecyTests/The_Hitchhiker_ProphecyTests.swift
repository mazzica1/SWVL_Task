//
//  The_Hitchhiker_ProphecyTests.swift
//  The Hitchhiker ProphecyTests
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import XCTest

class The_Hitchhiker_ProphecyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    class DummyDisplayView:HomeSceneDisplayView{
        var interactor: HomeSceneBusinessLogic?
        
        var router: HomeSceneRoutingLogic?
        var e : XCTestExpectation?
        
        func didFetchCharacters(viewModel: [HomeScene.Search.ViewModel]){
            XCTAssertTrue(viewModel.count > 0 )
            e?.fulfill()
        }
        func failedToFetchCharacters(error: Error){
            XCTAssertNil(error )
            e?.fulfill()
        }
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let dummy = DummyDisplayView()
        
        dummy.e = expectation(description: "Alamofire")
        
        let Interactor = HomeSceneInteractor(worker: HomeSearchWorker(),presenter: HomeScenePresneter(displayView: dummy))
        Interactor.fetchCharacters()
        waitForExpectations(timeout: 100.0, handler: nil)

    }
   

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
