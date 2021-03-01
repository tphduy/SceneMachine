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
        provider.stubbedConstrainedTargetView = UIView()
        provider.stubbedContentView = UIView()
        provider.stubbedLoadingViewResult = UIView()
        provider.stubbedEmtyViewResult = UIView()
        provider.stubbedErrorViewResult = UIView()
        provider.stubbedParentView.addSubview(provider.stubbedConstrainedTargetView)
        sut = DefaultSceneMachine()
    }

    override func tearDownWithError() throws {
        provider = nil
        sut = nil
    }
    
    func test_presentState_whenStateIsLoading_withLastItem() throws {
        let view = provider.contentView
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        
        sut.present(state: .isLoading(last: [0]), provider: provider)
        
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func test_presentState_whenStateIsLoading_withoutLastItem() throws {
        let view = provider.loadingView()
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        
        sut.present(state: .isLoading(last: nil), provider: provider)
        
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func test_presentState_whenStateIsLoaded_withEmptyItem() throws {
        let view = provider.emptyView()
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        
        sut.present(state: .loaded([]), provider: provider)
        
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func test_presentState_whenStateIsLoaded_withItem() throws {
        let view = provider.contentView
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        
        sut.present(state: .loaded([0]), provider: provider)
        
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func test_presentState_whenStateIsFailed() throws {
        let error = StubError()
        let view = provider.errorView(error: error)
        let parentView = provider.parentView
        
        XCTAssertFalse(view.isDescendant(of: parentView))
        
        sut.present(state: .failed(error), provider: provider)
        
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertEqual(parentView.subviews.last, view)
    }
    
    func test_presentView() throws {
        let view = UIView()
        let parentView = UIView()
        let constrainedTargetView = UIView()
        
        parentView.addSubview(constrainedTargetView)
        
        sut.present(
            statefulView: view,
            parentView: parentView,
            constrainedTargetView: constrainedTargetView)
        
        let constrained = view
            .constraints
            .flatMap { (constraint: NSLayoutConstraint) in
                [constraint.firstItem, constraint.secondItem]
            }
            .allSatisfy { $0 === view || $0 === constrainedTargetView }
        
        XCTAssertTrue(!view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(view.isDescendant(of: parentView))
        XCTAssertTrue(constrained)
    }
    
    func test_presentView_whenViewIsDescendantOfParentViewAldready() throws {
        let view = UIView()
        let parentView = UIView()
        let constrainedTargetView = UIView()
        
        parentView.addSubview(view)
        parentView.addSubview(constrainedTargetView)
        
        sut.present(
            statefulView: view,
            parentView: parentView,
            constrainedTargetView: constrainedTargetView)
        
        XCTAssertEqual(parentView.subviews.last, view)
    }
}
