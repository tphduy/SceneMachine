//
//  StateMachineTests.swift
//  SceneMachineTests
//
//  Created by Duy Tran on 10/3/20.
//

import XCTest
@testable import SceneMachine

final class StateMachineTests: XCTestCase {
    
    var provider: SpySceneMachineViewProvider!
    var sut: DefaultSceneMachine<[Int]>!

    override func setUpWithError() throws {
        provider = SpySceneMachineViewProvider()
        provider.stubbedParentView = UIView()
        provider.stubbedconstraintView = UIView()
        provider.stubbedContentView = UIView()
        provider.stubbedLoadingViewResult = UIView()
        provider.stubbedEmptyViewResult = UIView()
        provider.stubbedErrorViewResult = UIView()
        provider.parentView.addSubview(provider.constraintView)
        
        sut = DefaultSceneMachine()
    }

    override func tearDownWithError() throws {
        provider = nil
        sut = nil
    }
    
    // MARK: Test Cases - present(_:by)
    
    func test_presentStateByProvider_whenAppropriateStatefulIsNil() throws {
        let state = Loadable<[Int]>.isLoading(last: nil)
        provider.stubbedLoadingViewResult = nil
        
        XCTAssertFalse(provider.invokedLoadingView)
        
        sut.present(state, by: provider)
        
        XCTAssertTrue(provider.invokedLoadingView)
        XCTAssertEqual(provider.parentView.subviews, [provider.constraintView])
    }
    
    func test_presentStateByProvider() throws {
        let state = Loadable<[Int]>.isLoading(last: nil)
        
        XCTAssertFalse(provider.invokedLoadingView)
        
        sut.present(state, by: provider)
        
        XCTAssertTrue(provider.invokedLoadingView)
        XCTAssertEqual(provider.parentView.subviews.last, provider.loadingView())
    }
    
    // MARK: Test Cases - getStatefulView(represent:by)
    
    func test_getStatefulViewRepresentStateByProvider() throws {
        XCTAssertEqual(
            sut.getStatefulView(
                represent: .isLoading(last: nil),
                by: provider),
            provider.loadingView())
        
        XCTAssertEqual(
            sut.getStatefulView(
                represent: .isLoading(last: [1]),
                by: provider),
            provider.contentView)
        
        XCTAssertEqual(
            sut.getStatefulView(
                represent: .loaded([]),
                by: provider),
            provider.emptyView())
        
        XCTAssertEqual(
            sut.getStatefulView(
                represent: .loaded([1]),
                by: provider),
            provider.contentView)
        
        let error = StubError()
        XCTAssertEqual(
            sut.getStatefulView(
                represent: .failed(error),
                by: provider),
            provider.errorView(error: error))
    }
    
    // MARK: Test Cases - present(_:in:equalTo)
    
    func test_presentViewInParentViewEqualToConstraintView_whenViewIsSubviewAlready() throws {
        let view = UIView()
        let parentView = UIView()
        let constraintView = UIView()
        let otherView = UIView()
        
        parentView.addSubview(constraintView)
        parentView.addSubview(view)
        parentView.addSubview(otherView)
        
        XCTAssertTrue(view.isDescendant(of: parentView))
        
        sut.present(
            view,
            in: parentView,
            equalTo: constraintView)
        
        XCTAssertEqual(parentView.subviews.last, view)
        XCTAssertFalse(view.isDescendant(of: constraintView))
        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
    }
    
    func test_presentViewInParentViewEqualToConstraintView() throws {
        let view = UIView()
        let parentView = UIView()
        let constraintView = UIView()
        let otherView = UIView()
        parentView.addSubview(constraintView)
        parentView.addSubview(otherView)
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        
        sut.present(
            view,
            in: parentView,
            equalTo: constraintView)
        
        XCTAssertEqual(parentView.subviews.last, view)
        XCTAssertFalse(view.isDescendant(of: constraintView))
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
    }
    
    // MARK: Test Cases - constraint(_:equalTo)
    
    func test_constraintFirstViewToSecondView() throws {
        let firstView = UIView()
        let secondView = UIView()
        secondView.addSubview(firstView)
        
        sut.constraint(firstView, equalTo: secondView)
        
        XCTAssertFalse(firstView.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(secondView.constraints.isEmpty)
    }
}
