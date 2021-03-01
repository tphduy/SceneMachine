//
//  AnyStateMachineTests.swift
//  SceneMachineTests
//
//  Created by Duy Tran on 10/3/20.
//

import XCTest
@testable import SceneMachine

final class AnyStateMachineTests: XCTestCase {
    
    var provider: SpySceneMachineViewProvider!
    var sceneMachine: SpySceneMachine<[Int]>!
    var sut: AnySceneMachine<[Int]>!
    
    override func setUpWithError() throws {
        provider = SpySceneMachineViewProvider()
        sceneMachine = SpySceneMachine()
        sut = AnySceneMachine(sceneMachine)
    }
    
    override func tearDownWithError() throws {
        sceneMachine = nil
        sut = nil
    }
    
    func test_presentState() {
        let state = Loadable<[Int]>.loaded([1, 2, 3])
        
        XCTAssertFalse(sceneMachine.invokedPresent)
        
        sut.present(state: state, provider: provider)
        
        XCTAssertTrue(sceneMachine.invokedPresent)
        XCTAssertEqual(sceneMachine.invokedPresentParameters?.state, state)
        XCTAssertTrue(sceneMachine.invokedPresentParameters?.provider === provider)
    }
}
