//
//  LoadableTests.swift
//  SceneMachineTests
//
//  Created by Duy Tran on 10/3/20.
//

import XCTest
@testable import SceneMachine

final class LoadableTests: XCTestCase {
    
    typealias SUT = Loadable<[Int]>
    
    func testValue() throws {
        var value: [Int]!
        XCTAssertNil(SUT.isLoading(last: value).value)
        value = []
        XCTAssertEqual(SUT.isLoading(last: value).value, value)
        XCTAssertEqual(SUT.loaded(value).value, value)
        XCTAssertNil(SUT.failed(StubError()).value)
    }
    
    func testError() throws {
        XCTAssertNil(SUT.isLoading(last: nil).error)
        XCTAssertNil(SUT.isLoading(last: []).error)
        XCTAssertNil(SUT.loaded([]).error)
        let error = StubError()
        XCTAssertEqual(SUT.failed(error).error as! StubError, error)
    }
    
    func testEquatable() throws {
        let value = [1]
        let otherValue = [2]
        let error = StubError()
        XCTAssertEqual(SUT.isLoading(last: nil), SUT.isLoading(last: nil))
        XCTAssertEqual(SUT.isLoading(last: value), SUT.isLoading(last: value))
        XCTAssertNotEqual(SUT.isLoading(last: nil), SUT.isLoading(last: value))
        XCTAssertNotEqual(SUT.isLoading(last: nil), SUT.loaded(value))
        XCTAssertNotEqual(SUT.isLoading(last: nil), SUT.failed(error))
        XCTAssertNotEqual(SUT.isLoading(last: value), SUT.loaded(value))
        XCTAssertNotEqual(SUT.isLoading(last: value), SUT.failed(error))
        
        XCTAssertEqual(SUT.loaded(value), SUT.loaded(value))
        XCTAssertNotEqual(SUT.loaded(value), SUT.loaded(otherValue))
        XCTAssertNotEqual(SUT.loaded(value), SUT.failed(error))
        
        XCTAssertEqual(SUT.failed(error), SUT.failed(error))
    }
}
