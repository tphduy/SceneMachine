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
    
    // MARK: - Life Cycle
    
    override func setUpWithError() throws {
        provider = SpySceneMachineViewProvider()
        sceneMachine = SpySceneMachine()
        sut = AnySceneMachine(sceneMachine)
    }
    
    override func tearDownWithError() throws {
        sceneMachine = nil
        sut = nil
    }
    
    // MARK: - Test Cases - present(_:by:)
    
    func test_presentState_whenStateIsLoading_withoutLast() {
        let state = Loadable<[Int]>.isLoading(last: nil)
        
        XCTAssertFalse(sceneMachine.invokedPresent)
        XCTAssertNil(state.value)
        
        sut.present(state, by: provider)
        
        XCTAssertTrue(sceneMachine.invokedPresent)
        XCTAssertEqual(sceneMachine.invokedPresentParameters?.state, state)
        XCTAssertTrue(sceneMachine.invokedPresentParameters?.provider === provider)
    }
    
    func test_presentState_whenStateIsLoading() {
        let state = Loadable<[Int]>.isLoading(last: [1, 2, 3])
        
        XCTAssertFalse(sceneMachine.invokedPresent)
        XCTAssertNotNil(state.value)
        
        sut.present(state, by: provider)
        
        XCTAssertTrue(sceneMachine.invokedPresent)
        XCTAssertEqual(sceneMachine.invokedPresentParameters?.state, state)
        XCTAssertTrue(sceneMachine.invokedPresentParameters?.provider === provider)
    }
    
    func test_presentState_whenStateIsLoaded_butEmpty() {
        let state = Loadable<[Int]>.loaded([])
        
        XCTAssertFalse(sceneMachine.invokedPresent)
        XCTAssertTrue(state.value!.isEmpty)
        
        sut.present(state, by: provider)
        
        XCTAssertTrue(sceneMachine.invokedPresent)
        XCTAssertEqual(sceneMachine.invokedPresentParameters?.state, state)
        XCTAssertTrue(sceneMachine.invokedPresentParameters?.provider === provider)
    }
    
    func test_presentState_whenStateIsLoaded() {
        let state = Loadable<[Int]>.loaded([1, 2, 3])
        
        XCTAssertFalse(sceneMachine.invokedPresent)
        XCTAssertFalse(state.value!.isEmpty)
        
        sut.present(state, by: provider)
        
        XCTAssertTrue(sceneMachine.invokedPresent)
        XCTAssertEqual(sceneMachine.invokedPresentParameters?.state, state)
        XCTAssertTrue(sceneMachine.invokedPresentParameters?.provider === provider)
    }
    
    func test_presentState_whenStateIsFailed() {
        let error = StubError(stubErrorDescription: "Lorem")
        let state = Loadable<[Int]>.failed(error)
        
        XCTAssertFalse(sceneMachine.invokedPresent)
        XCTAssertNotNil(state.error!)
        
        sut.present(state, by: provider)
        
        XCTAssertTrue(sceneMachine.invokedPresent)
        XCTAssertEqual(sceneMachine.invokedPresentParameters?.state, state)
        XCTAssertTrue(sceneMachine.invokedPresentParameters?.provider === provider)
    }
}
